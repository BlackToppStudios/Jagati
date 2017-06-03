# This is a simple class for checking for values in the CMakeCache.txt

class CMakeCache

    attr_reader :file_name
    attr_reader :file_contents

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
            puts "Cache file is a directory, could load '#{@file_name}'"
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
            if found = line.match(/^([^#]+):([^#]+)=([^#]+)$/)
                name, type, value = found.captures
            end
            @value_cache[name] = value
            @type_cache[name] = type
        end
    end

    def value(name)
        @value_cache[name]
    end
    
    def type(name)
        @type_cache[name]
    end
end
