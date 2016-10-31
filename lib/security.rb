class Security < Handler
  def call
    puts "Started security"
    run "sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config"
    run "sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config"
    run "touch /tmp/restart-ssh"
    puts "Ended security"
  end
end