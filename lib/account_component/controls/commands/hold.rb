module AccountComponent
  module Controls
    module Commands
      module Hold
        def self.example(amount: nil, sequence: nil)
          amount ||= self.amount
          sequence ||= 0

          hold = AccountComponent::Messages::Commands::Hold.build

          hold.account_id = Account.id
          hold.amount = amount
          hold.time = Controls::Time::Effective.example

          hold.metadata.position = sequence

          hold
        end

        def self.amount
          Cash.amount
        end
      end
    end
  end
end
