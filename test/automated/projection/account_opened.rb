require_relative '../automated_init'

context "Account Projection" do
  fixture = Fixtures::Projection.build(
    projection: Projection,
    entity: Controls::Account::New.example,
    event: Controls::Events::AccountOpened.example
  )

  fixture.() do |test|
    test.assert_attributes_copied([
      { account_id: :id },
      :customer_id,
      :sequence
    ])

    test.assert_time_converted_and_copied(:time, :opened_time)
  end
end
