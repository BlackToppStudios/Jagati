# This is part of a pair of tests to verify the Jagati interface for setting
# Dynamic library build works, the other tests static.

class Libraries_Dynamic < JagatiTestCase
    def test_dynamic_libraries
        cmake = run_cmake_and_load_cache

        assert_equal('SHARED', cmake.cache.value('LibraryBuildType'), 'Should be using dynamic/shared libs')
        assert_equal('LibrariesDynamic_',
                     cmake.cache.value('LibrariesDynamic_LibTarget'),
                     'Library Target with predicatable name is chosen - dynamic')
        assert_equal(true,
                     cmake.targets.include?('LibrariesDynamic_'),
                     'Library Target with predicatable name is added - dynamic')
    end
end
