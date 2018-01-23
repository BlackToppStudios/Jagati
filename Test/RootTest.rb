#!/usr/bin/ruby
# This is a suite of test for the Jagati

# This was made in Ruby because Because is comes preinstalled on Mac OS X, Linux and is trivial install on windows. This
# could be done with bash or batch easily.

# Our tools
require_relative 'TestingTools/CMakeCache'
require_relative 'TestingTools/CMakeJagati'
require_relative 'TestingTools/CMakeTargets'
require_relative 'TestingTools/CMake'
require_relative 'TestingTools/WorkArounds'
require_relative 'TestingTools/JagatTestCase'

# Check what we need to do and exit early if we don't need to do more.
require 'optparse'
OptionParser.new do |opts|
  opts.banner = "Usage: ruby RootTest.rb [-G Optional Cmake Generator] [-h|--help]"
  opts.on('-G', '--Generator NAME', 'Name of CMake Generator') { |v| CMake.generator = v }
  opts.on('-h', '--help', 'See this help message') { |v| puts opts; exit; }
end.parse!

# Tests

def require_test(test_name)
    require_relative test_name + '/test.rb'
end

require_test 'ClaimParentProject_Single'
require_test 'ClaimParentProject_Parent'
require_test 'LocationVars'
require_test 'Identify'
require_test 'ConfigFile'
require_test 'Coverage_ExplicitOff'
require_test 'Coverage_ExplicitOn'
require_test 'Coverage_NotSet'
require_test 'Libraries_Dynamic'
require_test 'Libraries_Static'
require_test 'Mezz_PackageDirectory'
require_test 'FileLists'
require_test 'FileLists_BadDoxRoot'
require_test 'FileLists_BadDoxMissing'
require_test 'FileLists_BadHeaderRoot'
require_test 'FileLists_BadHeaderMissing'
require_test 'FileLists_BadSourceRoot'
require_test 'FileLists_BadSourceMissing'
require_test 'FileLists_BadSwigRoot'
require_test 'FileLists_BadSwigMissing'
