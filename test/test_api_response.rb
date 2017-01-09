require 'test/unit'
require 'gmo_payment'
require 'helper'

class TestApiResponse < Test::Unit::TestCase
  def test_response_code
    response = GmoPayment::ApiResponse.new(payment_base_url, '', 200)
    assert_equal(200, response.response_code)
  end

  def test_response_body_raw
    response_body = 'BODY RAW'
    response      = GmoPayment::ApiResponse.new(payment_base_url, response_body, 200)
    assert_equal(response_body, response.response_body(true))
  end

  def test_response_body_parsed
    response_body      = 'something=123&somethingelse=456'
    expect_parsed_body = {
      something:     '123',
      somethingelse: '456'
    }
    response = GmoPayment::ApiResponse.new(payment_base_url, response_body, 200)
    assert_equal(expect_parsed_body, response.response_body)
  end

  def test_error_codes_and_infos
    response_body    = 'ErrCode=123|456|789&ErrInfo=ErrInfo1|ErrInfo2'
    expect_err_codes = %w(123 456 789)
    expect_err_infos = %w(ErrInfo1 ErrInfo2)
    response         = GmoPayment::ApiResponse.new(payment_base_url, response_body, 200)
    assert_equal(expect_err_codes, response.error_codes)
    assert_equal(expect_err_infos, response.error_infos)
  end

  def test_error_in_errors_list
    response_body        = 'ErrCode=123|456|789&ErrInfo=E00000000|E01010001|E01010008'
    expect_err_messages  = ['特になし',
                            'ショップIDが指定されていません。',
                            'ショップIDに半角英数字以外の文字が含まれているか、13文字を超えています。']
    expect_full_messages = expect_err_messages.join(' ')
    response             = GmoPayment::ApiResponse.new(payment_base_url, response_body, 200)
    assert_equal(expect_err_messages, response.error_messages)
    assert_equal(expect_full_messages, response.full_messages)
    assert_equal(expect_full_messages, response.full_errors2log)
  end

  def test_error_not_in_errors_list
    response_body        = 'ErrCode=123|456|789&ErrInfo=EXXX|EYYY|EZZZ'
    expect_err_messages  = ['UNKNOWN ERROR with code EXXX',
                            'UNKNOWN ERROR with code EYYY',
                            'UNKNOWN ERROR with code EZZZ']
    expect_full_messages = expect_err_messages.join(' ')
    response             = GmoPayment::ApiResponse.new(payment_base_url, response_body, 200)
    assert_equal(expect_err_messages, response.error_messages)
    assert_equal(expect_full_messages, response.full_messages)
    assert_equal(expect_full_messages, response.full_errors2log)
  end

  def test_no_error
    response_body        = 'somthing=123&somethingelse=456'
    expect_err_messages  = []
    expect_full_messages = ''
    response             = GmoPayment::ApiResponse.new(payment_base_url, response_body, 200)
    assert_equal(expect_err_messages, response.error_messages)
    assert_equal(expect_full_messages, response.full_messages)
    assert_equal(expect_full_messages, response.full_errors2log)
  end

  def test_success_without_block
    set_basic_config
    api_url_key   = 'TRANSACTION_REGISTER'
    api_url       = GmoPayment::ApiUrls.all.fetch(api_url_key)
    response_body = 'AccessID=123&AccessPass=456'
    response      = GmoPayment::ApiResponse.new(api_url, response_body, 200)
    assert_equal(true, response.success?)
  end

  def test_success_with_block
    set_basic_config
    api_url_key   = 'TRANSACTION_REGISTER'
    api_url       = GmoPayment::ApiUrls.all.fetch(api_url_key)
    response_body = 'AccessID=123&AccessPass=456'
    response      = GmoPayment::ApiResponse.new(api_url, response_body, 200)
    assert_equal(true, response.success? { |_, _, _, _| true })
  end

  def test_success_fail_by_http_code
    set_basic_config
    api_url_key   = 'TRANSACTION_REGISTER'
    api_url       = GmoPayment::ApiUrls.all.fetch(api_url_key)
    response_body = 'AccessID=123&AccessPass=456'
    response      = GmoPayment::ApiResponse.new(api_url, response_body, 400)
    assert_equal(false, response.success?)
  end

  def test_success_fail_by_has_error
    set_basic_config
    api_url_key   = 'TRANSACTION_REGISTER'
    api_url       = GmoPayment::ApiUrls.all.fetch(api_url_key)
    response_body = 'ErrCode=123'
    response      = GmoPayment::ApiResponse.new(api_url, response_body, 400)
    assert_equal(false, response.success?)
  end
end
