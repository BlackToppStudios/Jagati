# This is part of a trio of coverage tests and that handls the implicit case of
# coverage not being selected. The other two handle explicit on and off.

class Coverage_NotSet < JagatiTestCase
    def test_not_set
        cmake = run_cmake_and_load_cache

        # Default shouldn't create any coverage stuff because it can slow things down or add errors.
        assert_equal(false, cmake.cache.value('CompilerCodeCoverage').to_b, "Coverage should default to disabled")
        assert_equal(true, cmake.targets.include?('Hello'), "Sanity check, Hello is built in the NotSet CMake")
        assert_equal(false, cmake.targets.include?('HelloCoverage'), "There should be no coverage target by default")
        assert_match(/^((?!coverage).)*$/, cmake.cache.value('CMAKE_CXX_FLAGS'), "/Wall or -Wall passed to compiler")

        # Test that not setting coverage doesn't touch these
        assert_match('Hello2.h',
                     cmake.jagati.header_file_list,
                     'Not Setting Coverage Touched CoverageTest_NotSet_HeaderFiles')
        assert_match('Hello2.cpp',
                     cmake.jagati.source_file_list,
                    'Not Setting Coverage Touched CoverageTest_NotSet_SourceFiles')
    end
end
