module AccountComponent
  module Controls
    module Sequence
      def self.example
        11
      end

      module Comparable
        def self.example(sequence: nil)
          sequence ||= Sequence.example
          Struct.new(:sequence).new(sequence)
        end
      end
    end
  end
end
