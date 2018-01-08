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

#require 'pry'; binding.pry

        # The actual tests we care about.
        source_files = cmake.jagati.source_file_list
        assert_match("Hello.cpp", source_files, "Source File List missing Hello.cpp.")
        assert_match("Hello2.cpp", source_files, "Source File List missing Hello2.cpp.")

        header_files = cmake.jagati.header_file_list
        assert_match("Hello.h", header_files, "Source File List missing Hello.h.")
        assert_match("Hello2.h", header_files, "Source File List missing Hello2.h.")

        jagati_files = cmake.jagati.dox_file_list
        assert_match("Hello.h", jagati_files, "Jagati Dox File List missing Hello.h.")
        assert_match("Hello2.h", jagati_files, "Jagati Dox File List missing Hello2.h.")
        assert_match("HelloDoc.h", jagati_files, "Jagati Dox File List missing HelloSwig.h.")

        jagati_files = cmake.jagati.swig_file_list
        assert_match("HelloSwig.h", jagati_files, "Jagati Swig File List missing HelloSwig.h.")

        #require 'pry'
        #binding.pry


    #set(${PROJECT_NAME}TestSourceFiles      "" CACHE INTERNAL "" FORCE)
    #set(${PROJECT_NAME}SwigFiles            "" CACHE INTERNAL "" FORCE)

    end

end
