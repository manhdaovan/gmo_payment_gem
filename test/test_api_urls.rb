require 'test/unit'
require 'gmo_payment'
require 'helper'

class TestApiUrls < Test::Unit::TestCase
  def test_all_with_no_more_url
    set_basic_config
    assert_equal(13, GmoPayment::ApiUrls.all.size)
  end

  def test_all_with_more_urls
    more_urls = {
      more_urls: {
        'MORE_PAYMENT_URL1' => 'MORE_PAYMENT_URL1_VALUE',
        'MORE_PAYMENT_URL2' => 'MORE_PAYMENT_URL2_VALUE'
      }
    }
    set_more_configs(more_urls)
    assert_equal(13 + 2, GmoPayment::ApiUrls.dup.all.size)
  end
end
