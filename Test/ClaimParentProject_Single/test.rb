# This tests The the Mezz_PackageDirectory feature works correctly when there
# is only a single project.

class ClaimParentProject_Single < JagatiTestCase
    def test_single_project
        cmake = run_cmake_and_load_cache

        assert_equal("ClaimParentProject_Test",
                     cmake.cache.value('ParentProject'),
                     'Jagati determines only project is parent.')
        assert_match(/Claiming.+ClaimParentProject_Test/,
                     cmake.stdout.join,
                     'Jagati messages about claiming the parent project.')
    end
end
