# This is one of a pair of tests that cover setting options around Static linking
# and the other covers dynamic

class Libraries_Static < JagatiTestCase
    def test_static_libraries
        cmake = run_cmake_and_load_cache

        assert_equal('STATIC', cmake.cache.value('LibraryBuildType'), 'Should be using Static libs')
        assert_equal('LibrariesStatic_',
                     cmake.cache.value('LibrariesStatic_LibTarget'),
                     'Library Target with predicatable name is chosen - static')
        assert_equal(true,
                     cmake.targets.include?('LibrariesStatic_'),
                     'Library Target with predicatable name is added - static')
    end
end
