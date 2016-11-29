module AccountComponent
  module Controls
    module Events
      module Deposited
        def self.example
          deposited = AccountComponent::Messages::Events::Deposited.build

          deposited.account_id = Account.id
          deposited.amount = Cash.amount
          deposited.time = Controls::Time::Effective.example
          deposited.processed_time = Controls::Time::Processed.example
          deposited.sequence = sequence

          deposited
        end

        def self.sequence
          Sequence.example
        end
      end
    end
  end
end
