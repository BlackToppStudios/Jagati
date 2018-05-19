# This is a simple class for invoking cmake

require_relative 'CMakeCache'
require_relative 'CMakeJagati'
require_relative 'CMakeOutput'
require_relative 'CMakeTargets'

# Ruby std lib stuff
require 'fileutils'
require 'pathname'
require 'open3'

class CMake
    attr_reader :source_dir
    attr_reader :build_dir

    attr_reader :stdout
    attr_reader :stderr

    class << self
        attr_accessor :generator
    end

    def initialize(source_dir, build_dir = smart_build_dir(source_dir))
        @source_dir = Pathname.new(source_dir).realpath
        FileUtils::mkdir_p build_dir
        @build_dir = Pathname.new(build_dir).realpath
        @invoked = false
        @stdout = []
        @stderr = []
        clear_arguments
    end

    def smart_build_dir(source_dir)
        File.join(source_dir, "..", "builds", source_dir + "-build")
    end

    def clear_build_dir
        FileUtils::mkdir_p @build_dir
        cache.remove_file
        @cache = nil
        @jagati = nil
        @targets = nil
    end

    def add_argument(name, value, type=nil)
        if type.nil? then
            @args[name]=value
        else
            @args["#{name}:#{type}"]=value
        end
    end

    def add_arguments(arguments={})
        arguments.each do |name, value|
            add_argument name, value
        end
    end

    def clear_arguments
        @args={}
        @cache = nil
        @jagati = nil
        @targets = nil
        @outputs = nil
    end

    def invocation_string
        arg_string = if CMake.generator.nil? then "" else " -G\"#{CMake.generator}\"" end
        arg_string += @args.collect { |k,v| " -D#{k}=#{v}" }.join
        "cmake #{source_dir}#{arg_string}"
    end

    def invoke
        clear_build_dir
        Dir.chdir(@build_dir) {
            stdin, stdout, stderr = Open3.popen3(invocation_string)
            @stdout += stdout.readlines
            @stderr += stderr.readlines
        }
        @invoked = true
    end

    def cache
        @cache ||= CMakeCache.new("#{@build_dir}/CMakeCache.txt")
    end

    def jagati
        @jagati ||= CMakeJagati.new(self)
    end

    def outputs
        @outputs ||= CMakeOutput.new(self)
    end

    def targets
        @targets ||= CMakeTargets.new(self)
    end

    def fail_if_error
        # A temporary hack to reject lines from git pulls being up to date
        err = stderr.join("")
        err.slice!(/From.*FETCH_HEAD\n/m) # Nuke git checkout messages
        err.slice!(/CMake.*MEZZ_PackageDirectory.*StandardJagatiSetup\)\n\n\n/m) # cut out MEZZ_PackageDirectory Error
        unless err.empty? then
            raise "A CMake Error Occurred:\n" + stderr.join 
        end
    end

    def invoked?
        @invoked
    end

    def build_string
        "cmake --build ."
    end

    def build
        invoke unless invoked?
        Dir.chdir(@build_dir) {
            stdin, stdout, stderr = Open3.popen3(build_string)
            @stdout += stdout.readlines
            @stderr += stderr.readlines
        }
        @invoked
    end
end
