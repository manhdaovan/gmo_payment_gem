require 'rails'

class GmoPayment::Railtie < Rails::Railtie
  initializer 'gmo_payment.config' do |app|
    GmoPayment::Configurations::CONFIGURATIONS            = app.config.gmo_payment if app.config.respond_to?(:gmo_payment)
    GmoPayment::Configurations::CONFIGURATIONS[:log_path] ||= "#{app.config.root.to_s}/log/gmo_payment.log"
  end
end