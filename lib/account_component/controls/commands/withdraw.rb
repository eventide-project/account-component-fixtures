module AccountComponent
  module Controls
    module Commands
      module Withdraw
        def self.example(amount: nil, sequence: nil)
          amount ||= self.amount
          sequence ||= 0

          withdraw = AccountComponent::Messages::Commands::Withdraw.build

          withdraw.account_id = Account.id
          withdraw.amount = amount
          withdraw.time = Controls::Time::Effective.example

          withdraw.metadata.position = sequence

          withdraw
        end

        def self.amount
          Cash.amount
        end
      end
    end
  end
end
