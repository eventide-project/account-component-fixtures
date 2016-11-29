module AccountComponent
  module Controls
    module EventData
      def self.example(sequence: nil)
        sequence ||= self.number
        EventStore::Client::HTTP::Controls::EventData::Read.example(sequence)
      end

      def self.number
        Controls::Sequence.example
      end
    end
  end
end
