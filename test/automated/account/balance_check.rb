require_relative '../automated_init'

context "Account" do
  context "Balance Check" do
    account = Controls::Account::Held.example

    balance = account.balance

    context "Sufficient" do
      context "Balance is greater than amount" do
        amount = balance - 1
        sufficient = account.balance?(amount)

        assert(sufficient)
      end

      context "Balance is equal to amount" do
        amount = balance
        sufficient = account.balance?(amount)

        assert(sufficient)
      end
    end

    context "Insufficient" do
      context "Balance is less than amount" do
        amount = balance + 1
        sufficient = account.balance?(amount)

        refute(sufficient)
      end
    end
  end
end
