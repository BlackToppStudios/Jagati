# This tests The the Mezz_PackageDirectory feature works correctly

class TestClaimParentProject < TestCase

    def initialize(arg)
        @source_dir = 'ClaimParentProject'
        super arg
    end

    def test_single
        cmake = CMake.new(@source_dir + '/Single')

        #refute_equal(@source_dir.size, cmake.source_dir.size, 'Cmake class should convert to absolute path.')
        #assert_match(/build$/, cmake.build_dir.to_s, 'Cmake class should pick a sane build directory.')
        #assert_equal(true, cache.file_valid?, 'When cmake runs it should create a cache file.')

        cmake.invoke
        cache_contents = cmake.cache.load_cache
        assert_equal("ClaimParentProject_Test",
                     cmake.cache.value('ParentProject'),
                     'Jagati determines only project is parent.')
        assert_match(/Claiming.+ClaimParentProject_Test/,
                     cmake.invocation_stdout.join,
                     'Jagati messages about the claim.')


        #message(STATUS "Project '${PROJECT_NAME}' acknowledges '${ParentProject}' as the Parent Project.")
        #message(STATUS "Claiming '${PROJECT_NAME}' as the Parent Project.")
        
    end

    def test_ours_first
        cmake = CMake.new(@source_dir + '/Ours')

        cmake.invoke
        cache_contents = cmake.cache.load_cache
        assert_equal("ClaimParentProject_Ours_Test",
                     cmake.cache.value('ParentProject'),
                     'Jagati determines first project is parent.')
        assert_match(/Claiming.+ClaimParentProject_Ours_Test/,
                     cmake.invocation_stdout.join,
                     'Jagati still messages about the claim.')
        assert_match(/StaticFoundation.+acknowledges.+ClaimParentProject_Ours_Test.+Parent Project./,
                     cmake.invocation_stdout.join,
                     'Jagati sub projects message about acknowledging the claim.')

    end
end
