require 'gmo_payment'
require 'gmo_payment/custom_error'
require 'gmo_payment/configurations'

def basic_setting
  {
    site_id:   'site_id',
    site_pass: 'site_id',
    shop_id:   'site_id',
    shop_pass: 'site_id',
    log_path:  File.expand_path(File.dirname(__FILE__), '/logs/site_id.log'),
    base_url:  'https://pt01.mul-pay.jp/payment'
  }
end

def set_basic_config
  GmoPayment::Configurations.all = basic_setting
end

def clear_config
  GmoPayment::Configurations.all = {}
end

def set_custom_errors_config(custom_errors)
  GmoPayment::Configurations.all = basic_setting.merge(custom_errors)
end
