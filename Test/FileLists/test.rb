# The Happy Path for a simple project that uses all the file lists and includes tests to verify the tools that allow
# easier inspection of the Jagati that are built directly into the test suite.

class FileLists < JagatiTestCase
    def test_file_lists
        cmake = run_cmake_and_load_cache

        # Some Tests of the tools the test suite provides:
        assert_equal(cmake.cache.value('FileLists_Test_SourceFiles'),
                     cmake.jagati.source_file_list,
                     "Test tool for source file list not working")
        assert_equal(cmake.cache.value('FileLists_Test_HeaderFiles'),
                     cmake.jagati.header_file_list,
                     "Test tool for source file list not working")
        assert_equal(cmake.cache.value('JagatiDoxArray'),
                     cmake.jagati.dox_file_list,
                     "Test tool for doxygen file list not working")
        assert_equal(cmake.cache.value('FileLists_Test_SwigFiles'),
                     cmake.jagati.swig_file_list,
                     "Test tool for swig file list not working")
        assert_equal(cmake.cache.value('FileLists_Test_TestHeaderList'),
                     cmake.jagati.test_file_list,
                     "Test tool for test-source file list not working")
        assert_equal(cmake.cache.value('FileLists_Test_TestClassList'),
                     cmake.jagati.test_class_list,
                     "Test tool for test-class file list not working")

        # The actual tests we care about.
        assert_match("src/Hello.cpp", cmake.jagati.source_file_list, "Source File List missing Hello.cpp")
        assert_match("src/Hello2.cpp", cmake.jagati.source_file_list, "Source File List missing Hello2.cpp")

        assert_match("include/Hello.h", cmake.jagati.header_file_list, "Source File List missing Hello.h")
        assert_match("include/Hello2.h", cmake.jagati.header_file_list, "Source File List missing Hello2.h")

        assert_match("include/Hello.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing Hello.h")
        assert_match("include/Hello2.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing Hello2.h")
        assert_match("dox/HelloDoc.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing HelloSwig.h")

        assert_match("swig/HelloSwig.h", cmake.jagati.swig_file_list, "Jagati Swig File List missing HelloSwig.h")

        assert_match("test/HelloTest.h", cmake.jagati.test_file_list, "Jagati Test Header List missing HelloTest.h")

        assert_match("HelloTest", cmake.jagati.test_class_list, "Jagati Test class File List missing HelloTest")

        #require 'pry'; binding.pry

        # Add checks to each macro
        # Do build here     
        # check build works
        # Copy this and make one that depends one Mezz_StaticFoundation

    end

end
