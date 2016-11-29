module AccountComponent
  module Messages
    module Events
      class AccountOpened
        include Messaging::Message

        attribute :account_id, String
        attribute :customer_id, String
        attribute :time, String
        attribute :processed_time, String
        attribute :sequence, Numeric
      end
    end
  end
end
