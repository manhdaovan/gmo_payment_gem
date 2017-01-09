require 'webmock/test_unit'
require 'gmo_payment'
require 'gmo_payment/custom_error'
require 'gmo_payment/configurations'

def payment_base_url
  'https://test-example.com/payment'
end

def stub_request_to_payment(res_status = 200, res_body = '')
  stub_request(:any, /test-example.com\/payment/)
    .with(headers: {
            'Accept'          => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'      => 'Ruby'
          })
    .to_return(status: res_status, body: res_body, headers: {})
end

def stub_request_to_timeout
  stub_request(:any, payment_base_url)
    .with(headers: {
            'Accept'          => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent'      => 'Ruby'
          })
    .to_raise(GmoPayment::CustomError)
end

def basic_setting
  {
    site_id:   'site_id',
    site_pass: 'site_id',
    shop_id:   'site_id',
    shop_pass: 'site_id',
    log_path:  File.join(File.dirname(__FILE__), '/logs/test.log'),
    base_url:  payment_base_url
  }
end

def set_basic_config
  GmoPayment::Configurations.all = basic_setting
end

def clear_config
  GmoPayment::Configurations.all = {}
end

def set_more_configs(more_configs)
  GmoPayment::Configurations.all = basic_setting.merge(more_configs)
end
