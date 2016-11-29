module AccountComponent
  module Handlers
    class Commands
      include EventStore::Messaging::Handler
      include EventStore::Messaging::StreamName
      include AccountComponent::Messages::Commands
      include AccountComponent::Messages::Events
      include Telemetry::Logger::Dependency

      dependency :writer, EventStore::Messaging::Writer
      dependency :store, AccountComponent::Store
      dependency :clock, Clock::UTC

      def configure
        EventStore::Messaging::Writer.configure self
        AccountComponent::Store.configure self
        Clock::UTC.configure self
      end

      category :account

      handle OpenAccount do |open_account, event_data|
        logger.trace "Opening account"
        logger.data open_account.inspect

        account_opened = AccountOpened.proceed open_account

        sequence = event_data.sequence

        time = clock.iso8601
        account_opened.processed_time = time
        account_opened.sequence = sequence

        stream_name = stream_name(account_opened.account_id)

        account, stream_version = store.fetch(open_account.account_id, include: :version)

        if account.current?(event_data)
          logger.warn "Command ignored (Command: #{account_opened.message_type}, Sequence: #{sequence}, Account Sequence: #{account.sequence})"
          return
        end

        writer.write(account_opened, stream_name, expected_version: stream_version)
        logger.info "Opened account"
        logger.data account_opened.inspect
      end

      handle Deposit do |deposit, event_data|
        logger.trace "Depositing"
        logger.data deposit.inspect

        deposited = Deposited.proceed deposit

        sequence = event_data.sequence

        time = clock.iso8601
        deposited.processed_time = time
        deposited.sequence = sequence

        stream_name = stream_name(deposit.account_id)
        account, stream_version = store.fetch(deposit.account_id, include: :version)

        if account.current?(event_data)
          logger.warn "Command ignored (Command: #{deposit.message_type}, Sequence: #{sequence}, Account Sequence: #{account.sequence})"
          return
        end

        writer.write(deposited, stream_name, expected_version: stream_version)
        logger.info "Deposited"
        logger.data deposited.inspect
      end

      handle Hold do |hold, event_data|
        logger.trace "Holding"
        logger.data hold.inspect

        sequence = event_data.sequence

        time = clock.iso8601
        account_id = hold.account_id

        stream_name = stream_name(account_id)
        account, stream_version = store.fetch(account_id, include: :version)

        if account.current?(event_data)
          logger.warn "Command ignored (Command: #{hold.message_type}, Sequence: #{sequence}, Account Sequence: #{account.sequence})"
          return
        end

        amount = hold.amount

        if !account.available_balance?(amount)
          hold_rejected = HoldRejected.proceed hold
          hold_rejected.processed_time = time
          hold_rejected.sequence = sequence

          writer.write(hold_rejected, stream_name)

          logger.info "Hold rejected for insufficient available balance"
          logger.data hold_rejected.inspect
          return
        end

        held = Held.proceed hold
        held.processed_time = time
        held.sequence = sequence

        writer.write(held, stream_name, expected_version: stream_version)

        logger.info "held"
        logger.data held.inspect
      end

      handle Withdraw do |withdraw, event_data|
        logger.trace "Withdrawing"
        logger.data withdraw.inspect

        sequence = event_data.sequence

        time = clock.iso8601
        account_id = withdraw.account_id

        stream_name = stream_name(account_id)
        account, stream_version = store.fetch(account_id, include: :version)

        if account.current?(event_data)
          logger.warn "Command ignored (Command: #{withdraw.message_type}, Sequence: #{sequence}, Account Sequence: #{account.sequence})"
          return
        end

        amount = withdraw.amount

        if !account.available_balance?(amount)
          withdrawal_rejected = WithdrawalRejected.proceed withdraw
          withdrawal_rejected.processed_time = time
          withdrawal_rejected.sequence = sequence

          writer.write(withdrawal_rejected, stream_name)

          logger.info "Withdrawal rejected for insufficient available balance"
          logger.data withdrawal_rejected.inspect
          return
        end

        withdrawn = Withdrawn.proceed withdraw
        withdrawn.processed_time = time
        withdrawn.sequence = sequence

        writer.write(withdrawn, stream_name, expected_version: stream_version)

        logger.info "Withdrawn"
        logger.data withdrawn.inspect
      end

      handle Release do |release, event_data|
        logger.trace "Releasing"
        logger.data release.inspect

        released = Released.proceed release

        sequence = event_data.sequence

        time = clock.iso8601
        released.processed_time = time
        released.sequence = sequence

        stream_name = stream_name(release.account_id)
        account, stream_version = store.fetch(release.account_id, include: :version)

        if account.current?(event_data)
          logger.warn "Command ignored (Command: #{release.message_type}, Sequence: #{sequence}, Account Sequence: #{account.sequence})"
          return
        end

        writer.write(released, stream_name, expected_version: stream_version)
        logger.info "Released"
        logger.data released.inspect
      end
    end
  end
end
