class Identify < JagatiTestCase

    def test_id_os
        cmake = run_cmake_and_load_cache

        # Only a basic smoke, Did it run? Other tests, like those in the static foundation check this in other tests.
        assert_match(/build$/, cmake.stdout.join, 'Detected OS as')

        detected_platform_count = 0
        if cmake.cache.value('SystemIsLinux').to_b   then detected_platform_count +=1 end
        if cmake.cache.value('SystemIsWindows').to_b then detected_platform_count +=1 end
        if cmake.cache.value('SystemIsMacOSX').to_b  then detected_platform_count +=1 end
        if cmake.cache.value('SystemIsIOS').to_b     then detected_platform_count +=1 end
        assert_equal(1, detected_platform_count, "Exactly one platform should be detected")

        detected_arch_count = 0
        if cmake.cache.value('Platform32Bit').to_b then detected_arch_count +=1 end
        if cmake.cache.value('Platform64Bit').to_b then detected_arch_count +=1 end
        assert_equal(1, detected_arch_count, "Exactly one architecture should be detected")
    end

    def test_id_compiler
        cmake = run_cmake_and_load_cache

        # Yet another smoke test, but more interesting tests might go here in the future.
        assert_match(/build$/, cmake.stdout.join, 'Detected compiler as')

        detected_compiler_count = 0
        if cmake.cache.value('CompilerIsGCC').to_b          then detected_compiler_count +=1 end
        if cmake.cache.value('CompilerIsClang').to_b        then detected_compiler_count +=1 end
        if cmake.cache.value('CompilerIsIntel').to_b        then detected_compiler_count +=1 end
        if cmake.cache.value('CompilerIsMsvc').to_b         then detected_compiler_count +=1 end
        if cmake.cache.value('CompilerIsEmscripten').to_b   then detected_compiler_count +=1 end
        assert_equal(1, detected_compiler_count, "Exactly one compiler should be detected")

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

        assert_match(/build$/, cmake.stdout.join, 'skipping debug data')

        cmake.add_argument("CMAKE_BUILD_TYPE", "DEBUG")
        cmake.invoke
        assert_match(/build$/, cmake.stdout.join, 'creating debug data')
    end

    def test_set_compiler_flags
        cmake = run_cmake_and_load_cache

        # Only a basic smoke, Did it run? 
        assert_match(/build$/, cmake.stdout.join, 'C++ compiler and linker flags:')

        assert_match(/[\/-]Wall/, cmake.cache.value('CMAKE_CXX_FLAGS'), "/Wall or -Wall is passed to compiler")
    end

end
