class GmoPayment::ApiUrls
  class << self
    attr_accessor :urls
  end
  @urls = {}

  def self.all
    if frozen?
      urls
    else
      base_payment_url = GmoPayment::Configurations.all.fetch(:base_url)
      basic_urls       = {
        # Transaction API URL
        'TRANSACTION_REGISTER'     => "#{base_payment_url}/EntryTran.idPass",
        'TRANSACTION_SUBMIT'       => "#{base_payment_url}/ExecTran.idPass",
        'TRANSACTION_UPDATE'       => "#{base_payment_url}/AlterTran.idPass",
        'TRANSACTION_MONEY_CHANGE' => "#{base_payment_url}/ChangeTran.idPass",
        'TRANSACTION_SEARCH'       => "#{base_payment_url}/SearchTrade.idPass",

        # Member API URL
        'MEMBER_REGISTER'          => "#{base_payment_url}/SaveMember.idPass",
        'MEMBER_UPDATE'            => "#{base_payment_url}/UpdateMember.idPass",
        'MEMBER_SEARCH'            => "#{base_payment_url}/SearchMember.idPass",
        'MEMBER_DELETE'            => "#{base_payment_url}/DeleteMember.idPass",

        # Credit card API URL
        'CARD_SAVE_AFTER_TRADED'   => "#{base_payment_url}/TradedCard.idPass",
        'CARD_SAVE_OR_UPDATE'      => "#{base_payment_url}/SaveCard.idPass",
        'CARD_SEARCH'              => "#{base_payment_url}/SearchCard.idPass",
        'CARD_DELETE'              => "#{base_payment_url}/DeleteCard.idPass"
      }

      more_urls = GmoPayment::Configurations.all.fetch(:more_urls, {})
      self.urls = basic_urls.merge(more_urls)
      freeze
      urls
    end
  end
end
