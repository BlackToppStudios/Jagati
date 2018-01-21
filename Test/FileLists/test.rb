class FileLists < JagatiTestCase

    def test_file_lists
        cmake = run_cmake_and_load_cache
#require 'pry'; binding.pry
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
        source_files = cmake.jagati.source_file_list
        assert_match("src/Hello.cpp", source_files, "Source File List missing Hello.cpp")
        assert_match("src/Hello2.cpp", source_files, "Source File List missing Hello2.cpp")

        header_files = cmake.jagati.header_file_list
        assert_match("include/Hello.h", header_files, "Source File List missing Hello.h")
        assert_match("include/Hello2.h", header_files, "Source File List missing Hello2.h")

        jagati_files = cmake.jagati.dox_file_list
        assert_match("include/Hello.h", jagati_files, "Jagati Dox File List missing Hello.h")
        assert_match("include/Hello2.h", jagati_files, "Jagati Dox File List missing Hello2.h")
        assert_match("dox/HelloDoc.h", jagati_files, "Jagati Dox File List missing HelloSwig.h")

        jagati_files = cmake.jagati.swig_file_list
        assert_match("swig/HelloSwig.h", jagati_files, "Jagati Swig File List missing HelloSwig.h")

        jagati_files = cmake.jagati.test_file_list
        assert_match("test/HelloTest.h", jagati_files, "Jagati Test Header File List missing HelloTest.h")
        jagati_files = cmake.jagati.test_class_list
        assert_match("HelloTest", jagati_files, "Jagati Test class File List missing HelloTest")

        #require 'pry'; binding.pry

        # Do build here
        # check build works
        # Copy this and make one that depends one Mezz_StaticFoundation

    end

end
