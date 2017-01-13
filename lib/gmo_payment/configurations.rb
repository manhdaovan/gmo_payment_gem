module GmoPayment
  class Configurations
    REQUIRED_CONFIG = [:base_url, :log_path, :shop_id, :shop_pass, :site_id, :site_pass].freeze
    class << self
      attr_accessor :all
    end
    @all = {}

    def self.check_valid!(changeable_on_runtime = false)
      freeze unless changeable_on_runtime
      REQUIRED_CONFIG.each do |param|
        raise GmoPayment::CustomError, "gmo_payment error: #{param} not set" if all.fetch(param, nil).nil?
      end
    end
  end
end
