require 'test/unit'
require 'gmo_payment'
require 'helper'

class TestApiRequest < Test::Unit::TestCase
  def test_make_request_valid
    url     = payment_base_url
    params  = {}
    timeout = 30 # Seconds
    request = GmoPayment::ApiRequest.new(url, params, timeout)
    stub_request_to_payment
    response = request.make_request
    assert_equal(true, response.is_a?(Net::HTTPOK))
  end

  def test_make_request_timeout
    url     = payment_base_url
    params  = {}
    timeout = 30 # Seconds
    request = GmoPayment::ApiRequest.new(url, params, timeout)
    stub_request_to_timeout
    begin
      request.make_request
    rescue => e
      assert_equal(true, e.is_a?(GmoPayment::CustomError))
    end
  end

  def test_params_has_been_hide
    url           = payment_base_url
    params        = {
      ShopID:   'shop_id',
      ShopPass: 'shop_pass',
      SiteID:   'site_id',
      SitePass: 'site_pass',
      CardNo:   12_345_678_901_234
    }
    expect_params = 'ShopID=*******&ShopPass=*********&SiteID=*******&SitePass=*********&CardNo=**************234&'
    timeout       = 30 # Seconds
    request       = GmoPayment::ApiRequest.new(url, params, timeout)
    assert_equal(expect_params, request.params2log)
  end
end
