class TestLibraries < TestCase

    def initialize(arg)
        @source_dir = 'Libraries'
        super arg
    end

    def test_static_libraries
        cmake = CMake.new(@source_dir + '/Static')
        cmake.invoke
        assert_equal('STATIC', cmake.cache.value('LibraryBuildType'), 'Should be using Static libs')
        assert_equal('LibrariesStatic_',
                     cmake.cache.value('LibrariesStatic_LibTarget'),
                     'Library Target with predicatable name is chosen - static')
        assert_equal(true,
                     cmake.targets.include?('LibrariesStatic_'),
                     'Library Target with predicatable name is added - static')
    end

    def test_dynamic_libraries
        cmake = CMake.new(@source_dir + '/Dynamic')
        cmake.invoke
        assert_equal('SHARED', cmake.cache.value('LibraryBuildType'), 'Should be using dynamic/shared libs')
        assert_equal('LibrariesDynamic_',
                     cmake.cache.value('LibrariesDynamic_LibTarget'),
                     'Library Target with predicatable name is chosen - dynamic')
        assert_equal(true,
                     cmake.targets.include?('LibrariesDynamic_'),
                     'Library Target with predicatable name is added - dynamic')
    end


end
