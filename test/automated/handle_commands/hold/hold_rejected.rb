require_relative '../../automated_init'

context "Handle Commands" do
  context "Reject hold if there is insufficient available balance" do
    fixture = Fixtures::Handler.build(
      handler: Handlers::Commands.new,
      input_message: Controls::Commands::Hold.example(amount: 1),
      input_event_data: Controls::EventData.example,
      entity: Controls::Account.example(balance: 1, held: 1)
    )

    fixture.(output: "HoldRejected") do |test|

      test.assert_written
      test.assert_output_processed_time
      test.assert_attributes_assigned

      test.assert_attributes_copied([
        :account_id,
        :amount,
        :time
      ])
    end

    fixture.(output: "Held") do |test|
      test.refute_written
    end
  end
end
