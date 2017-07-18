# This is a suite of test for the Jagati

# This was made in Ruby because Because is comes preinstalled on Mac OS X, Linux and is trivial install on windows. This
# could be done with bash or batch easily.

# Our tools
require_relative 'CMakeCache'
require_relative 'CMakeJagati'
require_relative 'CMake'

require 'optparse'

OptionParser.new do |opts|
  opts.banner = "Usage: ruby RootTest.rb [-G Optional Cmake Generator] [-h|--help]"
  opts.on('-G', '--Generator NAME', 'Name of CMake Generator') { |v| CMake.generator = v }
  opts.on('-h', '--help', 'See this help message') { |v| puts opts; exit; }
end.parse!

# Pick some test Suite in the standard library and give it some alias all our tests will use.
require 'minitest/autorun'
begin
    TestCase = MiniTest::Test
rescue
    TestCase = MiniTest::Unit::TestCase
end

# Dir doesn't guarantee a case on #pwd, this allows us 
def samecase_drive(path)
    if path.nil? then return nil end
    cleaned = path.to_s
    cleaned[0] = cleaned[0].upcase if cleaned.size > 2 && cleaned[1] == ':'
    cleaned
end

class Dir
    def self.lpwd
        samecase_drive(Dir.pwd)
    end
end

# Problems with trailing slashes were common, so we added this
class ::Pathname
    def with_slash
        samecase_drive(to_s + '/')
    end
end

class String
    # To Boolean
    def to_b
        true_regex = Regexp.new("(true|on)", Regexp::IGNORECASE)
        if true_regex.match(self) then true else false end
    end
end

class NilClass
    # To Boolean
    def to_b
        false
    end
end

# Tests
require_relative 'Mezz_PackageDirectory/test.rb'
require_relative 'ClaimParentProject/test.rb'
require_relative 'LocationVars/test.rb'
require_relative 'Identify/test.rb'
