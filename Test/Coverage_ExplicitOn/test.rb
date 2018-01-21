# Test that the coverage tools are enable correctly when explicitly enabled. This
# is part of a trio of coverage tests, the other test ExplicitOff and NotSet.

class Coverage_ExplicitOn < JagatiTestCase
    def test_explicit_on
        cmake = run_cmake_and_load_cache

        # When turned on and the platform supports it coverage should be enabled.
        assert_equal(true && cmake.cache.value('CompilerSupportsCoverage').to_b,
                     cmake.cache.value('CompilerCodeCoverage').to_b,
                     "Coverage should be enabled when supported and set explicitly")
        assert_equal(true, cmake.targets.include?('Hello'), "Sanity check, Hello is built in the ExplicitOn CMake")
        assert_equal(true && cmake.cache.value('CompilerSupportsCoverage').to_b,
                     cmake.targets.include?('HelloCoverage'),
                     "There should be no coverage target when enabled if the compiler supports coverage")

        # Test that coverage doesn't touch these
        assert_match('Hello2.h',
                     cmake.jagati.header_file_list,
                     'Enabling Coverage Touched CoverageTest_Enabled_HeaderFiles')
        assert_match('Hello2.cpp',
                     cmake.jagati.source_file_list,
                     'Enabling Coverage Touched CoverageTest_Enabled_SourceFiles')
    end
end
