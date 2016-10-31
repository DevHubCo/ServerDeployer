class Handler
  attr_reader :ssh, :options

  def initialize(ssh, options = {})
    @ssh = ssh
    @options = options
  end

  def run(cmd)
    channel = ssh.open_channel do |ch|
      ch.exec cmd do |ch, success|
        raise "could not execute command" unless success

        ch.on_data do |c, data|
          $stdout.print "\e[32;1mSERVER: \e[0m#{data}" unless data == "\n"
        end

        # "on_extended_data" is called when the process writes something to stderr
        ch.on_extended_data do |c, type, data|
          $stderr.print data
        end

        ch.on_close { puts "\n\e[32;1mDone!" }
      end
    end

    channel.wait
  end
end