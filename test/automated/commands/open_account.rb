require_relative '../automated_init'

context "Commands" do
  context "OpenAccount" do
    account_id = Controls::Account.id
    customer_id = Controls::Customer.id
    reply_stream = 'some_reply_stream'
    category = 'account'

    open_account = Commands::OpenAccount.build(account_id, customer_id, reply_stream_name: reply_stream)

    SubstAttr::Substitute.(:clock, open_account)
    SubstAttr::Substitute.(:write, open_account)

    open_account.()

    writes = open_account.write.writes do |written|
      written.class.message_type == 'OpenAccount'
    end

    telemetry_data = writes.first &.data

    message = telemetry_data &.message
    stream_name = telemetry_data &.stream_name
    reply_stream_name = telemetry_data &.reply_stream_name

    context "Writes the open account command" do
      test "Customer ID [#{message.customer_id}]" do
        assert(message.customer_id == customer_id)
      end

      test "Stream Name [#{stream_name}]" do
        assert(stream_name == Messaging::Postgres::StreamName.command_stream_name(account_id, category))
      end

      test "Reply Stream Name [#{reply_stream_name}]" do
        assert(reply_stream_name == reply_stream)
      end
    end
  end
end
