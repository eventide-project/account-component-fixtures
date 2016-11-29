module AccountComponent
  module Controls
    module Commands
      module Deposit
        def self.example
          deposit = AccountComponent::Messages::Commands::Deposit.build

          deposit.account_id = Account.id
          deposit.amount = amount
          deposit.time = Controls::Time::Effective.example

          deposit
        end

        def self.amount
          Cash.amount
        end
      end
    end
  end
end
