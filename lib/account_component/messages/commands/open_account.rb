module AccountComponent
  module Messages
    module Commands
      class OpenAccount
        include EventStore::Messaging::Message

        attribute :account_id, String
        attribute :customer_id, String
        attribute :time, String
      end
    end
  end
end
