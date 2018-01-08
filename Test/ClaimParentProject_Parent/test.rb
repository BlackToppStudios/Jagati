# This tests The the Mezz_PackageDirectory feature works correctly when using
# subprojects from other jagati packages.

class ClaimParentProject_Parent < JagatiTestCase
    def test_ours_first
        cmake = run_cmake_and_load_cache

        assert_equal("ClaimParentProject_Ours_Test",
                     cmake.cache.value('ParentProject'),
                     'Jagati determines first project is parent.')
        assert_match(/Claiming.+ClaimParentProject_Ours_Test/,
                     cmake.stdout.join,
                     'Jagati still messages about the claim.')
        assert_match(/StaticFoundation.+acknowledges.+ClaimParentProject_Ours_Test.+Parent Project./,
                     cmake.stdout.join,
                     'Jagati sub projects message about acknowledging the claim.')

    end
end
