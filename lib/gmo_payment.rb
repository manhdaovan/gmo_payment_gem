class GmoPayment
  def initialize(options = {}, type_site = true, logger = nil)
    @base_params = if type_site
                     {
                       SiteID:   GmoPayment::Configurations.all.fetch(:site_id),
                       SitePass: GmoPayment::Configurations.all.fetch(:site_pass)
                     }
                   else
                     {
                       ShopID:   GmoPayment::Configurations.all.fetch(:shop_id),
                       ShopPass: GmoPayment::Configurations.all.fetch(:shop_pass)
                     }
                   end
    @time_out    = options.fetch(:time_out, nil)
    @logger      = logger || GmoPayment::Logger
  end

  def register_member(params = {})
    api_url = GmoPayment::ApiUrls.all.fetch('MEMBER_REGISTER')
    call_api(api_url, params)
  end

  def delete_member(params = {})
    api_url = GmoPayment::ApiUrls.all.fetch('MEMBER_DELETE')
    call_api(api_url, params)
  end

  def search_member(params = {})
    api_url = GmoPayment::ApiUrls.all.fetch('MEMBER_SEARCH')
    call_api(api_url, params)
  end

  def save_card(params = {})
    api_url = GmoPayment::ApiUrls.all.fetch('CARD_SAVE_OR_UPDATE')
    call_api(api_url, params)
  end

  def delete_card(params = {})
    api_url = GmoPayment::ApiUrls.all.fetch('CARD_DELETE')
    call_api(api_url, params)
  end

  # Transaction normal flow
  # Register > Submit with :JobCd = 'CAPTURE'
  # Register > Submit > Confirm with :JobCd != 'CAPTURE'
  def register_transaction(params = {})
    api_url = GmoPayment::ApiUrls.all.fetch('TRANSACTION_REGISTER')
    call_api(api_url, params)
  end

  def submit_transaction(params = {})
    api_url = GmoPayment::ApiUrls.all.fetch('TRANSACTION_SUBMIT')
    call_api(api_url, params)
  end

  def confirm_transaction(params = {})
    api_url = GmoPayment::ApiUrls.all.fetch('TRANSACTION_UPDATE')
    call_api(api_url, params)
  end

  def transaction_status(params = {})
    api_url = GmoPayment::ApiUrls.all.fetch('TRANSACTION_SEARCH')
    call_api(api_url, params)
  end

  protected

  def call_api(api_url, params = {}, method = 'post')
    params.merge!(@base_params)
    request = GmoPayment::ApiRequest.new(api_url, params, @time_out)
    write_log('---------- START REQUEST TO GMO PAYMENT --------')
    write_log("REQUEST URL: --------- #{api_url}")
    write_log("REQUEST PARAMS: ------ #{request.params2log}")
    response_raw = request.make_request(method)
    response     = GmoPayment::ApiResponse.new(api_url, response_raw.body, response_raw.code.to_i)
    write_log("RESPONSE: ------------ HTTP #{response.response_code}: #{response.response2log}")
    write_log("WITH ERRORS: --------- #{response.full_errors2log}")
    write_log(%(----------- END REQUEST TO GMO PAYMENT --------\n))
    response
  rescue StandardError => e
    write_log("gmo_payment INTERNAL ERROR: #{e.message} : #{e.backtrace[0, 5]}")
    raise GmoPayment::CustomError, "gmo_payment error: #{e.message}"
  end

  private

  def write_log(log_msg)
    @logger.write(log_msg)
  end
end

require 'gmo_payment/configurations'
require 'gmo_payment/api_urls'
require 'gmo_payment/api_errors'
require 'gmo_payment/logger'
require 'gmo_payment/api_request'
require 'gmo_payment/api_response'
require 'gmo_payment/custom_error'
