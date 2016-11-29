require_relative '../client_test_init'

account_id = ENV['ACCOUNT_ID']
customer_id = ENV['CUSTOMER_ID']

account_id ||= Identifier::UUID::Random.get

raise ArgumentError if customer_id.nil?

Client::OpenAccount.(account_id, customer_id)

puts account_id
