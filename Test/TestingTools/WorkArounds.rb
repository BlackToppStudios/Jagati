# A bunch of monkey patching for the test suite to make the code simpler at the cost of adding for possible surprises
# for experiences rubyists,.


# Pick some test Suite in the standard library and give it some alias all our tests will use.
require 'minitest/autorun'
#require "minitest/hell"
begin
    TestCase = MiniTest::Test
rescue
    TestCase = MiniTest::Unit::TestCase
end

# Dir doesn't guarantee a case on #pwd, this does
def samecase_drive(path)
    if path.nil? then return nil end
    cleaned = path.to_s
    cleaned[0] = cleaned[0].upcase if cleaned.size > 2 && cleaned[1] == ':'
    cleaned
end

# No guarantee of casing on drive letters, so get it lowercase.
class Dir
    def self.lpwd
        samecase_drive(Dir.pwd)
    end
end

# Problems with trailing slashes were common, so we added this.
class ::Pathname
    def with_slash
        samecase_drive(to_s + '/')
    end
end

# CMake "ON" is true, and this tests for that.
class String
    # To Boolean
    def to_b
        true_regex = Regexp.new("(true|on)", Regexp::IGNORECASE)
        if true_regex.match(self) then true else false end
    end
end

# A missing item from the CMake cache will inject nils into ruby, but are false in CMake.
class NilClass
    # To Boolean
    def to_b
        false
    end
end
