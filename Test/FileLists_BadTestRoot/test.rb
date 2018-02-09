# This is a variation on the FileLists tests that verifies a good error is generated when a dox file is missing.

class FileLists_BadTestRoot < JagatiTestCase
    def test_file_lists
        cmake = run_cmake_no_dox_and_load_cache :should_fail # The jagati rejects HelloTest.h because its mis-located

        # The Good Files should still work
        assert_match("src/Hello.cpp", cmake.jagati.source_file_list, "Source File List missing Hello.cpp")
        assert_match("src/Hello2.cpp", cmake.jagati.source_file_list, "Source File List missing Hello2.cpp")
        assert_match("include/Hello.h", cmake.jagati.header_file_list, "Source File List missing Hello.h")
        assert_match("include/Hello2.h", cmake.jagati.header_file_list, "Source File List missing Hello2.h")
        assert_match("include/Hello.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing Hello.h")
        assert_match("include/Hello2.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing Hello2.h")
        assert_match("dox/HelloDoc.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing HelloDoc.h")
        assert_match("swig/HelloSwig.h", cmake.jagati.swig_file_list, "Jagati Swig File List missing HelloSwig.h")

        # But the one in the wrong folder should fail.
        assert_match(/outside.*test.*dir/m, cmake.stderr.join, "Main Source reports misplaced file")

    end
end
