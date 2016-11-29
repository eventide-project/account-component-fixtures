module AccountComponent
  class Dispatcher
    include EventStore::Messaging::Dispatcher

    handler Handlers::Commands
  end
end
