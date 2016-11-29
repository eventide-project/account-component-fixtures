module AccountComponent
  module Controls
    module Commands
      module Hold
        def self.example(amount: nil)
          amount ||= self.amount

          hold = AccountComponent::Messages::Commands::Hold.build

          hold.account_id = Account.id
          hold.amount = amount
          hold.time = Controls::Time::Effective.example

          hold
        end

        def self.amount
          Cash.amount
        end
      end
    end
  end
end
