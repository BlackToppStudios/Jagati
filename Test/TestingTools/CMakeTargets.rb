 # Shortcuts for getting at internal Jagati values from Ruby.

class CMakeTargets
    attr_reader :target_file

    def initialize(cmake)
        @target_file = cmake.build_dir + 'CMakeFiles/TargetDirectories.txt'
        @target_array = []
        load_target_file
    end

    def load_target_file
        return nil unless File.exist? @target_file
        File.open(@target_file).each do |line|
            if found = line.match(/.*\/([^\/]+).dir/)
                @target_array << found.captures.first
            end
        end
    end

    # This makes it so any calls to normal array methods work with needing to get directly at the underlying array,
    # without the called needing to worry about how that array gets populated or its implementation details.
    def method_missing(method, *args)
        if @target_array.respond_to?(method)
            @target_array.send(method, *args)
        else
            super
        end
    end

    def respond_to?(method)
        if @target_array.respond_to?(method)
            true
        else
            super
        end
    end
end
