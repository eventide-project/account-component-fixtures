require_relative '../automated_init'

context "Account" do
  context "Withdraw" do
    account = Controls::Account::Held.example

    former_held = account.held
    former_balance = account.balance
    former_available_balance = account.available_balance

    amount = Controls::Cash.amount

    account.withdraw(amount)

    test "Balance is decreased by the amount withdrawn [Balance: #{account.balance}, Amount: #{amount}, Former Balance: #{former_balance}]" do
      assert(account.balance == former_balance - amount)
    end

    test "Available balance is decreased by the amount withdrawn [Available Balance: #{account.available_balance}, Amount: #{amount}, Former Available Balance: #{former_available_balance}]" do
      assert(account.available_balance == former_available_balance - amount)
    end

    test "Held amount is unchanged [Held: #{account.held}, Former Held: #{former_held}]" do
      assert(account.held == former_held)
    end
  end
end
