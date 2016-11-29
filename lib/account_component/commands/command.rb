module AccountComponent
  module Commands
    ## TODO module, not class
    module Command
      def self.included(cls)
        cls.class_exec do
          include EventStore::Messaging::StreamName
          include AccountComponent::Messages::Commands
          include AccountComponent::Messages::Events
          include Telemetry::Logger::Dependency

          attr_accessor :reply_stream_name

          dependency :writer, EventStore::Messaging::Writer
          dependency :clock, Clock::UTC

          category :account
          abstract :command
        end
      end

      def configure
        EventStore::Messaging::Writer.configure self
        Clock::UTC.configure self
      end

      def call
        stream_name = command_stream_name(account_id)
        writer.write(command, stream_name, reply_stream_name: reply_stream_name)
      end
    end
  end
end
