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
        stdout.
            join("").
            encode(Encoding.find('ASCII'),
                :invalid            => :replace,
                :undef              => :replace,
                :replace            => '',
                :universal_newline  => true
            )
    end

    ###############################################################
    # Platform stuff

    def executable_prefix
        if Gem.win_platform? then '' else './' end
    end

    def executable_suffix
        if @cmake.cxx && @cmake.cxx.include?('em++') then
            '.js'
        else
            if Gem.win_platform? then '.exe' else '' end
        end
    end

    ###############################################################
    # Command Getters

    def binary_command
        "#{executable_prefix}#{@jagati.binary_target_name}#{executable_suffix}"
    end

    def test_command
        "#{executable_prefix}#{@jagati.test_target_name}#{executable_suffix}"
    end

    def check_binary_command
        check_output_folder_for_file(binary_command)
    end

    def check_test_command
        check_output_folder_for_file(test_command)
    end

    def command_runner_prefix
        if @cmake.cxx && @cmake.cxx.include?('em++') then 'node ' else '' end
    end

    def command_runner_suffix
        if @cmake.cxx && @cmake.cxx.include?('em++') then ' NoThreads' else '' end
    end

    def check_output_folder_for_file(file)
        #require 'pry'; binding.pry
        if File.exist?(File.join(@cmake.build_dir, file)) then
            return nil
        else
            indent = "    "
            spacer = "\n#{indent}"
            files = Dir[File.join(@cmake.build_dir, "/**/*")] # + Dir[File.join(@cmake.source_dir, "/**/*")]
            raise "Could not find #{file} in output folder, here are contents:#{spacer}#{files.join(spacer)}\n" +
                  "Here is the stdout:#{spacer}#{@cmake.stdout.join(indent)}\n" +
                  "And the stderr:#{spacer}#{@cmake.stderr.join(indent)}"
        end
    end

    ###############################################################
    # Command invocations

    def run_command(command)
        Dir.chdir(@cmake.build_dir) {
            stdin, stdout, stderr = Open3.popen3(command)
            @stdout = stdout.readlines
            @stderr = stderr.readlines
        }
    end

    def run_binary
        check_binary_command
        run_command(command_runner_prefix + binary_command)
        @last_run = :binary
    end

    def run_tests
        check_test_command
        run_command(command_runner_prefix + test_command + command_runner_suffix)
        @last_run = :tests
    end

    ###############################################################
    # Command invocations

    def error_on_binary
        raise RuntimeError.new "Binary was run instead of tests" unless @last_run == :tests
    end


    def find_count_in_stderr(needle)
        view_stderr[/$\s+#{needle} \d+/].to_s[/\d+/].to_i
    end

    def test_success_count
        error_on_binary
        find_count_in_stderr 'Success'
    end

    def test_warning_count
        error_on_binary
        find_count_in_stderr 'Warning'
    end

    def test_skipped_count
        error_on_binary
        find_count_in_stderr 'Skipped'
    end

    def test_cancelled_count
        error_on_binary
        find_count_in_stderr 'Cancelled'
    end

    def test_inconclusive_count
        error_on_binary
        find_count_in_stderr 'Inconclusive'
    end

    def test_failed_count
        error_on_binary
        find_count_in_stderr 'Failed'
    end

    def test_unknown_count
        error_on_binary
        find_count_in_stderr 'Unknown'
    end

    def test_not_applicable_count
        error_on_binary
        find_count_in_stderr 'NotApplicable'
    end

    def test_worst_result
        error_on_binary
        view_stderr[/$\s+From \d+ tests the worst result is: [a-zA-Z]+/].to_s.split(" ")[-1]
    end
end
