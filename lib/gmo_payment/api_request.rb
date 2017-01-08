require 'uri'
require 'net/http'
require 'net/https'

class GmoPayment::ApiRequest

  DEFAULT_TIMEOUT = 30 # Seconds
  ENCODE_PARAMS    = %w(CardNo SiteID SitePass ShopID ShopPass)

  def initialize(request_url, request_params, timeout)
    @request_url = request_url
    @request_params = request_params
    @time_out = timeout || DEFAULT_TIMEOUT
    @requester = nil
  end

  def make_request(method = 'post')
    host, path = get_base_url_and_path
    @requester = init_http_request(host)
    begin
      @requester.start
      response = if method.downcase == 'post'
                   @requester.post(path, to_query_params(@request_params))
                 else
                   @requester.get(path, to_query_params(@request_params))
                 end
    ensure
      @requester.finish
    end
    response
  end

  def params2log
    encode_params(to_query_params(@request_params))
  end

  private

  def get_base_url_and_path
    uri = URI.parse(@request_url)
    [uri.host, uri.path]
  end

  def init_http_request(host)
    http              = Net::HTTP.new(host, 443) #SSL port
    http.open_timeout = @time_out
    http.read_timeout = @time_out
    http.use_ssl      = true
    http
  end

  def to_query_params(options={})
    str = ''
    options.each { |k, v| str << "#{k}=#{v}&" }
    str
  end

  # Encode params string to *** format
  # Eg: CardNo=1234567890123 to CardNo=*********123
  def encode_params(log_msg)
    params_patterns = "(#{ENCODE_PARAMS.join('|')})=\\w+"
    log_msg.gsub(Regexp.new(params_patterns)) { |match| "#{hide_value(match)}" }
  end

  # Hide all value if value length <= 10
  # Otherwise show last 3 characters
  def hide_value(param_n_value)
    param, value = param_n_value.split('=')
    v_hide       = '*' * value.length
    v_hide << value[-3..-1] if value.length > 10
    "#{param}=#{v_hide}"
  end
end