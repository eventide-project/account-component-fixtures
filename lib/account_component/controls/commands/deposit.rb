module AccountComponent
  module Controls
    module Commands
      module Deposit
        def self.example(sequence: nil)
          sequence ||= 0

          deposit = AccountComponent::Messages::Commands::Deposit.build

          deposit.account_id = Account.id
          deposit.amount = amount
          deposit.time = Controls::Time::Effective.example

          deposit.metadata.position = sequence

          deposit
        end

        def self.amount
          Cash.amount
        end
      end
    end
  end
end
