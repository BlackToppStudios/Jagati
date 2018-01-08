# This is a simple class for checking for values in the CMakeCache.txt

class CMakeCache

    attr_reader :file_name
    attr_reader :file_contents

    attr_reader :value_cache

    def initialize(file_name)
        @file_name = file_name
        if file_valid? then load_cache end
    end

    def remove_file
        if File.file?(@file_name) then
            File.delete @file_name
        end
    end

    def file_valid?
        File.exist?(@file_name) && File.file?(@file_name)
    end

    def check_cache_file_validity
        if !File.exist?(@file_name) then
            puts "Cache file does not exists, could not find '#{@file_name}'."
            abort
        end
        if !File.file?(@file_name) then
            puts "Cache file is a directory, could not load '#{@file_name}'"
            abort
        end
    end

    def load_cache
        check_cache_file_validity
        file = File.open(@file_name, "rb")
        @file_contents = file.read
        file.close
        clean_contents
    end

    def clean_contents
        lines = @file_contents.split("\n")
        @value_cache = {}
        @type_cache = {}
        lines.each do |line|
            if found = line.match(/^([^#:]+):([^#=]+)=([^#]*)$/)
                name, type, value = found.captures
            end
            if !name.nil?
                @value_cache[name] = value.to_s.tr("\r", '')
                @type_cache[name] = type
            end
        end
        nil
    end

    def value(name)
        samecase_drive(@value_cache[name]).to_s
    end

    def type(name)
        @type_cache[name].to_s
    end

    def project_name
        value('CMAKE_PROJECT_NAME')
    end
end
