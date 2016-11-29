module AccountComponent
  module Controls
    module Commands
      module OpenAccount
        def self.example
          open_account = AccountComponent::Messages::Commands::OpenAccount.build

          open_account.account_id = Account.id
          open_account.customer_id = Customer.id
          open_account.time = Controls::Time::Effective.example

          open_account
        end
      end
    end
  end
end
