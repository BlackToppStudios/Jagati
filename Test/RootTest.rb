# This is a suite of test for the Jagati

# This was made in Ruby because Because is comes preinstalled on Mac OS X, Linux and is trivial install on windows. This
# could be done with bash or batch easily.

# Our tools
require_relative 'CMakeCache'
require_relative 'CMakeJagati'
require_relative 'CMakeTargets'
require_relative 'CMake'
require_relative 'WorkArounds'

# Check what we need to do and exit early if we don't need to do more.
require 'optparse'
OptionParser.new do |opts|
  opts.banner = "Usage: ruby RootTest.rb [-G Optional Cmake Generator] [-h|--help]"
  opts.on('-G', '--Generator NAME', 'Name of CMake Generator') { |v| CMake.generator = v }
  opts.on('-h', '--help', 'See this help message') { |v| puts opts; exit; }
end.parse!

# Tests
require_relative 'Mezz_PackageDirectory/test.rb'
require_relative 'ClaimParentProject/test.rb'
require_relative 'LocationVars/test.rb'
require_relative 'Identify/test.rb'
require_relative 'Coverage/test.rb'
