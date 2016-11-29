puts RUBY_DESCRIPTION

require_relative 'logger_settings'

require_relative '../client_init.rb'

require 'test_bench'; TestBench.activate

require 'account_component/controls'

require_relative 'fixtures/attribute_equality'

require 'pp'

include Account