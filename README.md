# CampMinder.rb

[![Circle CI](https://circleci.com/gh/interexchange/campminder-rb.svg?style=svg)](https://circleci.com/gh/interexchange/campminder-rb)
[![Code Climate](https://codeclimate.com/github/interexchange/campminder-rb/badges/gpa.svg)](https://codeclimate.com/github/interexchange/campminder-rb)
[![Test Coverage](https://codeclimate.com/github/interexchange/campminder-rb/badges/coverage.svg)](https://codeclimate.com/github/interexchange/campminder-rb)

Library to interface InterExchange with the [CampMinder](http://www.campminder.com) ClientLink API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'CampMinder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install CampMinder

## Configuration

Environment variables are used to configure your CampMinder credentials.

`CAMPMINDER_BUSINESS_PARTNER_ID`:
The integer ID of your company in CampMinder's system.

`CAMPMINDER_SECRET_CODE`:
The secret code of your company in CampMinder's system.

`CAMPMINDER_WEB_SERVICE_URL`:
A URL on CampMinder’s system to which you will send all
outgoing requests.

`CAMPMINDER_REDIRECTION_URL`:
A URL on CampMinder’s system to which you will redirect control as
the last step of the Connection Establishment procedure.

`CAMPMINDER_PROXY_URL`:
Optional. If set, any communications with CampMinder's system will
be sent through a proxy.

For local gem testing there is a `.env` file in this respository with
sample settings.

## Usage

Set up the route to your CampMinder endpoint in `config/routes.rb`

```
post "camp_minder_handler", to: "camp_minder_handler#create"
```

Set up your `app/controllers/camp_minder_handler_controller.rb`

```
class CampMinderHandlerController < ActionController::Base
  include ::CampMinder::HandlerController
end
```

For the `ClientLinkRequest`, your controller will need to implement three methods.

`valid_username_password?` takes username and password as parameters and should
return true or false depending on whether or not the user exists in your application.

```
def valid_username_password?(username, password)
  @user = ::User.find_by_email(username)
  @user.present? && @user.valid_password?(password)
end
```

`partner_client_id` should return your application's ID for the user's employer.

```
def partner_client_id
  @user.employer.id
end
```

`store_partner_client` takes partner_client_id, , client_id, person_id, token, and connection_status
as arguments, and should store these in some form in your database. Returns true on success.

```
def store_partner_client(partner_client_id, client_id, person_id, token, connection_status)
  CampMinderPartnerClientConnection.create(
    partner_client_id: partner_client_id,
    client_id: client_id,
    person_id: person_id,
    token: token,
    connection_status: connection_status
  ).valid?
end
```

### ClientLinkRequest

POST https://partner.eg/camp_minder_handler
CONTENT-TYPE ?multipart/form-data?

## Domain

### CampMinder

All Classes are namespaced within `CampMinder`, we're using example documentation
provided to us by CampMinder to build the domain tests.

### Partner

InterExchange is the partner, we're the system which is going to connect to CampMinder

### Client

A Camp is the Client, this is the place where the Staff are going to be working

### Person

A Camp's Contact is going to be a Person who authorizes the link between the Client and us, the Partner

### Staff

As a staffing partner we use the API to send Staff for the client.

## Testing

    $ rake

There is a dummy rails app at `spec/dummy`, the gems spec suite should be used to execute these tests, eg:

    rspec spec/dummy/spec/

## Contributing

1. Fork it ( https://github.com/interexchange/campminder-rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## LICENCE

`LICENSE.txt`
