require_relative '../../automated_init'

context "Handle Commands" do
  context "Ignore command when the account is current" do
    fixture = Fixtures::Handler.build(
      handler: Handlers::Commands.new,
      input_message: Controls::Commands::Withdraw.example(sequence: 0),
      entity: Controls::Account.example(sequence: 1)
    )

    fixture.(output: "Withdrawn") do |test|
      test.assert_ignored
    end
  end
end
