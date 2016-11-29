module Fixtures
  class Projection
    include TestBench::Fixture

    attr_accessor :projection
    attr_accessor :entity
    attr_accessor :event

    def self.build(projection:, entity:, event:)
      instance = new

      instance.projection = projection
      instance.entity = entity
      instance.event = event

      instance
    end

    def call(discriminator=nil, &blk)
      projection = self.projection.new(entity)

      fixture = build_fixture(entity, event)

      context name do
        context ""
        projection.apply(event)

        if block_given?
          blk.call(fixture)
        else
          fixture.()
        end
      end

      nil
    end

    def unchanged_entity(entity)
      entity.clone
    end

    virtual :build_fixture do |entity, event|
      unchanged_entity = unchanged_entity(entity)
      Fixture.new(entity, unchanged_entity, event)
    end

    virtual :name do
      "Apply #{event.message_type} to #{entity.class.name.split('::').last}"
    end

    class Fixture
      include TestBench::Fixture

      attr_accessor :entity
      attr_accessor :event
      attr_accessor :unchanged_entity

      def initialize(entity, unchanged_entity, event)
        @entity = entity
        @unchanged_entity = unchanged_entity
        @event = event
      end

      def balance
        entity.balance
      end

      def held
        entity.held
      end

      def unchanged_held
        unchanged_entity.held
      end

      def available_balance
        entity.available_balance
      end

      def unchanged_balance
        unchanged_entity.balance
      end

      def unchanged_available_balance
        unchanged_entity.available_balance
      end

      def amount
        event.amount
      end

      def assert_attributes_copied(attribute_names=nil)
        Fixtures::AttributeEquality.(
          entity,
          event,
          attribute_names,
          description: "Attributes Copied"
        )
        context ""
      end

      def assert_time_converted_and_copied(event_time_attribute, entity_time_attribute=nil)
        entity_time_attribute ||= event_time_attribute

        event_time = event.public_send(event_time_attribute)
        enity_time = entity.public_send(entity_time_attribute)

        test "Event's \"#{event_time_attribute}\" (ISO 8601) is parsed and assigned to the entity's \"#{entity_time_attribute}\" (raw time) [#{event_time} -> #{enity_time.strftime('%Y-%m-%d %I:%M:%S.%L %Z')}]" do
          assert(enity_time == Time.parse(event_time))
        end
      end

      def assert_deposited
        test "Balance is increased by the amount deposited [Balance: #{balance}, Deposited: #{amount}, Previous Balance: #{unchanged_balance}]" do
          assert(balance == unchanged_balance + amount)
        end

        test "Available balance is increased by the amount deposited [Available Balance: #{available_balance}, Deposited: #{amount}, Previous Available Balance: #{unchanged_available_balance}]" do
          assert(available_balance == unchanged_available_balance + amount)
        end

        test "Held is unchanged [Held: #{held}, Previous Held: #{unchanged_held}]" do
          assert(held == unchanged_held)
        end
      end

      def assert_withdrawn
        test "Balance is decreased by the amount withdrawn [Balance: #{balance}, Withdrawn: #{amount}, Previous Balance: #{unchanged_balance}]" do
          assert(balance == unchanged_balance - amount)
        end

        test "Available balance is decreased by the amount withdrawn [Available Balance: #{available_balance}, Withdrawn: #{amount}, Previous Available Balance: #{unchanged_available_balance}]" do
          assert(available_balance == unchanged_available_balance - amount)
        end

        test "Held is unchanged [Held: #{held}, Previous Held: #{unchanged_held}]" do
          assert(held == unchanged_held)
        end
      end

      def assert_held
        test "Held amount is increased by the amount held [Held: #{held}, Amount: #{amount}, Previous Held: #{unchanged_held}]" do
          assert(held == unchanged_held + amount)
        end

        test "Available balance is decreased by the amount held [Available Balance: #{available_balance}, Held: #{amount}, Previous Available Balance: #{unchanged_available_balance}]" do
          assert(available_balance == unchanged_available_balance - amount)
        end

        test "Balance is unchanged [Balance: #{balance}, Previous Balance: #{unchanged_balance}]" do
          assert(balance == unchanged_balance)
        end
      end

      def assert_released
        test "Held amount is decreased by the amount held [Held: #{held}, Amount: #{amount}, Previous Held: #{unchanged_held}]" do
          assert(held == unchanged_held - amount)
        end

        test "Available balance is increased by the amount released [Available Balance: #{available_balance}, Released: #{amount}, Previous Available Balance: #{unchanged_available_balance}]" do
          assert(available_balance == unchanged_available_balance + amount)
        end

        test "Balance is unchanged [Balance: #{balance}, Previous Balance: #{unchanged_balance}]" do
          assert(balance == unchanged_balance)
        end
      end
    end
  end
end
