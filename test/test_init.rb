puts RUBY_DESCRIPTION

require_relative 'logger_settings'

require_relative '../init.rb'

require 'test_bench'; TestBench.activate

require 'account_component/controls'

require 'pp'

require_relative 'fixtures/attribute_equality'
require_relative 'fixtures/attribute_assignment'
require_relative 'fixtures/handler'
require_relative 'fixtures/projection'

include AccountComponent
