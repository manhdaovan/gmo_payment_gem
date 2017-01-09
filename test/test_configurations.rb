require 'test/unit'
require 'gmo_payment'
require 'helper'

class TestConfigurations < Test::Unit::TestCase
  def test_check_valid_success
    set_basic_config
    assert_equal(GmoPayment::Configurations::REQUIRED_CONFIG, GmoPayment::Configurations.check_valid!(true))
  end

  def test_check_valid_fail
    clear_config
    begin
      GmoPayment::Configurations.check_valid!(true)
    rescue => e
      assert_equal(true, e.is_a?(GmoPayment::CustomError))
      assert_equal('gmo_payment error: base_url not set', e.message)
    end
  end
end
