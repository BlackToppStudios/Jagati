# This is a simple class for invoking cmake

require './CMakeCache'

# Ruby std lib stuff
require 'fileutils'
require 'pathname'
require 'open3'

class CMake
    attr_reader :source_dir
    attr_reader :build_dir

    attr_reader :invocation_stdout
    attr_reader :invocation_stderr

    def initialize(source_dir, build_dir = "#{source_dir}/build")
        @source_dir = Pathname.new(source_dir).realpath
        FileUtils::mkdir_p build_dir
        @build_dir = Pathname.new(build_dir).realpath
        clear_arguments
    end

    def clear_build_dir
        FileUtils::mkdir_p @build_dir
        cache.remove_file
    end

    def add_argument(name, value, type=nil)
        if type.nil? then
            @args[name]=value
        else
            @args[name]="#{value}:#{type}"
        end
    end

    def clear_arguments
        @args={}
    end

    def invocation_string
        arg_string = @args.collect { |k,v| " -D#{k}=#{v}" }.join
        "cmake #{source_dir}#{arg_string}"
    end

    def invoke
        clear_build_dir
        Dir.chdir(@build_dir) {
            stdin, stdout, stderr = Open3.popen3(invocation_string)
            @invocation_stdout = stdout.readlines
            @invocation_stderr = stderr.readlines
        }
    end

    def cache
        CMakeCache.new("#{@build_dir}/CMakeCache.txt")
    end

end
