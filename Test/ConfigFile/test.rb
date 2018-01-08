# If is hard to test the creation of files reliably. This is limited to what is
# testable and its other effects on the Jagati state.

class ConfigFile < JagatiTestCase
    def test_emit
        skip "Check that the config file winds up in the header file list."
        cmake = run_cmake_and_load_cache

        # do tests here
    end
end
