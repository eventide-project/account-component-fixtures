module AccountComponent
  module Controls
    module Account
      def self.example(balance: nil, held: nil, sequence: nil)
        balance ||= Balance.amount
        held ||= 0

        account = AccountComponent::Account.build

        account.id = id
        account.customer_id = Customer.id
        account.opened_time = Time::Effective::Raw.example
        account.sequence = sequence unless sequence.nil?

        account.balance = balance
        account.held = held

        account
      end

      def self.id
        ID.example(increment: id_increment)
      end

      def self.id_increment
        11
      end

      def self.available_balance
        Cash.amount
      end

      def self.held
        1
      end

      module New
        def self.example
          AccountComponent::Account.build
        end
      end

      module Open
        def self.example
          Account.example
        end
      end

      module Balance
        def self.example
          Account.example(balance: self.amount)
        end

        def self.amount
          11.1
        end
      end

      module Held
        def self.example
          Account.example(balance: self.balance, held: self.amount)
        end

        def self.amount
          1.1
        end

        def self.balance
          11.1
        end
      end
    end
  end
end
