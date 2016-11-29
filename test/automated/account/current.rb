require_relative '../automated_init'

context "Account" do
  context "Currentness" do
    sequence = 1
    sequenced = Controls::Sequence::Comparable.example(sequence: sequence)

    context "Not Current" do
      test "Account's sequence is lower than the compare sequence" do
        account = Controls::Account.example(sequence: sequence - 1)

        current = account.current?(sequenced)

        refute(current)
      end

      test "Account's sequence is nil" do
        account = Account.build

        current = account.current?(sequenced)

        refute(current)
      end
    end

    context "Not Current" do
      test "Account's sequence is greater than the compare sequence" do
        account = Controls::Account.example(sequence: sequence + 1)

        current = account.current?(sequenced)

        assert(current)
      end

      test "Account's sequence is equal to the compare sequence" do
        account = Controls::Account.example(sequence: sequence)

        current = account.current?(sequenced)

        assert(current)
      end
    end
  end
end
