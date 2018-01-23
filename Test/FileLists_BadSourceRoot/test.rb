# This is a variation on the FileLists tests that verifies a good error is generated when a Source file is misplaced.

class FileLists_BadSourceRoot < JagatiTestCase
    def test_file_lists
        cmake = run_cmake_and_load_cache :should_fail # The jagati rejects Hello2.cpp because its misplaced

        # The Good Files should still work
        assert_match("src/Hello.cpp", cmake.jagati.source_file_list, "Source File List missing Hello.cpp")
        assert_match("include/Hello.h", cmake.jagati.header_file_list, "Source File List missing Hello.h")
        assert_match("include/Hello.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing Hello.h")
        assert_match("include/Hello2.h", cmake.jagati.header_file_list, "Source File List missing Hello2.h")
        assert_match("include/Hello2.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing Hello2.h")
        assert_match("dox/HelloDoc.h", cmake.jagati.dox_file_list, "Jagati Dox File List missing HelloDoc.h")
        assert_match("swig/HelloSwig.h", cmake.jagati.swig_file_list, "Jagati Swig File List missing HelloSwig.h")
        assert_match("test/HelloTest.h", cmake.jagati.test_file_list, "Jagati Test Header List missing HelloTest.h")
        assert_match("HelloTest", cmake.jagati.test_class_list, "Jagati Test class File List missing HelloTest")

        # But the one with the misplaced file should fail.
        assert_match(/outside.*source.*dir/, cmake.stderr.join, "Reports missing when source is misplaced")

    end
end
