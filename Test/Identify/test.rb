# A test of many of the basic OS detection operations

class Identify < JagatiTestCase

    def test_id_os
        cmake = run_cmake_and_load_cache

        # Only a basic smoke, Did it run? Other tests, like those in the static foundation check this in other tests.
        if false == cmake.cache.value('CompilerIsEmscripten').to_b then
            assert_match(/Detected OS as/, cmake.stdout.join, 'Detected OS message not present')
            detected_platform_count = 0
            if cmake.cache.value('SystemIsLinux').to_b   then detected_platform_count +=1 end
            if cmake.cache.value('SystemIsWindows').to_b then detected_platform_count +=1 end
            if cmake.cache.value('SystemIsMacOSX').to_b  then detected_platform_count +=1 end
            if cmake.cache.value('SystemIsIOS').to_b     then detected_platform_count +=1 end
            assert_equal(1, detected_platform_count, "Exactly one platform should be detected")
        end

        detected_arch_count = 0
        if cmake.cache.value('Platform32Bit').to_b then detected_arch_count +=1 end
        if cmake.cache.value('Platform64Bit').to_b then detected_arch_count +=1 end
        assert_equal(1, detected_arch_count, "Exactly one architecture should be detected")
    end

    def test_id_compiler
        cmake = run_cmake_and_load_cache

        # Yet another smoke test, but more interesting tests might go here in the future.
        assert_match(/Detected compiler as/, cmake.stdout.join, 'Detected compiler message does not appear')

        detected_compiler_count = 0
        if cmake.cache.value('CompilerIsGCC').to_b          then detected_compiler_count +=1 end
        if cmake.cache.value('CompilerIsClang').to_b        then detected_compiler_count +=1 end
        if cmake.cache.value('CompilerIsIntel').to_b        then detected_compiler_count +=1 end
        if cmake.cache.value('CompilerIsMsvc').to_b         then detected_compiler_count +=1 end
        assert_equal(1, detected_compiler_count, "Exactly one compiler should be detected")

        if cmake.cache.value('CompilerIsEmscripten').to_b then
            assert_match(/emcc/, cmake.cc, 'Emscripten c compiler is emcc')
            assert_match(/em\+\+/, cmake.cxx, 'Emscripten c++ compiler is em++')
        end

        assert_equal(cmake.cache.value('CompilerIsGCC').to_b || cmake.cache.value('CompilerIsClang').to_b ||
                        cmake.cache.value('CompilerIsEmscripten').to_b,
                     cmake.cache.value('CompilerDesignNix').to_b,
                     "Unix style compilers should be detected as such")

        assert_equal(cmake.cache.value('CompilerIsMsvc').to_b ,
                     cmake.cache.value('CompilerDesignMS').to_b,
                     "ms style compilers should be detected as such")

        assert_equal(!cmake.cache.value('CompilerIsMsvc').to_b,
                     cmake.cache.value('CompilerDesignNix').to_b,
                     "Exactly one compiler style should be detected")

    end

    def test_id_debug
        cmake = run_cmake_and_load_cache

        assert_match(/skipping debug data/, cmake.stdout.join, 'Skipping debug message not present.')

        cmake.add_argument("CMAKE_BUILD_TYPE", "DEBUG")
        cmake.invoke
        assert_match(/creating debug data/, cmake.stdout.join, 'Creating debug data message not present.')
    end

    def test_set_compiler_flags
        cmake = run_cmake_and_load_cache

        # Only a basic smoke test, Did it run?
        assert_match(/compiler and linker flags/, cmake.stdout.join, 'Compiler and linker flags not listed.')

        assert_match(/[\/-]Wall/, cmake.cache.value('CMAKE_CXX_FLAGS'), "/Wall or -Wall is passed to compiler")
    end

end
