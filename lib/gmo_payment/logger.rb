class GmoPayment::Logger
  class << self
    def write(msg)
      File.open(GmoPayment::Configurations::CONFIGURATIONS[:log_path], 'a+') do |f|
        f.write("#{Time.now} :: #{msg} \n")
      end
    end
  end
end