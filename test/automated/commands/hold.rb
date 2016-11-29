require_relative '../automated_init'

context "Commands" do
  context "Hold" do
    account_id = Controls::Account.id
    amount = Controls::Commands::Hold.amount
    reply_stream = 'some_reply_stream'
    category = 'account'

    hold = Commands::Hold.build(account_id, amount, reply_stream_name: reply_stream)

    SubstAttr::Substitute.(:clock, hold)
    SubstAttr::Substitute.(:writer, hold)

    hold.()

    writer = hold.writer

    writes = hold.writer.writes do |written|
      written.class.message_type == 'Hold'
    end

    telemetry_data = writes.first &.data

    message = telemetry_data &.message
    stream_name = telemetry_data &.stream_name
    reply_stream_name = telemetry_data &.reply_stream_name

    context "Writes the hold command" do
      test "Account ID" do
        assert(message.account_id == account_id)
      end

      test "Amount" do
        assert(message.amount == amount)
      end

      test "Stream Name [#{stream_name}]" do
        assert(stream_name == EventStore::Messaging::StreamName.command_stream_name(account_id, category))
      end

      test "Reply Stream Name [#{reply_stream_name}]" do
        assert(reply_stream_name == reply_stream)
      end
    end
  end
end
