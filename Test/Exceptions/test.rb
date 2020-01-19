# The Happy Path for a simple project that uses all the file lists and includes tests to verify the tools that allow
# easier inspection of the Jagati that are built directly into the test suite.

class Exceptions < JagatiTestCase
    def test_file_lists
        cmake = run_cmake_no_dox_and_load_cache

        # Build the executables and fail on any error.
        cmake.build
        cmake.fail_if_error

        # Verify the Unit Tests Ran correctly
        cmake.outputs.run_tests

        #require 'pry'; binding.pry
        assert_equal("", cmake.outputs.view_stderr, "Just get outputo0")
        #assert_equal(1, cmake.outputs.test_success_count, "Expected two tests passes")
        assert_equal(0, cmake.outputs.test_failed_count, "Expected 0 tests failures")
        assert_equal("Success", cmake.outputs.test_worst_result, "Expected only success")

        # Verify the Main executable runs correctly
        #cmake.outputs.run_binary


    end

end
