 # Shortcuts for getting at internal Jagati values from Ruby.

class CMakeJagati
    def initialize(cmake)
        @cache = cmake.cache
        @project_name = @cache.project_name
    end

    attr_reader :project_name

    ###############################################################
    # Directories

    def doxygen_dir
        @cache.value(@project_name + 'DoxDir')
    end

    def include_dir
        @cache.value(@project_name + 'IncludeDir')
    end

    def library_dir
        @cache.value(@project_name + 'LibDir')
    end

    def source_dir
        @cache.value(@project_name + 'SourceDir')
    end

    def swig_dir
        @cache.value(@project_name + 'SwigDir')
    end

    def test_dir
        @cache.value(@project_name + 'TestDir')
    end

    def generated_header_dir
        @cache.value(@project_name + 'GenHeadersDir')
    end

    def generated_source_dir
        @cache.value(@project_name + 'GenSourceDir')
    end

    ###############################################################
    # Binaries

    def binary_target_name
        @cache.value(@project_name + 'BinTarget')
    end

    def library_target_name
        @cache.value(@project_name + 'LibTarget')
    end

    def test_target_name
        @cache.value(@project_name + 'TestTarget')
    end

    ###############################################################
    # File Lists

    def source_file_list
        @cache.value(@project_name + 'SourceFiles')
    end

    def header_file_list
        @cache.value(@project_name + 'HeaderFiles')
    end

    def dox_file_list
        @cache.value('JagatiDoxArray')
    end

    def swig_file_list
        @cache.value(@project_name + 'SwigFiles')
    end

end
