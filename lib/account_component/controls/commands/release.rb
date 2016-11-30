module AccountComponent
  module Controls
    module Commands
      module Release
        def self.example(sequence: nil)
          sequence ||= 0

          release = AccountComponent::Messages::Commands::Release.build

          release.account_id = Account.id
          release.amount = amount
          release.time = Controls::Time::Effective.example

          release.metadata.position = sequence

          release
        end

        def self.amount
          Cash.amount
        end
      end
    end
  end
end
