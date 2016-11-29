module AccountComponent
  module Controls
    module Events
      module Withdrawn
        def self.example
          withdrawn = AccountComponent::Messages::Events::Withdrawn.build

          withdrawn.account_id = Account.id
          withdrawn.amount = Cash.amount
          withdrawn.time = Controls::Time::Effective.example
          withdrawn.processed_time = Controls::Time::Processed.example
          withdrawn.sequence = sequence

          withdrawn
        end

        def self.sequence
          Sequence.example
        end
      end
    end
  end
end
