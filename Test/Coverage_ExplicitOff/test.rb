# One of the coverage tests. What should the state be when this is explicitly
# disabled? There are two others, unset and ExplicitOn.

class Coverage_ExplicitOff < JagatiTestCase
    def test_explicit_off
        cmake = run_cmake_and_load_cache

        # When turned off and called to make a target it shouldn't to allow for simpler logic in calling files.
        assert_equal(false, cmake.cache.value('CompilerCodeCoverage').to_b, "Coverage should be explictly disabled")
        assert_equal(true, cmake.targets.include?('Hello'), "Sanity check, Hello is built in the ExplicitOff CMake")
        assert_equal(false, cmake.targets.include?('HelloCoverage'), "There should be no coverage target when disabled")

        # Test that coverage doesn't touch these
        assert_match('Hello2.h',
                     cmake.jagati.header_file_list,
                     'Disabling Coverage Touched CoverageTest_Disabled_HeaderFiles')
        assert_match('Hello2.cpp',
                     cmake.jagati.source_file_list,
                     'Disabling Coverage Touched CoverageTest_Disabled_SourceFiles')
    end
end
