require_relative '../automated_init'

context "Account Projection" do
  fixture = Fixtures::Projection.build(
    projection: Projection,
    entity: Controls::Account::Balance.example,
    event: Controls::Events::Deposited.example
  )

  fixture.() do |test|
    test.assert_attributes_copied([
      { account_id: :id },
      :sequence
    ])

    test.assert_deposited
  end
end
