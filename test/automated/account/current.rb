require_relative '../automated_init'

context "Account" do
  context "Currentness" do
    sequence = 1

    context "Not Current" do
      test "Account's sequence is lower than the compare sequence" do
        account = Controls::Account.example(sequence: sequence - 1)

        current = account.current?(sequence)

        refute(current)
      end

      test "Account's sequence is nil" do
        account = Account.build

        current = account.current?(sequence)

        refute(current)
      end
    end

    context "Not Current" do
      test "Account's sequence is greater than the compare sequence" do
        account = Controls::Account.example(sequence: sequence + 1)

        current = account.current?(sequence)

        assert(current)
      end

      test "Account's sequence is equal to the compare sequence" do
        account = Controls::Account.example(sequence: sequence)

        current = account.current?(sequence)

        assert(current)
      end
    end
  end
end
