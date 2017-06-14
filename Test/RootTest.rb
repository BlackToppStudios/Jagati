# This is a suite of test for the Jagati

# This was made in Ruby because Because is comes preinstalled on Mac OS X, Linux and is trivial install on windows. This
# could be done with bash or batch easily.

# Our tools
require_relative 'CMakeCache'
require_relative 'CMake'

# Pick some test Suite in the stand library
require 'minitest/autorun'

begin
    TestCase = MiniTest::Test
rescue
    TestCase = MiniTest::Unit::TestCase
end

# Tests
require_relative 'Mezz_PackageDirectory/test.rb'
require_relative 'ClaimParentProject/test.rb'
