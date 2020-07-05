# Authentication Upgrade

This describes 'Authentication Upgrade' due to changing framework.<br />
Target of the example is Ruby on Rails, password encryption upgrades from 'MD5' with 2 charactors salt to [devise](https://github.com/heartcombo/devise) standard BCrypt.<br />
This program has 3 stages<br />

- Stage Legacy: implement MD5 (legacy encryption) authentication to Rails devise.
- Stage Custom: upgrade encryption system more secure.
- Stage BCrypt: upgrade to use BCrypt

You can upgrade from Stage Legacy to Stage Custom, and from Stage Custom to Stage RoR using rake task.<br />
<br />
Stage Custom is not necessary.<br />
You can upgrade from legacy to BCrypt directory.<br />
Decribing Stage Custom is only for record.

## Environment:
Programing environment is as below.

* Ubuntu 18.04.1 LTS x86_64
* ruby 2.7.1p83
* Rails 6.0.3.2


## Application Installation Instructions:
    git clone git@github.com:kay1759/auth_upgrade.git
    cd auth_upgrade
    bundle install --path vendor/bundle
    bundle exec rake db:migrate
    bundle exec rake db:seed

'rake db:seed' regists an user below:
* email: user@wizis.com  (wizis.com is domain the author has)
* password: abcd1234

you can use this account or register another account as you like.

## Operating Instructions:

### Usage:

    bundle exec rails server -b 0.0.0.0

    connet with browzer


### Valid URL
    /
    /users/sign_in
    /users/sign_up
    /users/sign_out (DELETE)


* When you are not logged in, access to '/' redirects to '/user/sign_in'
* When you are logged in, access to '/user/sign_in' or '/user/sign_up' redirects to '/'

After logged in, Email, Encrypted Password and Salt are shown in home page.

**Please log out and stop server, and execute rspec and update task**


## Upgrade of Authentication

    bundle exec rake auth_update:update


update from Legacy to Custom at first.<br />
from Custom to BCrypt at the second time.

## Using Legacy Authentication on device (standard authentication library for Ruby on Rails)

* install gem '[devise-encryptable](https://github.com/heartcombo/devise-encryptable)'
* add encryptable option for devise section in Model.
* describe digest function on "/config/initializers/devise_encryptable.rb"
* point the encryptor in "/config/initializers/devise.rb" - comment out in default


## Logic of Upgrade to BCrypt

When login, user input the plain password.
```
if Bcrypt encryption OK
      login
elsif existing encryption OK
      Save encrypted password using Bcrypt
      Login
else
      Authentication Failure
```

## Login of Stage Custom Authentication

    f -> encrypt function (existing, weak)
	g -> encrypt function (stronger)

    update db, encrypted_password data with
	encrypted_password = g(encrypted_password)

When login, user input the plain password.

	ecnrypted_password == g( f( plain password)) ?



## Test

    bundle exec rspec


run different test with Legacy, Custom or BCrypt stage.

##

## References:
- [devise](https://github.com/heartcombo/devise)
- [devise-encryptable](https://github.com/heartcombo/devise-encryptable)

## Licence:

[MIT]

## Author

[Katsuyoshi Yabe](https://github.com/kay1759)
