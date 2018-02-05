 # Shortcuts for working with the output of the cmake build process

class CMakeOutput
    def initialize(cmake)
        @cmake = cmake
        @jagati = cmake.jagati
        @last_run = nil
    end

    attr_reader :stdout
    attr_reader :stderr

    def view_stderr
        encoding_options = {
            :invalid            => :replace,
            :undef              => :replace,
            :replace            => '',
            :universal_newline  => true
        }
        stdout.join("").encode(Encoding.find('ASCII'), encoding_options)
    end

    ###############################################################
    # Platform stuff

    def executable_prefix
        if Gem.win_platform? then "" else "./" end
    end

    def executable_suffix
        if Gem.win_platform? then ".exe" else "" end
    end

    ###############################################################
    # Command Getters

    def binary_command
        "#{executable_prefix}#{@jagati.binary_target_name}#{executable_suffix}"
    end

    def test_command
        "#{executable_prefix}#{@jagati.test_target_name}#{executable_suffix}"
    end

    ###############################################################
    # Command invocations

    def run_binary
        Dir.chdir(@cmake.build_dir) {
            stdin, stdout, stderr = Open3.popen3(binary_command)
            @stdout = stdout.readlines
            @stderr = stderr.readlines
        }
        @last_run = :binary
    end

    def run_tests
        Dir.chdir(@cmake.build_dir) {
            stdin, stdout, stderr = Open3.popen3(test_command)
            @stdout = stdout.readlines
            @stderr = stderr.readlines
        }
        @last_run = :tests
    end

    ###############################################################
    # Command invocations

    def error_on_binary
        raise RuntimeError.new "Binary was run instead of tests" unless @last_run == :tests
    end

    def test_success_count
        error_on_binary
        view_stderr[/$\s+Success \d+/][/\d+/].to_i
    end

    def test_warning_count
        error_on_binary
        view_stderr[/$\s+Warning \d+/][/\d+/].to_i
    end

    def test_skipped_count
        error_on_binary
        view_stderr[/$\s+Skipped \d+/][/\d+/].to_i
    end

    def test_cancelled_count
        error_on_binary
        view_stderr[/$\s+Cancelled \d+/][/\d+/].to_i
    end

    def test_inconclusive_count
        error_on_binary
        view_stderr[/$\s+Inconclusive \d+/][/\d+/].to_i
    end

    def test_failed_count
        error_on_binary
        view_stderr[/$\s+Failed \d+/][/\d+/].to_i
    end

    def test_unknown_count
        error_on_binary
        view_stderr[/$\s+Unknown \d+/][/\d+/].to_i
    end

    def test_not_applicable_count
        error_on_binary
        view_stderr[/$\s+NotApplicable \d+/][/\d+/].to_i
    end

    def test_worst_result
        error_on_binary
        view_stderr[/$\s+From \d+ tests the worst result is: [a-zA-Z]+/].split(" ")[-1]
    end
end
