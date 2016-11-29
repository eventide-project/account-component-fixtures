module AccountComponent
  module Controls
    module Events
      module AccountOpened
        def self.example
          account_opened = AccountComponent::Messages::Events::AccountOpened.build

          account_opened.account_id = Account.id
          account_opened.customer_id = Customer.id
          account_opened.time = Controls::Time::Effective.example
          account_opened.processed_time = Controls::Time::Processed.example
          account_opened.sequence = sequence

          account_opened
        end

        def self.sequence
          Sequence.example
        end
      end
    end
  end
end
