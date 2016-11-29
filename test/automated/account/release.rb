require_relative '../automated_init'

context "Account" do
  context "Release" do
    account = Controls::Account::Held.example

    former_held = account.held
    former_balance = account.balance
    former_available_balance = account.available_balance

    amount = Controls::Cash.amount

    account.release(amount)

    test "Account's held amount is decreased by the amount held [Held: #{account.held}, Amount: #{amount}, Former Held: #{former_held}]" do
      assert(account.held == former_held - amount)
    end

    test "Available balance is increased by the amount held [Available Balance: #{account.available_balance}, Amount: #{amount}, Former Available Balance: #{former_available_balance}]" do
      assert(account.available_balance == former_available_balance + amount)
    end

    test "Balance is unchanged [Balance: #{account.balance}, Former Balance: #{former_balance}]" do
      assert(account.balance == former_balance)
    end
  end
end
