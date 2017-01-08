require 'net/http'
require 'net/https'
require 'uri'

class GmoPayment

  DEFAULT_TIME_OUT = 30 # seconds
  OK_RESPONSE_CODE = [200, 201]
  SPLIT_CHARACTER  = '|'
  ENCODE_PARAMS    = %w(CardNo SiteID SitePass ShopID ShopPass)

  attr_accessor :response_code, :response_body_raw, :api_url, :logger
  attr_reader :base_params, :time_out

  def initialize(options={}, is_site = true, logger = nil)
    @base_params = if is_site
                     {
                       SiteID:   GmoPayment::Configurations::CONFIGURATIONS[:site_id],
                       SitePass: GmoPayment::Configurations::CONFIGURATIONS[:site_pass]
                     }
                   else
                     {
                       ShopID:   GmoPayment::Configurations::CONFIGURATIONS[:shop_id],
                       ShopPass: GmoPayment::Configurations::CONFIGURATIONS[:shop_pass]
                     }
                   end
    @time_out    = options[:time_out] || DEFAULT_TIME_OUT
    @logger      = logger || GmoPayment::Logger
  end

  def register_member(options = {})
    @api_url = GmoPayment::ApiUrls::URLS['MEMBER_REGISTER']
    call_api options
  end

  def delete_member(options = {})
    @api_url = GmoPayment::ApiUrls::URLS['MEMBER_DELETE']
    call_api options
  end

  def search_member(options = {})
    @api_url = GmoPayment::ApiUrls::URLS['MEMBER_SEARCH']
    call_api options
  end

  def save_card(options={})
    @api_url = GmoPayment::ApiUrls::URLS['CARD_SAVE_OR_UPDATE']
    call_api options
  end

  def delete_card(options={})
    @api_url = GmoPayment::ApiUrls::URLS['CARD_DELETE']
    call_api options
  end

  # Transaction normal flow
  # Register > Submit with :JobCd = 'CAPTURE'
  # Register > Submit > Confirm with :JobCd != 'CAPTURE'
  def register_transaction(options={})
    @api_url = GmoPayment::ApiUrls::URLS['TRANSACTION_REGISTER']
    call_api options
  end

  def submit_transaction(options={})
    @api_url = GmoPayment::ApiUrls::URLS['TRANSACTION_SUBMIT']
    call_api options
  end

  def confirm_transaction(options={})
    @api_url = GmoPayment::ApiUrls::URLS['TRANSACTION_UPDATE']
    call_api options
  end

  def transaction_status(options={})
    @api_url = GmoPayment::ApiUrls::URLS['TRANSACTION_SEARCH']
    call_api options
  end

  def get_response_code
    @response_code.to_i
  end

  def get_response_body(raw = false)
    raw ? @response_body_raw : parse_response_content
  end

  def error_codes
    r_detail = get_response_body
    r_detail.fetch(:ErrCode, '').split(SPLIT_CHARACTER)
  end

  def error_infos
    r_detail = get_response_body
    r_detail.fetch(:ErrInfo, '').split(SPLIT_CHARACTER)
  end

  def error_messages
    error_infos.map { |e_code| GmoPayment::ApiErrors::ERRORS.fetch(e_code, "UNKNOWN ERROR with code #{e_code}") }
  end

  def full_messages
    error_messages.join(' ')
  end

  def has_error?(error_info_code)
    error_infos.include?(error_info_code)
  end

  def success?
    r_detail      = get_response_body
    pre_condition = OK_RESPONSE_CODE.include?(get_response_code) && !r_detail.key?(:ErrCode)
    case @api_url
    when GmoPayment::ApiUrls::URLS['MEMBER_REGISTER'],
      GmoPayment::ApiUrls::URLS['MEMBER_DELETE'],
      GmoPayment::ApiUrls::URLS['MEMBER_SEARCH']
      pre_condition && r_detail.key?(:MemberID)
    when GmoPayment::ApiUrls::URLS['CARD_SAVE_OR_UPDATE']
      pre_condition && r_detail.key?(:CardSeq) && r_detail.key?(:CardNo)
    when GmoPayment::ApiUrls::URLS['CARD_DELETE']
      pre_condition && r_detail.key?(:CardSeq)
    when GmoPayment::ApiUrls::URLS['TRANSACTION_REGISTER']
      pre_condition && r_detail.key?(:AccessID) && r_detail.key?(:AccessPass)
    when GmoPayment::ApiUrls::URLS['TRANSACTION_SUBMIT']
      pre_condition && r_detail.key?(:TranID) && r_detail.key?(:CheckString)
    when GmoPayment::ApiUrls::URLS['TRANSACTION_UPDATE']
      pre_condition && r_detail.key?(:AccessID) && r_detail.key?(:AccessPass)
    else
      pre_condition
    end
  end

  private

  def call_api(options={}, verb = 'post')
    fail("INVALID API URL with value: #{@api_url}") unless @api_url.length > 0

    options.merge!(@base_params)
    base_url, path = get_base_url_and_path
    http           = init_http_request(base_url)
    begin
      http.start
      response = if verb.downcase == 'post'
                   http.post(path, to_query_params(options))
                 else
                   http.get(path, to_query_params(options))
                 end
    ensure
      http.finish
    end
    @response_code     = response.code.to_i
    @response_body_raw = response.body
    write_log("RESPONSE ------ #{get_response_body}")
    write_log("ERROR --------- #{full_messages}")
  end

  def get_base_url_and_path
    uri = URI.parse(@api_url)
    write_log("URI ----------- #{uri.inspect}")
    [uri.host, uri.path]
  end

  def init_http_request(base_url)
    http              = Net::HTTP.new(base_url, 443) #SSL port
    http.open_timeout = @time_out
    http.read_timeout = @time_out
    http.use_ssl      = true
    http
  end

  def to_query_params(options={})
    str = ''
    options.each { |k, v| str << "#{k}=#{v}&" }
    write_log("PARAMS -------- #{str}")
    str
  end

  def parse_response_content

    result = {}
    return result unless @response_body_raw && @response_body_raw.size > 0
    begin
      @response_body_raw.split('&').each { |r| result[r.split('=')[0].to_sym] = r.split('=')[1] }
      result
    rescue
      result
    end
  end

  def write_log(log_msg, encode = true)
    log_msg = encode_params(log_msg) if encode
    @logger.write(log_msg)
  end

  # Encode params string to *** format
  # Eg: CardNo=1234567890123 to CardNo=*********0123
  def encode_params(log_msg)
    params_patterns = "(#{ENCODE_PARAMS.join('|')})=\\w+"
    log_msg.gsub(Regexp.new(params_patterns)) { |match| "#{hide_value(match)}" }
  end

  # Hide all value if value length <= 10
  # Otherwise show last 4 characters
  def hide_value(param_n_value)
    param, value = param_n_value.split('=')
    v_hide       = '*' * value.length
    v_hide << value[-3..-1] if value.length > 10
    "#{param}=#{v_hide}"
  end
end

require 'gmo_payment/railtie'
require 'gmo_payment/configurations'
require 'gmo_payment/api_urls'
require 'gmo_payment/api_errors'
require 'gmo_payment/logger'

