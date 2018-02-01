# This tests that the default variables the Jagati sets are as expected.

class LocationVars < JagatiTestCase

    def setup
        # We only need to do this once per test group run.
        @cmake ||= run_cmake_and_load_cache
    end

    # This tests both some simple Jagati features and some features of the testing tools
    def test_locations
        # The CMake test class decided the source and build dirs, it should know the correct answer got these tests.
        assert_equal(@cmake.build_dir.with_slash,
                     @cmake.cache.value('LocationVarsTest_BinaryDir'),
                     'Jagati Sets ${PROJECT_NAME}BinaryDir to our build dir correctly')
        assert_equal(@cmake.source_dir.with_slash,
                     @cmake.cache.value('LocationVarsTest_RootDir'),
                     'Jagati Sets ${PROJECT_NAME}RootDir to our build dir correctly')

        # This just tests that our CMake test gets the project name correctly.
        assert_equal('LocationVarsTest_',
                     @cmake.cache.project_name,
                     'Jagati Sets ${PROJECT_NAME}RootDir to our build dir correctly')

        # These tests all come in pairs. First we test that the Jagati produces the correct value, then we test that
        # value in cmake matches the value the testing shortcuts produce. Even if that value is wrong, as long as they
        # match the shortcut works.

        # Test Jagati with Doxygen
        assert_equal(@cmake.source_dir.with_slash + 'dox/',
                     @cmake.cache.value('LocationVarsTest_DoxDir'),
                     'Jagati Sets ${PROJECT_NAME}_DoxDir to the doxygen directory correctly')
        # Verify Test Tooling  with Doxygen
        assert_equal(@cmake.cache.value('LocationVarsTest_DoxDir'),
                     @cmake.jagati.doxygen_dir,
                     'CMakeJagati.rb retrieves LocationVarsTest_DoxDir value')

        # Test Jagati and Verify Test Tooling with the header directory this package exposes
        assert_equal(@cmake.source_dir.with_slash + 'include/',
                     @cmake.cache.value('LocationVarsTest_IncludeDir'),
                     'Jagati Sets ${PROJECT_NAME}_IncludeDir to the include directory correctly')
        assert_equal(@cmake.cache.value('LocationVarsTest_IncludeDir'),
                     @cmake.jagati.include_dir,
                     'CMakeJagati.rb retrieves LocationVarsTest_IncludeDir value')

        # Test Jagati and Verify Test Tooling with library directory this package exposes
        assert_equal(@cmake.source_dir.with_slash + 'lib/',
                     @cmake.cache.value('LocationVarsTest_LibDir'),
                     'Jagati Sets ${PROJECT_NAME}_LibDir to the library directory correctly')
        assert_equal(@cmake.cache.value('LocationVarsTest_LibDir'),
                     @cmake.jagati.library_dir,
                     'CMakeJagati.rb retrieves LocationVarsTest_LibDir value')

        # Test Jagati and Verify Test Tooling with Source directory this package sets, and shouldn't be considered
        # exposed
        assert_equal(@cmake.source_dir.with_slash + 'src/',
                     @cmake.cache.value('LocationVarsTest_SourceDir'),
                     'Jagati Sets ${PROJECT_NAME}_SourceDir to the Source directory correctly')
        assert_equal(@cmake.cache.value('LocationVarsTest_SourceDir'),
                     @cmake.jagati.source_dir,
                     'CMakeJagati.rb retrieves LocationVarsTest_SourceDir value')

        # Test Jagati and Verify Test Tooling with the SWIG directory this package exposed
        assert_equal(@cmake.source_dir.with_slash + 'swig/',
                     @cmake.cache.value('LocationVarsTest_SwigDir'),
                     'Jagati Sets ${PROJECT_NAME}_SwigDir to the SWIG directory correctly')
        assert_equal(@cmake.cache.value('LocationVarsTest_SwigDir'),
                     @cmake.jagati.swig_dir,
                     'CMakeJagati.rb retrieves LocationVarsTest_SwigDir value')

        # Test Jagati and Verify Test Tooling with the directory this package puts test source in.
        assert_equal(@cmake.source_dir.with_slash + 'test/',
                     @cmake.cache.value('LocationVarsTest_TestDir'),
                     'Jagati Sets ${PROJECT_NAME}_TestDir to the test directory correctly')
        assert_equal(@cmake.cache.value('LocationVarsTest_TestDir'),
                     @cmake.jagati.test_dir,
                     'CMakeJagati.rb retrieves LocationVarsTest_TestDir value.')
    end

    def test_created_locations_exist
        # Test Jagati and Verify Test Tooling with the directory for autogenerated configuration headers.
        assert_equal(@cmake.build_dir.with_slash + 'config/',
                     @cmake.cache.value('LocationVarsTest_GenHeadersDir'),
                     'Jagati Sets ${PROJECT_NAME}_GenHeadersDir to the test the config header directory correctly')
        assert_equal(@cmake.cache.value('LocationVarsTest_GenHeadersDir'),
                     @cmake.jagati.generated_header_dir,
                     'CMakeJagati.rb retrieves LocationVarsTest_GenHeadersDir value')
        assert(File.directory?(@cmake.jagati.generated_header_dir),"Test that Generated Header directory exists")

        # Test Jagati and Verify Test Tooling with the directory for machine generated source files.
        assert_equal(@cmake.build_dir.with_slash + 'generated_source/',
                     @cmake.cache.value('LocationVarsTest_GenSourceDir'),
                     'Jagati Sets ${PROJECT_NAME}_GenSourceDir to the test generated source directory correctly')
        assert_equal(@cmake.cache.value('LocationVarsTest_GenSourceDir'),
                     @cmake.jagati.generated_source_dir,
                     'CMakeJagati.rb retrieves LocationVarsTest_GenSourceDir value')
        assert(File.directory?(@cmake.jagati.generated_header_dir),"Test that Generated Source directory exists")
    end

    def test_output_names
        # Test Jagati and Verify Test Tooling with the binary target name.
        assert_equal('LocationVarsTest__Main',
                     @cmake.cache.value('LocationVarsTest_BinTarget'),
                     'Jagati Sets ${PROJECT_NAME}_BinTarget sets the binary target name correctly')
        assert_equal(@cmake.cache.value('LocationVarsTest_BinTarget'),
                     @cmake.jagati.binary_target_name,
                     'CMakeJagati.rb retrieves LocationVarsTest_BinTarget value')

        # Test Jagati and Verify Test Tooling with the library target name.
        assert_equal('LocationVarsTest_',
                     @cmake.cache.value('LocationVarsTest_LibTarget'),
                     'Jagati Sets ${PROJECT_NAME}_LibTarget sets the library target name correctly')
        assert_equal(@cmake.cache.value('LocationVarsTest_LibTarget'),
                     @cmake.jagati.library_target_name,
                     'CMakeJagati.rb retrieves LocationVarsTest_LibTarget value')

        # Test Jagati and Verify Test Tooling with the unit test target name.
        assert_equal('LocationVarsTest__Tester',
                     @cmake.cache.value('LocationVarsTest_TestTarget'),
                     'Jagati Sets ${PROJECT_NAME}_TestTarget sets the unit test target name correctly')
        assert_equal(@cmake.cache.value('LocationVarsTest_TestTarget'),
                     @cmake.jagati.test_target_name,
                     'CMakeJagati.rb retrieves LocationVarsTest_TestTarget value')
    end

    def test_empty_filelists
        skip "Test for the files and Verify they are empty in the LocationVars tests."
    end
end
