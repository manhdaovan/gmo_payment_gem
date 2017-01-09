require 'test/unit'
require 'gmo_payment'
require 'helper'

class TestApiErrors < Test::Unit::TestCase
  def test_no_more_errors
    set_basic_config
    assert_equal(GmoPayment::ApiErrors.errors.size, GmoPayment::ApiErrors.all.size)
  end

  def test_has_more_errors
    more_errors = {
      more_errors: {'CE1' => 'CE1_VALUE',
                    'CE2' => 'CE2_VALUE'
      }
    }
    set_more_configs(more_errors)
    assert_equal(GmoPayment::ApiErrors.errors.size + 2, GmoPayment::ApiErrors.all.size)
    assert_equal('CE1_VALUE', GmoPayment::ApiErrors.all.fetch('CE1'))
  end

  def test_overwrite_errors
    more_errors = {
      more_errors: {
        'NC2000001' => 'NC2000001_VALUE',
        'CE2'       => 'CE2_VALUE'
      }
    }
    set_more_configs(more_errors)
    assert_equal(GmoPayment::ApiErrors.errors.size + 1, GmoPayment::ApiErrors.all.size)
    assert_equal('NC2000001_VALUE', GmoPayment::ApiErrors.all.fetch('NC2000001'))
  end
end
