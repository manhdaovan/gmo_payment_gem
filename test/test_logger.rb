require 'test/unit'
require 'gmo_payment'
require 'helper'

class TestLogger < Test::Unit::TestCase
  def test_write_log_success
    set_basic_config
    log_msg = 'this is a log'
    GmoPayment::Logger.write(log_msg)
    log_on_file = false
    File.open(GmoPayment::Configurations.all.fetch(:log_path), 'r') do |f|
      f.each_line { |line| log_on_file = true if line.index(log_msg).to_i >= 0 }
    end
    assert_equal(true, log_on_file)
  end

  def test_log_path_not_found
    clear_config
    log_msg = 'this is a log'
    begin
      GmoPayment::Logger.write(log_msg)
    rescue => e
      assert_equal(true, e.is_a?(KeyError))
    end
  end
end
