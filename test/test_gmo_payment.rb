require 'test/unit'
require 'gmo_payment'
require 'helper'

class TestGmoPayment < Test::Unit::TestCase
  def test_public_methods
    set_basic_config
    gmo_payment = GmoPayment.new
    api_methods = gmo_payment.public_methods(false)
    stub_request_to_payment
    api_methods.each do |api_call|
      response = gmo_payment.public_send(api_call)
      assert_equal(GmoPayment::ApiResponse, response.class)
    end
  end
end
