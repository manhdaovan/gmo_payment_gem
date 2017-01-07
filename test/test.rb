require File.expand_path(File.dirname(__FILE__) + '/constant')
require File.expand_path(File.dirname(__FILE__) + '/gmo')

class GmoTest
  def register_member
    begin
      gmo = Payment::GMO.new
      options = {:MemberID => 12, :MemberName => 'TEST REG MEMBER'}
      gmo.register_member(options)

      puts "register_member ---------", gmo.get_response_code, gmo.get_response_body
    rescue StandardError => e
      puts e.message, e.backtrace[0, 3]
    end
  end

  def delete_member
    begin
      gmo = Payment::GMO.new
      options = {:MemberID => 12}
      gmo.delete_member(options)

      puts "delete_member ---------", gmo.get_response_code, gmo.get_response_body
    rescue StandardError => e
      puts e.message, e.backtrace[0, 3]
    end
  end

  def search_member
    begin
      gmo = Payment::GMO.new
      options = {:MemberID => 12}

      gmo.search_member(options)
      puts "search_member ---------", gmo.get_response_code, gmo.get_response_body
    rescue StandardError => e
      puts e.message, e.backtrace[0, 3]
    end
  end

  def save_card
    gmo = Payment::GMO.new
    options_card = {:MemberID => '4',
                    :CardNo => '4111111111111111',
                    # :CardNo => '4999000000000002',
                    :Expire => '2002',
                    :HolderName => 'MANH DV'}

    gmo.save_card(options_card)
    puts "save_card ---------", gmo.get_response_code, gmo.get_response_body
  end

  def transaction_status
    gmo_shop = Payment::GMO.new({}, false)
    options = {
        # :OrderID => 'HPONL-PEQSU-XNWUQ-HACLI'
        :OrderID => 'AMIGQ-RGMOV-RTSKH-TABLG'
    }

    gmo_shop.transaction_status(options)
    puts "transaction_status ---------", gmo_shop.get_response_code, gmo_shop.get_response_body
  end

  def submit_transaction
    gmo_site = Payment::GMO.new
    options = {
        :AccessID => "cf4cec66f7f1a5dcdbfac2a8a3f6bc9a",
        :AccessPass => "9c3d5991eb94b50ea35ea9427ce32dc7",
        :OrderID => "ADZBQ-CYOTC-ZZNCF-NCPHJ",
        :Method => "1",
        :CardNo => "4111111111111111",
        :Expire => "1603"
    }

    gmo_site.submit_transaction(options)
    puts "transaction_status ---------", gmo_site.get_response_code, gmo_site.get_response_body
  end
end

available_commands = %w(register_member delete_member search_member save_card transaction_status submit_transaction)
if available_commands.include?(ARGV[0])
  testObj = GmoTest.new
  testObj.public_send(ARGV[0])
else
  puts "Please using command in: ", available_commands.inspect
end
