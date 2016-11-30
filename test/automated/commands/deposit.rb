require_relative '../automated_init'

context "Commands" do
  context "Deposit" do
    account_id = Controls::Account.id
    amount = Controls::Commands::Deposit.amount
    reply_stream = 'some_reply_stream'
    category = 'account'

    deposit = Commands::Deposit.build(account_id, amount, reply_stream_name: reply_stream)

    SubstAttr::Substitute.(:clock, deposit)
    SubstAttr::Substitute.(:writer, deposit)

    deposit.()

    writer = deposit.writer

    writes = deposit.writer.writes do |written|
      written.class.message_type == 'Deposit'
    end

    telemetry_data = writes.first &.data

    message = telemetry_data &.message
    stream_name = telemetry_data &.stream_name
    reply_stream_name = telemetry_data &.reply_stream_name

    context "Writes the deposit command" do
      test "Account ID [#{message.account_id}]" do
        assert(message.account_id == account_id)
      end

      test "Amount [#{message.amount}]" do
        assert(message.amount == amount)
      end

      test "Stream Name [#{stream_name}]" do
        assert(stream_name == Messaging::StreamName.command_stream_name(account_id, category))
      end

      test "Reply Stream Name [#{reply_stream_name}]" do
        assert(reply_stream_name == reply_stream)
      end
    end
  end
end
