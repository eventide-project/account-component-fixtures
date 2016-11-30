module AccountComponent
  module Controls
    module EventData
      def self.example(sequence: nil)
        sequence ||= self.number
        EventSource::EventData::Read.example(sequence)
      end

      def self.number
        Controls::Sequence.example
      end
    end
  end
end
