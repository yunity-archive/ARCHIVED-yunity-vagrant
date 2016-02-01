# yunity-vagrant

Builds a vagrant box that you can use to run the yunity backend apps.

You only need to use this repo if you are wanting to build `yunity-backend.box`.

## Building

```
git clone git@github.com:yunity/yunity-vagrant.git
cd yunity-vagrant
vagrant up
vagrant ssh -- ./update
# optionally do some cleanup (zero out disk, `apt-get clean`, ...)
vagrant package --output yunity-backend-1.0.box
```

To update the packages inside the vm image you can run one of:

```
vagrant reload --provision # if it's already running
vagrant up --provision     # if it's not running
```

## Prerequisites

vagrant (version 1.7 or higher) and virtualbox (version 5 or higher) are required.

Either get them using your package manager or download them from:

* [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
* [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

### Ubuntu/Debian

The packaged version of vagrant is probably too old, you can install a good version from the vagrant site:

```
wget https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.deb
sudo dpkg -i vagrant_1.7.4_x86_64.deb
```

### archlinux

This will install vagrant and virtualbox and configure the kernel module.

```
sudo pacman -S vagrant virtualbox virtualbox-host-dkms linux-headers
sudo dkms install vboxhost/5.0.8 # this version could change of course...
sudo /sbin/rcvboxdrv
```

Optionally, if you want to have dkms rebuild on kernel upgrade, you must enable it:
```
systemctl enable dkms.service
```

If you want to load the module on boot, edit:
```
/etc/modules-load.d/virtualbox.conf
```

(the kernel modules needed should be `vboxnetadp vboxnetflt vboxpci vboxdrv`)
