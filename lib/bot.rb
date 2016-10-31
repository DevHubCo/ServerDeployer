require "net/ssh"
require_relative "./handler"
require_relative "./security"
require_relative "./updater"
require_relative "./firewall"

class Bot
  attr_reader :host, :user, :options

  SERVICES = [Updater, Security, Firewall]

  def initialize(host, user, options = {})
    @host = host
    @user = user
    @options = options
  end

  def call
    if options[:password] && !key_sent?
      puts "Sending SSH key"
      c = Net::SSH.start(host, user, password: options[:password])
      ssh_key = File.read("./public.key")
      c.open_channel do |channel|
        channel.exec("mkdir -p ~/.ssh && cat > ~/.ssh/authorized_keys") do |ch, success|
          channel.on_data do |ch, data|
            res << data
          end

          channel.send_data ssh_key
          channel.eof!
        end
      end
      c.loop
    end

    Net::SSH.start(host, user) do |ssh|
      SERVICES.each do |s|
        s.new(ssh).call
      end
    end
  end

  def key_sent?
    begin
      Net::SSH.start(host, user, non_interactive: true) do |ssh|
        output = ssh.exec! "hostname"
        return true if output
      end
    rescue Net::SSH::AuthenticationFailed
      return false
    end
  end
end