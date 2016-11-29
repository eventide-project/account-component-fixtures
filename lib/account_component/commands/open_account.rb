module AccountComponent
  module Commands
    class OpenAccount
      include Command

      initializer :account_id, :customer_id

      def self.build(account_id, customer_id, reply_stream_name: nil)
        instance = new(account_id, customer_id)
        instance.reply_stream_name = reply_stream_name
        instance.configure
        instance
      end

      def self.call(account_id, customer_id, reply_stream_name: nil)
        instance = build(account_id, customer_id, reply_stream_name: reply_stream_name)
        instance.()
      end

      def command
        Messages::Commands::OpenAccount.build(
          account_id: account_id,
          customer_id: customer_id,
          time: clock.iso8601
        )
      end
    end
  end
end
