class GmoPayment::ApiResponse

  RESPONSE_SUCCESS_CODE = [200, 201]
  SPLIT_CHARACTER       = '|'

  attr_reader :response_body, :response_http_code, :response_body_parsed

  def initialize(api_url, body, response_http_code)
    @api_url              = api_url
    @response_body        = body
    @response_http_code   = response_http_code
    @response_body_parsed = parse_response_content
  end

  def response_code
    @response_http_code
  end

  def get_response_body(raw = false)
    raw ? @response_body : @response_body_parsed
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
    error_infos.map { |e_code| GmoPayment::ApiErrors.all.fetch(e_code, "UNKNOWN ERROR with code #{e_code}") }
  end

  def full_messages
    error_messages.join(' ')
  end

  def has_error?(error_info_code)
    error_infos.include?(error_info_code)
  end

  def success?
    if block_given?
      yield(@api_url, @response_http_code, @response_body, @response_body_parsed)
    else
      r_detail      = get_response_body
      pre_condition = RESPONSE_SUCCESS_CODE.include?(response_code) && !r_detail.key?(:ErrCode)
      case @api_url
      when GmoPayment::ApiUrls.all.fetch('MEMBER_REGISTER'),
        GmoPayment::ApiUrls.all.fetch('MEMBER_DELETE'),
        GmoPayment::ApiUrls.all.fetch('MEMBER_SEARCH')
        pre_condition && r_detail.key?(:MemberID)
      when GmoPayment::ApiUrls.all.fetch('CARD_SAVE_OR_UPDATE')
        pre_condition && r_detail.key?(:CardSeq) && r_detail.key?(:CardNo)
      when GmoPayment::ApiUrls.all.fetch('CARD_DELETE')
        pre_condition && r_detail.key?(:CardSeq)
      when GmoPayment::ApiUrls.all.fetch('TRANSACTION_REGISTER')
        pre_condition && r_detail.key?(:AccessID) && r_detail.key?(:AccessPass)
      when GmoPayment::ApiUrls.all.fetch('TRANSACTION_SUBMIT')
        pre_condition && r_detail.key?(:TranID) && r_detail.key?(:CheckString)
      when GmoPayment::ApiUrls.all.fetch('TRANSACTION_UPDATE')
        pre_condition && r_detail.key?(:AccessID) && r_detail.key?(:AccessPass)
      else
        pre_condition
      end
    end
  end

  def response2log
    get_response_body
  end

  def full_errors2log
    full_messages
  end

  private

  def parse_response_content
    result = {}
    return result unless @response_body && @response_body.size > 0
    begin
      @response_body.split('&').each do |key_value|
        key, value         = key_value.split('=')
        result[key.to_sym] = value
      end
      result
    rescue
      result
    end
  end
end