# This is the default test case class for test groups in this suite. Classes that
# would have inherited from TestCase should inherit from this to set some Jagati
# and CMake specific behaviors to ease testing

class JagatiTestCase < TestCase
    def initialize(arg)
        # We presume that the class name matches the source directory.
        @source_dir = self.class.to_s
        super arg
    end

    # Use this when running cmake and never checking the cache. If you
    # don't need it don't bother populating it. If it will be created 
    # anyway, but is measured to be slightly slower.
    def run_cmake
        cmake = CMake.new(source_dir)
        cmake.invoke
        cmake
    end

    # Some tests will need the cache quite a bit, they should use this to
    # preload it. If this cache is needed this is slightly faster.
    def run_cmake_and_load_cache(fail_mode = :cannot_fail)
        cmake = run_cmake
        cmake.cache.load_cache
        if :cannot_fail == fail_mode then cmake.fail_if_error end
        cmake
    end

    attr_reader :source_dir
end
