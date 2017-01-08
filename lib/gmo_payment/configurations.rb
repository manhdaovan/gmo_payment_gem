class GmoPayment::Configurations
  REQUIRED_CONFIG = [:base_url, :log_path, :shop_id, :shop_pass, :site_id, :site_pass]
  class << self
    attr_accessor :all
  end
  @all = {}

  def self.check_valid!
    self.all.freeze
    REQUIRED_CONFIG.each do |param|
      raise GmoPayment::CustomError.new("gmo_payment error: #{param} not set") if self.all.fetch(param, nil).nil?
    end
  end
end