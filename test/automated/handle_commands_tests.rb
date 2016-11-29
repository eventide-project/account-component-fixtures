require_relative '../test_init'

TestBench::Runner.(
  'handle_commands/**/*.rb',
  exclude_pattern: %r{_init\.rb|_tests\.rb|\.skip\.rb\z}
) or exit 1
