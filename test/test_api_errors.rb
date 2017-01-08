require 'test/unit'
require 'gmo_payment'
require 'helper'

class TestApiErrors < Test::Unit::TestCase
  def test_no_custom_errors
    set_basic_config
    assert_equal(GmoPayment::ApiErrors.errors.size, GmoPayment::ApiErrors.all.size)
  end

  def test_has_custom_errors
    custom_errors = {
      custom_errors: {'CE1' => 'CE1',
                      'CE2' => 'CE2'
      }
    }
    set_custom_errors_config(custom_errors)
    assert_equal(GmoPayment::ApiErrors.errors.size + 2, GmoPayment::ApiErrors.all.size)
  end
end
