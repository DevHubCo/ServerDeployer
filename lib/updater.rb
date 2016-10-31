class Updater < Handler
  def call
    run "apt-get update"
    run "apt-get -y upgrade"
  end
end