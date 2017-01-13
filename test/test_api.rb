require 'test/unit'
require 'gmo_payment'
require 'helper'

class TestApi < Test::Unit::TestCase
  def test_public_methods
    set_basic_config
    gmo_payment     = GmoPayment::Api.new
    exclude_methods = [:inspect, :instance_variable_get]
    api_methods     = gmo_payment.public_methods(false) - exclude_methods
    stub_request_to_payment
    api_methods.each do |api_call|
      response = gmo_payment.public_send(api_call)
      assert_equal(GmoPayment::ApiResponse, response.class)
    end
  end

  def test_inspect
    set_basic_config
    gmo_payment = GmoPayment::Api.new
    assert_equal(true, (gmo_payment.inspect =~ /@/).nil?)
  end

  def test_instance_variable_get
    set_basic_config
    gmo_payment = GmoPayment::Api.new
    begin
      gmo_payment.instance_variable_get(:@base_params)
    rescue => e
      assert_equal(true, e.is_a?(GmoPayment::CustomError))
      assert_equal('Not support this method', e.message)
    end
  end
end
