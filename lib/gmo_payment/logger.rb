class GmoPayment::Logger
  class << self
    def write(msg)
      log_path = GmoPayment::Configurations.all.fetch(:log_path)
      File.open(log_path, 'a+') do |f|
        f.write("#{Time.now} :: #{msg} \n")
      end
    end
  end
end