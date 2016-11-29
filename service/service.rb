class Service
  dependency :logger, Telemetry::Logger

  def self.service_name
    'account'
  end

  initializer :service_name

  def self.build(service_name)
    new(service_name).tap do |instance|
      Telemetry::Logger.configure instance
    end
  end

  def self.start
    service_name = self.service_name
    instance = build(service_name)
    instance.start
  end

  def start
    announce_start
    start_components
    service_name
  end

  def start_components
    command_subscription = EventStore::Consumer.build(AccountComponent::StreamNames.command, AccountComponent::Dispatcher)

    cooperation = ProcessHost::Cooperation.build
    cooperation.exception_notifier = -> process, error do
      record_error error, process
    end

    cooperation.register command_subscription, 'command-handlers'

    cooperation.start!
  end

  def announce_start
    logger.info "Starting service: #{service_name}"
  end
end
