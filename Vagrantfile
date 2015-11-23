Vagrant.configure(2) do |config|

  config.vm.box = "debian/jessie64"

  Dir['scripts/*'].each do |path|
    filename = File.basename(path)
    config.vm.provision :file,
      source: path,
      destination: "/home/vagrant/#{filename}"
  end

  config.vm.provision :shell, path: "bootstrap"

  config.vm.network "public_network"

  # same port inside and out for these
  [
    8000, # django
    8080, # sockets
    9080  # sockets admin
  ].each do |port|
    config.vm.network :forwarded_port, guest: port, host: port
  end

  # postgresql
  config.vm.network :forwarded_port, guest: 5432, host: 15432

  # redis
  config.vm.network :forwarded_port, guest: 6379, host: 16379

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end

end
