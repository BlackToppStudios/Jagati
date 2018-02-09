# The Happy Path for a simple project that uses all the file lists and includes tests to verify the tools that allow
# easier inspection of the Jagati that are built directly into the test suite.

class FileLists < JagatiTestCase
    def test_file_lists
        cmake = run_cmake_no_dox_and_load_cache

        # Some Tests of the tools the test suite provides:
        assert_equal(cmake.cache.value('FileLists_Test_SourceFiles'),
                     cmake.jagati.source_file_list,
                     "Test tool for source file list not working")
        assert_equal(cmake.cache.value('FileLists_Test_MainSourceFiles'),
                     cmake.jagati.main_source_file_list,
                     "Test tool for main source file list not working")
        assert_equal(cmake.cache.value('FileLists_Test_HeaderFiles'),
                     cmake.jagati.header_file_list,
                     "Test tool for source file list not working")
        assert_equal(cmake.cache.value('JagatiDoxArray'),
                     cmake.jagati.dox_file_list,
                     "Test tool for doxygen file list not working")
        assert_equal(cmake.cache.value('FileLists_Test_SwigFiles'),
                     cmake.jagati.swig_file_list,
                     "Test tool for swig file list not working")
        assert_equal(cmake.cache.value('FileLists_Test_TestHeaderFiles'),
                     cmake.jagati.test_file_list,
                     "Test tool for test-source file list not working")
        assert_equal(cmake.cache.value('FileLists_Test_TestClassList'),
                     cmake.jagati.test_class_list,
                     "Test tool for test-class file list not working")

        # The actual tests we care about.
        assert_match("src/Hello.cpp", cmake.jagati.source_file_list, "Source File List missing Hello.cpp")
        assert_match("src/Hello2.cpp", cmake.jagati.source_file_list, "Source File List missing Hello2.cpp")

        assert_match("src/Main.cpp", cmake.jagati.main_source_file_list, "Main Source File List missing Main.cpp")

        assert_match("include/Hello.h", cmake.jagati.header_file_list, "Source File List missing Hello.h")
        assert_match("include/Hello2.h", cmake.jagati.header_file_list, "Source File List missing Hello2.h")

        assert_match("include/Hello.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing Hello.h")
        assert_match("include/Hello2.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing Hello2.h")

        assert_match("dox/HelloDoc.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing HelloDoc.h")

        assert_match("swig/HelloSwig.h", cmake.jagati.swig_file_list, "Jagati Swig File List missing HelloSwig.h")

        assert_match("test/HelloTest.h", cmake.jagati.test_file_list, "Jagati Test Header List missing HelloTest.h")

        assert_match("HelloTest", cmake.jagati.test_class_list, "Jagati Test class File List missing HelloTest")

        # Build the executables and fail on any error.
        cmake.build
        cmake.fail_if_error
        # Verify the Unit Tests Ran correctly
        cmake.outputs.run_tests
        assert_equal(2, cmake.outputs.test_success_count, "Expected two tests passes")
        assert_equal(0, cmake.outputs.test_failed_count, "Expected 0 tests failures")
        assert_equal("Success", cmake.outputs.test_worst_result, "Expected only success")

        # Verify the Main executable runs correctly
        cmake.outputs.run_binary
        assert_match(/Hello World!/, cmake.outputs.stdout.join(""), "Expected simple hello world result.")

        # Verify Static Foundation and Mezz_Test has a few header files that we can get at. This isn't a complete list,
        # just enough to gain confidence

        # Why does this intermittently fail?
        assert_match(/CrossPlatformExport\.h/,
                     cmake.cache.value("StaticFoundationHeaderFiles"),
                     "Expected CrossPlatformExport.h to be in the Mezz_StaticFoundation list of Header files.")
        assert_match(/DataTypes\.h/,
                     cmake.cache.value("StaticFoundationHeaderFiles"),
                     "Expected DataTypes.h to be in the Mezz_StaticFoundation list of Header files.")
        assert_match(/StaticString\.h/,
                     cmake.cache.value("StaticFoundationHeaderFiles"),
                     "Expected StaticString.h to be in the Mezz_StaticFoundation list of Header files.")

        assert_match(/BenchmarkTestGroup\.h/,
                     cmake.cache.value("TestHeaderFiles"),
                     "Expected BenchmarkTestGroup.h to be in the Mezz_Test list of Header files.")
        assert_match(/MezzTest\.h/,
                     cmake.cache.value("TestHeaderFiles"),
                     "Expected MezzTest.h to be in the Mezz_Test list of Header files.")
        assert_match(/ProcessTools\.h/,
                     cmake.cache.value("TestHeaderFiles"),
                     "Expected ProcessTools.h to be in the Mezz_Test list of Header files.")

        # Verify Static Foundation and Mezz_Test has a few source files that we can get at, like the header tests.
        assert_match(/RuntimeStatics\.cpp/,
                     cmake.cache.value("StaticFoundationSourceFiles"),
                     "Expected RuntimeStatics.cpp to be in the Mezz_StaticFoundation list of Header files.")

        assert_match(/BenchmarkTestGroup\.cpp/,
                     cmake.cache.value("TestSourceFiles"),
                     "Expected BenchmarkTestGroup.cpp to be in the Mezz_Test list of Source files.")
        assert_match(/MezzTest\.cpp/,
                     cmake.cache.value("TestSourceFiles"),
                     "Expected MezzTest.cpp to be in the Mezz_Test list of Source files.")
        assert_match(/ProcessTools\.cpp/,
                     cmake.cache.value("TestSourceFiles"),
                     "Expected ProcessTools.cpp to be in the Mezz_Test list of Source files.")

        # Test Files in Mezz_Test, but there are none in Mezz_StaticFoundation because it can't use Mezz_Test, because
        # it comes below it in package dependencies.
        assert_match(/ConsoleLogicTests\.h/,
                     cmake.cache.value("TestTestHeaderFiles"),
                     "Expected ConsoleLogicTests.h to be in the Mezz_Test list of Test Header files.")
        assert_match(/StringManipulationTests\.h/,
                     cmake.cache.value("TestTestHeaderFiles"),
                     "Expected StringManipulationTests.h to be in the Mezz_Test list of Test Header files.")
        assert_match(/TestDataTests\.h/,
                     cmake.cache.value("TestTestHeaderFiles"),
                     "Expected TestDataTests.h to be in the Mezz_Test list of Test Header files.")

        # Main, Dox and Swig Files in Mezz_StaticFoundation because Mezz_Test has none
        assert_match(/Tests\.h/,
                     cmake.cache.value("StaticFoundationMainSourceFiles"),
                     "Expected Tests.h to be in the Mezz_StaticFoundation list of Main Sourcefiles.")
        assert_match(/Tests\.cpp/,
                     cmake.cache.value("StaticFoundationMainSourceFiles"),
                     "Expected Tests.cpp to be in the Mezz_StaticFoundation list of Main Source files.")

        assert_match(/SwigConfig\.h/,
                     cmake.cache.value("StaticFoundationSwigFiles"),
                     "Expected SwigConfig.h to be in the Mezz_StaticFoundation list of Swig files.")

        assert_match(/Dox\.h/,
                     cmake.cache.value("JagatiDoxArray"),
                     "Expected Dox.h to be in the Mezz_StaticFoundation list of Main Source files.")

        #require 'pry'; binding.pry


    end

end
