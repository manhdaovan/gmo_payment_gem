module GmoPayment
  class Logger
    DEFAULT_LOG_PATH = File.join(Rails.root, '/log/gmo_payment.log')
    class << self
      def write(msg)
        File.open(DEFAULT_LOG_PATH, 'a+') do |f|
          f.write("#{Time.now} :: #{msg} \n")
        end
      end
    end
  end
end