# Sport coach app - (ScApp)
Web based, _Ruby on Rails_ driven, application for managing sport trainings and people inside a club. Especially
designed for smaller sport clubs and gyms. Main goal is to simplify administration and interconnect coaches,
players and another stuff inside a sport organization.

![Preview of ScApp dashboard](/doc/images/dashboard.png)

## About
This application has been created as final Bachelor's thesis on CTU in Prague.

## Usage
Application can be used for a lot of basic stuff done inside sport club

* organization of members
    * a lot of roles for granting permissions
        * **admin**
        * **coach**
        * **player**
        * **parents**, **sponsor**
    * connections between players supported ( **player** <-- _trained-by_ --> **coach** )
    * organization into groups
    * store important **personal information**

* management of trainings
    * create regular trainings or just one time individual lesson
    * configure **regular training lessons**
        * set rental prices
        * set calculation type of player price
        * set signin and excuse time deadlines
    * assign **regular training coaches** and set their wage
    * assign **regular training players**
    * schedule lessons
    * fill **attendance**
    * measure metrics on training lessons and immediately **analyze current performance**
    * take notes for whole training or for specific player
    * show **training statistics**

* registering and visualisation of **player efficiency**
    * simple statistics (best value, worst value, trend based on _linear regression line_)
    * **configurable chart**

* others
    * fully localized!
    * multiple **VATs** supported
    * multiple **currencies** supported

### Screenshots
Look at some choosen screenshots from example application run - [HERE](/doc/choosen_functionality.md).


## Future
In the close future we want to extend **ScApp** with the following features. Priority is given from the up to the bottom.

* creating **individual training plans**
    * division into parts supported
        * **macrocycle**
        * **mezocycle**
        * **microcycle**
        * each part can have own _specification of goals_
* detailed training lesson planning
    * creating by inserting excercises from database and configuring params (example: you insert _bench press_ and
    configure _weight_, _repetitions_, _speed_ and _pause_)
    * training lessons can be reused
    * output training lesson with time schedule

## Installation

Currently we provide only one install guide for Debian 7.5. In most cases you
will be able to install and successfully run application other distributions.
If you find any error, please report it to issues. We try to fix everything in the
shortest possible time.

For running **ScApp** we recommend own VPS. Minimal requirements should be as follows.
This minimal configuration should be enought for small training center. If you
will experience slow run and long request delays you probably should increase
your hosting plan.

* RAM: 1 GB
* CPU: 1 core
* HDD: 10 GB 

### Debian distribution
It depends on your hosting. Probably you can select _Debian 7.5_ install image in the
hosting backend. Otherwise get one directly from Debian. Following steps suppose
you have successfully installed Debian OS and you have _root_ access.

### Dependencies
Following libraries and utilities are neccessary.

    # run as root!
    apt-get update -y
    apt-get upgrade -y
    apt-get install sudo -y
	
We preffer **Vim** text editor for editing text during the install process. If you
like another text editor, please skip this step.

    #  install vim and set as default editor
    sudo apt-get install -y vim
    sudo update-alternatives --set editor /usr/bin/vim.basic

Install required system libraries

    sudo apt-get install -y build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev curl openssh-server libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev logrotate apt-transport-https ca-certificates imagemagick libmagickwand-dev libgsl0-dev

### Git
SCM needed for handling ScApp versions and for synchronization with main repository.

    # install git
    sudo apt-get install -y git-core
                                                                           g
### Ruby
For further better managing Ruby versions we install Ruby Version Manager - **RVM**.
This small handy utility allows switching between many Ruby versions installed
on the system.

    # Install Ruby Version Manager from sources
    \curl -sSL https://get.rvm.io | bash -s stable --ruby
    # Run RVM init script
    source /usr/local/rvm/scripts/rvm

Install recommended Ruby version for Rails4. You can also use older or newer variant
but it is good practice to use suggested version :)

    # Install recommended Ruby 2.1.0
    rvm install ruby-2.1.0

### MySQL
**MySQL** has been choosen for its popularity. Of course there is possibility to replace
it by **PostgreSQL** or another one supported by **Rails**. But it is currently not covered
by this install guide.

You will be prompted to enter **MySQL** password for root. Please, select something secure!

    # Install the database packages
    sudo apt-get install -y mysql-server mysql-client libmysqlclient-dev

We tune up MySQL a little bit. Following steps will be shown.

* Change the root password? [Y/n] **n**
* Remove anonymous users? [Y/n] **Y**
* Disallow root login remotely? [Y/n] **Y**
* Remove test database and access to it? [Y/n] **Y**
* Reload privilege tables now? [Y/n] **Y**

Run it

    # Secure your installation.
    sudo mysql_secure_installation

Now, create new user. Login password is the one you have entered previously on installation.

    # Login to MySQL
    mysql -u root -p

Every following command is entered in MySQL prompt.

    # Create a user
    # change {password}
    CREATE USER 'scapp'@'localhost' IDENTIFIED BY '{password}';

    # Create the ScApp production database
    CREATE DATABASE IF NOT EXISTS `scapp_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;

    # Grant the ScApp user necessary permissions on the table.
    GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `scapp_production`.* TO 'scapp'@'localhost';

    # Quit the database session
    \q

Test the connection for created **ScApp** user.

    # Try connecting to the new database with the new user
    sudo -H mysql -u scapp -p -D scapp_production

Enter password for scapp user. If everything went successful then You should see prompt.

    #Quit the database session
    \q

You have successfully installed **MySQL**.

### Apache + mod_passenger

Following installation steps are based on official guide for **Phusion Passenger**.
You can get here: http://www.modrails.com/documentation/Users%20guide%20Apache.html.

    # Add software source
    vim /etc/apt/sources.list.d/passenger.list

Insert following (CTRL + SHIFT + V)

    # Debian 7
    deb https://oss-binaries.phusionpassenger.com/apt/passenger wheezy main

Write and quit Vim (type: ":wq" and press enter). Update repository cache.

    # Secure file and update package sources from added ppa repository
    sudo chown root: /etc/apt/sources.list.d/passenger.list
    sudo chmod 600 /etc/apt/sources.list.d/passenger.list
    sudo apt-get update

Now, we can finally install _Phusion Passenger_. It is also possible to use another
web server. For details please see official _mod_passenger_ installation guide.

    # Install Apache webserver with mod_passenger
    sudo apt-get install -y libapache2-mod-passenger
    # Load passenger module
    sudo a2enmod passenger
    sudo service apache2 restart

### Configure virtual host

Firstly, we have to set up our virtual host ( **VH** ) to accept requests and handle them by _ScApp_.
Following configuration covers only required basic setup. Additional security and performance
tips will be added in the future.

Before you continue, You have to have set DNS entry to point to your server. For our example
we use _open-scapp.org_ domain name.

Now, we create necessary directory structure. It is one of basically used naming pattern.
Of course you can choose your own. Then you have to change all further pathes used in this
manual.

    # Change to www root
    cd /var/www
    # Create directories
    sudo mkdir open-scapp.org
    sudo mkdir open-scapp.org/public_html
    sudo mkdir open-scapp.org/logs
    sudo touch open-scapp.org/logs/access.log
    sudo touch open-scapp.org/logs/error.log
    # Change owner to
    sudo chown www-data:www-data -R open-scapp.org

Add Apache **VH** entry.

    sudo vim /etc/apache2/sites-available/open-scapp.org

Insert following configuration. Change your domain specific names in _ServerName_ and
directory names to match created directory structure on the disk.

It is not common setup but if you run webserver on another port change 80 to it
in _VirtualHost_ section. Mostly you will have to change to alternative 8080 port.

    <VirtualHost *:80>
        ServerName open-scapp.org
        DocumentRoot /var/www/open-scapp.org/public_html/public

        CustomLog /var/www/open-scapp.org/logs/access.log combined
        ErrorLog /var/www/open-scapp.org/logs/error.log

        <Directory /var/www/open-scapp.org/public_html/public>
            Allow from all
            Options -MultiViews
            # Uncomment this if you're on Apache >= 2.4:
            # Require all granted
        </Directory>
    </VirtualHost>


Enable configured **VH**.

    # Permit scapp VH and reload configuration
    sudo a2ensite open-scapp.org
    sudo service apache2 force-reload





### Ruby on Rails

**Ruby on Rails** is automatically installed from provided Gemfile. Continue to next installation
step :).

### ScApp install

    # Change to ScApp public www root
    cd /var/www/open-scapp.org/public_html
    sudo git clone https://github.com/hack006/scapp.git ./
    # Change owner to one under Apache is run
    sudo chown www-data:www-data -R ./*

Now we install required **Ruby GEM**s.

    # Use Ruby 2.1.0
    sudo rvm use 2.1.0
    # Update bundler
    sudo gem install bundler
    # Install all required GEMs for production
    bundle install --deployment
    # Install stat sample native extension
    sudo gem install statsample-optimization

Now we have to configure **ScApp**. We start with database. Medify **production** section!
Specify database, username and password. Other settings can be modified but we do not
recommend it unless you really know what you are doing.

    cd config
    sudo cp database.yml.example database.yml
    sudo vim database.yml

Config for our example

    production:
      adapter: mysql2
      encoding: utf8
      reconnect: false
      database: scapp_production
      pool: 5
      username: scapp
      password: insert_your_secret_pswd
      host: localhost

We continue with configuration of **ScApp**. Locale can be now set to _en_ or _cs_. Change to
match your requirements. Do not change indentation because it cause errors!

    sudo cp scapp.example.yml scapp.yml
    sudo vim scapp.yml

Run **ScApp** installation script

    rake scapp:install[cs] RAILS_ENV=production

We have to correct Passenger Ruby version. Run this command to get information what to add
to /etc/apache2/sites-available/open-scapp.org

    passenger-config --ruby-command

Sample output. We are interested in the "Apache" line

    passenger-config was invoked through the following Ruby interpreter:
      Command: /usr/local/rvm/gems/ruby-2.1.0/wrappers/ruby
      Version: ruby 2.1.0p0 (2013-12-25 revision 44422) [x86_64-linux]
      To use in Apache: PassengerRuby /usr/local/rvm/gems/ruby-2.1.0/wrappers/ruby
      To use in Nginx : passenger_ruby /usr/local/rvm/gems/ruby-2.1.0/wrappers/ruby
      To use with Standalone: /usr/local/rvm/gems/ruby-2.1.0/wrappers/ruby /usr/bin/passenger start

Copy it and add to /etc/apache2/sites-available/open-scapp.org

    # Open VH config file for our ScApp application
    sudo vim /etc/apache2/sites-available/open-scapp.org

Reload Apache to activate new configuration

    sudo service apache2 force-reload

Try access your page. If everything is OK then you should see rendered homepage. Only unformatted
text is fine. Last thing we have to do is compile assets to provide JS and CSS to our
customers :).

    # Compile assets
    rake assets:precompile RAILS_ENV=production


## Add new language

Currently we are support only for **Czech** and **English**

Following parts are required to get successfully working locale:

* Add locale to db

    ```ruby
    # in terminal
    Locale.create(name: "lang_name", code: "international_code")
    ```
* Import localization files to _Rails_ locale folder
    * {locale}.yml
        * official translation for basic _Rails_,
        * download most recent from: https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale
    * scapp_global.{locale}.yml
    * simple_form.{locale}.yml


* Add localized help views - all

Do not forget to add _bootstrap-datetime_ require for specified language!

```js
// add entry to each locale, you use
//= require bootstrap-datetimepicker/locales/bootstrap-datetimepicker.cs
```

## Contributing
Any type of contribution is greatly appreciated. Just let me know :) - o[dot]janata[at]gmail[dot]com

### Translation
Currently only _Czech_ and _English_ is supported. If you want to correct translations or add the new one you are welcome.
Translations are held here: [https://webtranslateit.com/en/projects/8960-SCApp](https://webtranslateit.com/en/projects/8960-SCApp).

Many thanks to [webtranslate.it](http://webtranslate.it/) for providing free plan.

## Thanks
I would like to thank my supervisor **Ing. Ondřej Macek** for leading this work. I would like to thanks to excellent
sport coach **Bc. Miloš Péca** for his great assistance at the time of **ScApp** design. I would like to thanks to my
father **Ladislav Janata** to supporting me by testing ScApp for scheduling tennis training lessons in the tennis school.
And finally I would like to thanks rest of my family and everybody else who has supported me at the time of development.

## License
This work is distributed under GPLv3.


