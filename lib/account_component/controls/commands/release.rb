module AccountComponent
  module Controls
    module Commands
      module Release
        def self.example
          release = AccountComponent::Messages::Commands::Release.build

          release.account_id = Account.id
          release.amount = amount
          release.time = Controls::Time::Effective.example

          release
        end

        def self.amount
          Cash.amount
        end
      end
    end
  end
end
