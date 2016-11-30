require_relative '../client_test_init'

account_id = ENV['ACCOUNT_ID']
amount = ENV['AMOUNT'].to_i

raise ArgumentError if account_id.nil? or amount.nil?

Client::Hold.(account_id, amount)
