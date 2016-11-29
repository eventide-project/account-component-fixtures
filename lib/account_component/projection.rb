module AccountComponent
  class Projection
    include EntityProjection
    include Messages::Events

    entity_name :account

    apply AccountOpened do |account_opened|
      SetAttributes.(account, account_opened, copy: [
        { account_id: :id },
        :customer_id,
        :sequence
      ])

      account.opened_time = Time.parse(account_opened.time)
    end

    apply Deposited do |deposited|
      SetAttributes.(account, deposited, copy: [
        :sequence
      ])

      account.deposit(deposited.amount)
    end

    apply Withdrawn do |withdrawn|
      SetAttributes.(account, withdrawn, copy: [
        :sequence
      ])

      account.withdraw(withdrawn.amount)
    end

    apply Held do |held|
      SetAttributes.(account, held, copy: [
        :sequence
      ])

      account.hold(held.amount)
    end

    apply Released do |deposited|
      SetAttributes.(account, deposited, copy: [
        :sequence
      ])

      account.release(deposited.amount)
    end
  end
end
