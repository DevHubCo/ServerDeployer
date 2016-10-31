class Firewall < Handler
  def call
    run "ufw logging on"

    run "ufw default deny"

    run "ufw allow ssh/tcp"
    run "ufw limit ssh/tcp"

    run "ufw allow http/tcp"
    run "ufw allow https/tcp"

    run "echo 'y' | ufw enable"

    run "apt-get -y install fail2ban"
  end
end