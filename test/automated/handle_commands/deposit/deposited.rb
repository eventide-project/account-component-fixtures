require_relative '../../automated_init'

context "Handle Commands" do
  context "Accept command if the account is not current" do
    fixture = Fixtures::Handler.build(
      handler: Handlers::Commands.new,
      input_message: Controls::Commands::Deposit.example(sequence: 1),
      record_new_entity: true
    )

    fixture.(output: "Deposited") do |test|

      test.assert_accepted

      test.assert_attributes_copied([
        :account_id,
        :amount,
        :time
      ])
    end
  end
end
