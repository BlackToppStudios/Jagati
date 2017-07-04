# This tests The the Mezz_PackageDirectory feature works correctly

class TestPackageDirectory < TestCase

    def initialize(arg)
        @source_dir = 'Mezz_PackageDirectory'
        super arg
    end

    # Because this is first set of tests, some basic sanity tests for the test tools
    def test_cmake
        cmake = CMake.new(@source_dir)

        refute_equal(@source_dir.size, cmake.source_dir.size, 'Cmake class should convert to absolute path')
        assert_match(/build$/, cmake.build_dir.to_s, 'Cmake class should pick a sane build directory')

        cmake.add_argument 'name', 'value'
        cmake.add_argument 'typedname', 'typedValue', 'STRING'
        cmake.add_argument 'CMAKE_BUILD_TYPE', 'debug'
        assert_match(/-Dname=value/, cmake.invocation_string, 'Cmake args are in correct format')

        cache = cmake.cache
        cache.remove_file
        assert_equal(false, cache.file_valid?, "Not having a file should invalidate cache")

        cmake.invoke
        cache.load_cache # This reads the file
        assert_equal(true, cache.file_valid?, 'When cmake runs it should create a cache file')
        assert_equal('value', cache.value('name'), 'Custom Values can be read from the CMakeCache')
        assert_equal('typedValue', cache.value('typedname'), 'Custom Typed Values can be read from the CMakeCache')
        assert_equal('STRING', cache.type('typedname'), 'Types can be read from the CMakeCache')
        assert_equal('debug', cache.value('CMAKE_BUILD_TYPE'), 'Normal Values can be read from the CMakeCache')
    end
    
    def test_default_location
        ENV.delete('MEZZ_PACKAGE_DIR') # To prevent interference from system settingss
    
        cmake = CMake.new(@source_dir)
        cmake.clear_build_dir
        cmake.invoke

        # Does the Jagati pick a good location in the Build directory?
        expected_dir = "#{Dir.lpwd}/#{@source_dir}/build/JagatiPackages"        
        assert_equal(expected_dir, cmake.cache.value('MEZZ_PackageDirectory'), 'Has sane default package dir')

        # Does the warning look good?
        assert_match(/CMake Warning/, cmake.invocation_stderr.join, 'There is a warning')
        assert_match(/Environment\s*variable[ \t']*MEZZ_PACKAGE_DIR/, cmake.invocation_stderr.join,
            'The warning mentions the environment variable')
        assert_match(/MEZZ_PackageDirectory/, cmake.invocation_stderr.join, 'The warning mentions the cmake setting')
        
    end
    
    def test_location_from_env
        package_dir = "#{Dir.lpwd}/#{@source_dir}/build/foo"
        FileUtils::mkdir_p package_dir
        ENV['MEZZ_PACKAGE_DIR'] = package_dir

        cmake = CMake.new(@source_dir)
        cmake.clear_build_dir
        cmake.invoke

        expected_dir = package_dir
        assert_equal(expected_dir, cmake.cache.value('MEZZ_PackageDirectory'), 'Reads MEZZ_PACKAGE_DIR Dir from ENV')
    end
    
    def test_location_from_arg
        ENV.delete('MEZZ_PACKAGE_DIR')
        
        package_dir = "#{Dir.lpwd}/#{@source_dir}/build/foo"
        FileUtils::mkdir_p package_dir

        cmake = CMake.new(@source_dir)
        cmake.add_argument 'MEZZ_PackageDirectory', package_dir
        cmake.clear_build_dir
        cmake.invoke

        expected_dir = package_dir
        assert_equal(expected_dir, cmake.cache.value('MEZZ_PackageDirectory'), 'Respects passed MEZZ_PackageDirectory')
    end

end
