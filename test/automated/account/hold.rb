require_relative '../automated_init'

context "Account" do
  context "Hold" do
    account = Controls::Account::Balance.example

    former_held = account.held
    former_balance = account.balance
    former_available_balance = account.available_balance

    amount = Controls::Cash.amount

    account.hold(amount)

    test "Account's held amount is increased by the amount held [Held: #{account.held}, Amount: #{amount}, Former Held: #{former_held}]" do
      assert(account.held == former_held + amount)
    end

    test "Available balance is decreased by the amount held [Available Balance: #{account.available_balance}, Amount: #{amount}, Former Available Balance: #{former_available_balance}]" do
      assert(account.available_balance == former_available_balance - amount)
    end

    test "Balance is unchanged [Balance: #{account.balance}, Former Balance: #{former_balance}]" do
      assert(account.balance == former_balance)
    end
  end
end
