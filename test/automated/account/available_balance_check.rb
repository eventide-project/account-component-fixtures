require_relative '../automated_init'

context "Account" do
  context "Available Balance Check" do
    account = Controls::Account::Held.example

    available_balance = account.available_balance

    context "Sufficient" do
      context "Balance is greater than amount" do
        amount = available_balance - 1
        sufficient = account.available_balance?(amount)

        assert(sufficient)
      end

      context "Balance is equal to amount" do
        amount = available_balance
        sufficient = account.available_balance?(amount)

        assert(sufficient)
      end
    end

    context "Insufficient" do
      context "Balance is less than amount" do
        amount = available_balance + 1
        sufficient = account.available_balance?(amount)

        refute(sufficient)
      end
    end
  end
end
