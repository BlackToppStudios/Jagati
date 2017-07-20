class TestCoverage < TestCase

    def initialize(arg)
        @source_dir = 'Coverage'
        super arg
    end

    def test_not_set
        cmake = CMake.new(@source_dir + '/NotSet')
        cmake.invoke

        # Default shouldn't create any coverage stuff because it can slow things down or add errors.
        assert_equal(false, cmake.cache.value('CompilerCodeCoverage').to_b, "Coverage should default to disabled")
        assert_equal(true, cmake.targets.include?('Hello'), "Sanity check, Hello is built in the NotSet CMake")
        assert_equal(false, cmake.targets.include?('HelloCoverage'), "There should be no coverage target by default")
        assert_match(/^((?!coverage).)*$/, cmake.cache.value('CMAKE_CXX_FLAGS'), "/Wall or -Wall is passed to compiler")
    end

    def test_explicit_off
        cmake = CMake.new(@source_dir + '/ExplicitOff')
        cmake.invoke

        # When turned off and called to make a target it shouldn't to allow for simpler logic in calling files.
        assert_equal(false, cmake.cache.value('CompilerCodeCoverage').to_b, "Coverage should be explictly disabled")
        assert_equal(true, cmake.targets.include?('Hello'), "Sanity check, Hello is built in the ExplicitOff CMake")
        assert_equal(false, cmake.targets.include?('HelloCoverage'), "There should be no coverage target when disabled")
    end

    def test_explicit_off
        cmake = CMake.new(@source_dir + '/ExplicitOn')
        cmake.invoke

        # When turned on and the platform supports it coverage should be enabled.
        puts cmake.invocation_stdout
        assert_equal(true && cmake.cache.value('CompilerSupportsCoverage').to_b,
                     cmake.cache.value('CompilerCodeCoverage').to_b,
                     "Coverage should be enabled when supported and set explicitly")
        assert_equal(true, cmake.targets.include?('Hello'), "Sanity check, Hello is built in the ExplicitOn CMake")
        assert_equal(true && cmake.cache.value('CompilerSupportsCoverage').to_b,
                     cmake.targets.include?('HelloCoverage'),
                     "There should be no coverage target when enabled if the compiler supports coverage.")
    end

end
