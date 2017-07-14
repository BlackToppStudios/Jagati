class TestIdentify < TestCase

    def initialize(arg)
        @source_dir = 'Identify'
        super arg
    end

    def test_id_os
        cmake = CMake.new(@source_dir)
        cmake.invoke

        # Only a basic smoke, Did it run? Other tests, like those in the static foundation check this in other tests.
        assert_match(/build$/, cmake.invocation_stdout.join, 'Detected OS as')
    end

    def test_id_compiler
        cmake = CMake.new(@source_dir)
        cmake.invoke

        # Yet another smoke test, but more interesting tests might go here in the future.
        assert_match(/build$/, cmake.invocation_stdout.join, 'Detected compiler as')
        
    end

    def test_id_debug
        cmake = CMake.new(@source_dir)
        cmake.invoke
        assert_match(/build$/, cmake.invocation_stdout.join, 'skipping debug data')

        cmake.add_argument("CMAKE_BUILD_TYPE", "DEBUG")
        cmake.invoke
        assert_match(/build$/, cmake.invocation_stdout.join, 'creating debug data')
    end

    def test_set_compiler_flags
        cmake = CMake.new(@source_dir)
        cmake.invoke

        # Only a basic smoke, Did it run? 
        assert_match(/build$/, cmake.invocation_stdout.join, 'C++ compiler and linker flags:')
    end

end
