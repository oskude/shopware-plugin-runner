Vagrant.configure(2) do |config|
	config.vm.box = "debian/jessie64"
	config.vm.hostname = "plugin-runner"
	config.vm.network "private_network", ip:"10.20.30.40"
	config.vm.provider "virtualbox" do |vb|
		vb.cpus = 2
		vb.memory = 2048
	end
	config.vm.provision "shell", inline: <<-ENDOFPROVISION
		apt-get update
		apt-get upgrade -y
		apt-get install -y debconf-utils
		debconf-set-selections <<-'EOF'
			mysql-server mysql-server/root_password password vagrant
			mysql-server mysql-server/root_password_again password vagrant
		EOF
		apt-get install -y debconf-utils unzip mysql-server apache2 libapache2-mod-php5 php5 php5-mysql php5-curl php5-gd python3-pip firefox-esr xvfb
		pip3 install selenium
		cat <<- 'EOF' > /etc/apache2/sites-available/plugin-runner.conf
			<VirtualHost *:80>
			  ServerName plugin-runner
			  DocumentRoot "/home/vagrant/shopware"
			  <Directory "/home/vagrant/shopware">
			    Require all granted
			    AllowOverride all
			  </Directory>
			</VirtualHost>
		EOF
		cat <<- 'EOF' >> /etc/php5/apache2/php.ini
			memory_limit = 256M
		EOF
		mysql -u root -pvagrant <<- 'EOF'
			CREATE DATABASE shopware;
		EOF
		a2enmod rewrite
		a2ensite plugin-runner
		systemctl restart apache2
	ENDOFPROVISION
	config.vm.provision "shell", privileged: false, inline: <<-ENDOFPROVISION
		chmod o+rx ~
		mkdir ~/shopware
		cd ~/shopware
		unzip -q /vagrant/shopware.zip
		sudo setfacl -Rm u:www-data:rwX,u:$USER:rwX config.php var web files recovery media themes/Frontend engine/Shopware/Plugins/
		sudo setfacl -Rdm u:www-data:rwX,u:$USER:rwX config.php var web files recovery media themes/Frontend engine/Shopware/Plugins/
	ENDOFPROVISION
end
