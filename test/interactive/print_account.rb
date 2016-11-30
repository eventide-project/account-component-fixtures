require_relative '../client_test_init'

account_id = ENV['ACCOUNT_ID']

raise ArgumentError if account_id.nil?

store = AccountComponent::Store.build

account = store.get(account_id)

pp account
