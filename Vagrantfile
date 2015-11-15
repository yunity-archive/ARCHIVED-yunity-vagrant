Vagrant.configure(2) do |config|

  config.vm.box = "yunity"
  config.vm.provision :shell, path: "bootstrap.sh"

  # network setup
  #====================================

  config.vm.network "public_network"

  # port forwardings
  #====================================

  # postgres
  config.vm.network "forwarded_port", guest: 5432, host: 15432

  # redis
  config.vm.network "forwarded_port", guest: 6379, host: 16379

  # webapp
  config.vm.network "forwarded_port", guest: 8090, host: 8090

  # mobile webapp
  config.vm.network "forwarded_port", guest: 8091, host: 8091

  # sockets
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # django
  config.vm.network "forwarded_port", guest: 8000, host: 8000

  # admin/dev server
  config.vm.network "forwarded_port", guest: 5000, host: 5000

  # socket server status
  config.vm.network "forwarded_port", guest: 9080, host: 9080

  # synced folders
  #====================================

  # if the user has these directories, then we mount them inside
  # and they will be used for the setup
  # otherwise the bootstrap.sh script will checkout fresh ones

  [
    'yunity-core', 
    'yunity-webapp-common', 
    'yunity-webapp', 
    'yunity-webapp-mobile'
    ].each do |dir|
    next unless Dir.exists? dir
    config.vm.synced_folder dir, "/home/vagrant/yunity/#{dir}"
  end

  # virtualbox specific
  #====================================

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

end
