module AccountComponent
  class Store
    include EventStore::EntityStore

    category 'account'
    entity Account
    projection Projection
  end
end
