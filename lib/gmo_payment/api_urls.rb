class GmoPayment::ApiUrls

  BASE_PAYMENT_URL = GmoPayment::Configurations::CONFIGURATIONS[:base_url] || 'https://pt01.mul-pay.jp/payment'

  URLS = {
    # Transaction API URL
    'TRANSACTION_REGISTER'     => "#{BASE_PAYMENT_URL}/EntryTran.idPass",
    'TRANSACTION_SUBMIT'       => "#{BASE_PAYMENT_URL}/ExecTran.idPass",
    'TRANSACTION_UPDATE'       => "#{BASE_PAYMENT_URL}/AlterTran.idPass",
    'TRANSACTION_MONEY_CHANGE' => "#{BASE_PAYMENT_URL}/ChangeTran.idPass",
    'TRANSACTION_SEARCH'       => "#{BASE_PAYMENT_URL}/SearchTrade.idPass",

    # Member API URL
    'MEMBER_REGISTER'          => "#{BASE_PAYMENT_URL}/SaveMember.idPass",
    'MEMBER_UPDATE'            => "#{BASE_PAYMENT_URL}/UpdateMember.idPass",
    'MEMBER_SEARCH'            => "#{BASE_PAYMENT_URL}/SearchMember.idPass",
    'MEMBER_DELETE'            => "#{BASE_PAYMENT_URL}/DeleteMember.idPass",

    # Credit card API URL
    'CARD_SAVE_AFTER_TRADED'   => "#{BASE_PAYMENT_URL}/TradedCard.idPass",
    'CARD_SAVE_OR_UPDATE'      => "#{BASE_PAYMENT_URL}/SaveCard.idPass",
    'CARD_SEARCH'              => "#{BASE_PAYMENT_URL}/SearchCard.idPass",
    'CARD_DELETE'              => "#{BASE_PAYMENT_URL}/DeleteCard.idPass"
  }

  custom_urls = GmoPayment::Configurations::CONFIGURATIONS[:custom_urls] || {}
  custom_urls.each { |k, v| URLS[k] = v }
end