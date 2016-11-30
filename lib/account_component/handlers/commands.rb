module AccountComponent
  module Handlers
    class Commands
      include Messaging::Handle
      include Messaging::StreamName
      include AccountComponent::Messages::Commands
      include AccountComponent::Messages::Events
      include Log::Dependency

      dependency :writer, Messaging::Postgres::Write
      dependency :store, AccountComponent::Store
      dependency :clock, Clock::UTC

      def configure
        Messaging::Postgres::Write.configure self
        AccountComponent::Store.configure self
        Clock::UTC.configure self
      end

      category :account

      handle OpenAccount do |open_account|
        logger.trace { "Opening account" }
        logger.trace(tag: :verbose) { open_account.pretty_inspect }

        account_opened = AccountOpened.follow open_account

        sequence = open_account.metadata.position

        time = clock.iso8601
        account_opened.processed_time = time
        account_opened.sequence = sequence

        stream_name = stream_name(account_opened.account_id)

        account, stream_version = store.fetch(open_account.account_id, include: :version)

        if account.current?(sequence)
          logger.warn { "Command ignored (Command: #{account_opened.message_type}, Sequence: #{sequence}, Account Sequence: #{account.sequence})" }
          return
        end

        writer.write(account_opened, stream_name, expected_version: stream_version)

        logger.info { "Opened account" }
        logger.info(tag: :verbose) { account_opened.pretty_inspect }
      end

      handle Deposit do |deposit|
        logger.trace { "Depositing" }
        logger.trace(tag: :verbose) { deposit.pretty_inspect }

        deposited = Deposited.follow deposit

        sequence = deposit.metadata.position

        time = clock.iso8601
        deposited.processed_time = time
        deposited.sequence = sequence

        stream_name = stream_name(deposit.account_id)
        account, stream_version = store.fetch(deposit.account_id, include: :version)

        if account.current?(sequence)
          logger.warn { "Command ignored (Command: #{deposit.message_type}, Sequence: #{sequence}, Account Sequence: #{account.sequence})" }
          return
        end

        writer.write(deposited, stream_name, expected_version: stream_version)

        logger.info { "Deposited" }
        logger.info(tag: :verbose) { deposited.pretty_inspect }
      end

      handle Hold do |hold|
        logger.trace { "Holding" }
        logger.trace(tag: :verbose) { hold.pretty_inspect }

        sequence = hold.metadata.position

        time = clock.iso8601
        account_id = hold.account_id

        stream_name = stream_name(account_id)
        account, stream_version = store.fetch(account_id, include: :version)

        if account.current?(sequence)
          logger.warn { "Command ignored (Command: #{hold.message_type}, Sequence: #{sequence}, Account Sequence: #{account.sequence})" }
          return
        end

        amount = hold.amount

        if !account.available_balance?(amount)
          hold_rejected = HoldRejected.follow hold
          hold_rejected.processed_time = time
          hold_rejected.sequence = sequence

          writer.write(hold_rejected, stream_name)

          logger.info { "Hold rejected for insufficient available balance" }
          logger.info(tag: :verbose) { hold_rejected.pretty_inspect }
          return
        end

        held = Held.follow hold
        held.processed_time = time
        held.sequence = sequence

        writer.write(held, stream_name, expected_version: stream_version)

        logger.info { "Held" }
        logger.info(tag: :verbose) { held.pretty_inspect }
      end

      handle Withdraw do |withdraw|
        logger.trace { "Withdrawing" }
        logger.trace(tag: :verbose) { withdraw.pretty_inspect }

        sequence = withdraw.metadata.position

        time = clock.iso8601
        account_id = withdraw.account_id

        stream_name = stream_name(account_id)
        account, stream_version = store.fetch(account_id, include: :version)

        if account.current?(sequence)
          logger.warn { "Command ignored (Command: #{withdraw.message_type}, Sequence: #{sequence}, Account Sequence: #{account.sequence})" }
          return
        end

        amount = withdraw.amount

        if !account.available_balance?(amount)
          withdrawal_rejected = WithdrawalRejected.follow withdraw
          withdrawal_rejected.processed_time = time
          withdrawal_rejected.sequence = sequence

          writer.write(withdrawal_rejected, stream_name)

          logger.info { "Withdrawal rejected for insufficient available balance" }
          logger.info(tag: :verbose) { withdrawal_rejected.pretty_inspect }
          return
        end

        withdrawn = Withdrawn.follow withdraw
        withdrawn.processed_time = time
        withdrawn.sequence = sequence

        writer.write(withdrawn, stream_name, expected_version: stream_version)

        logger.info "Withdrawn"
        logger.info(tag: :verbose) { withdrawn.pretty_inspect }
      end

      handle Release do |release|
        logger.trace { "Releasing" }
        logger.trace(tag: :verbose) { release.pretty_inspect }

        released = Released.follow release

        sequence = release.metadata.position

        time = clock.iso8601
        released.processed_time = time
        released.sequence = sequence

        stream_name = stream_name(release.account_id)
        account, stream_version = store.fetch(release.account_id, include: :version)

        if account.current?(sequence)
          logger.warn { "Command ignored (Command: #{release.message_type}, Sequence: #{sequence}, Account Sequence: #{account.sequence})" }
          return
        end

        writer.write(released, stream_name, expected_version: stream_version)

        logger.info { "Released" }
        logger.info(tag: :verbose) { released.pretty_inspect }
      end
    end
  end
end
