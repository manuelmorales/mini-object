# MiniObject

[![Gem Version](https://badge.fury.io/rb/mini_object.svg)](http://badge.fury.io/rb/mini_object)
[![Build Status](https://travis-ci.org/manuelmorales/mini-object.svg)](https://travis-ci.org/manuelmorales/mini-object)
[![Code Climate](https://codeclimate.com/github/manuelmorales/mini-object/badges/gpa.svg)](https://codeclimate.com/github/manuelmorales/mini-object)
[![Test Coverage](https://codeclimate.com/github/manuelmorales/mini-object/badges/coverage.svg)](https://codeclimate.com/github/manuelmorales/mini-object/coverage)

A set of tools which will make easier to work with objects instead of classes
and injecting dependencies.


## Inline

Allows defining objects ad-hoc passing an initialization block.

```ruby
homer = Inline.new 'Homer Simpson' do
  def talk
    'Doh!'
  end

  def sleep
  end
end
# => < Homer Simpson / Inline : talk, sleep >

homer.talk
# => 'Doh!'
```

## Injectable

Makes easier and nicer to assign values and inject dependencies to objects. 
The key feature is the ability to assign lambdas as way to resolve the value:

```ruby
class UsersRepository
  include Injectable
  attr_injectable :store
end

users_repo = UsersRepository.new
users_repo.store{ app.stores.redis }
```

In the example, if `app.stores.persistent` changes, the repository
will inmediately see the new store.


## RemarkableInspect

Provides an `inspect` and `to_s` which focus on methods:

```ruby
class Application
  include RemarkableInspect

  def config; end
  def config=; end
  def stores; end
end
# => Application( config/=, stores )

Application.new
# => < Application : config/=, stores >
```

## Lazy

A proxy that will lazy evaluate the proxied object.
Useful when an object expect an dependency but we want to
instantiate it only on demand:

```ruby
users_repository.store = Lazy.new { Redis.new }
```

This way `Redis.new` will only be  executed when `users_repository.store`
it is called for the first time.

It also allows defining build callbacks:

```ruby
users_repository.store = Lazy.new { Redis.new }
users_repository.build_step(:clear) { |redis| redis.flushdb }
```


## Resolver

A proxy that will always evaluate the given block.
Useful when an object expect an dependency but we want it 
to be resolved on demand:

```ruby
users_repository.store = Lazy.new{ app.stores.redis }
```

In the example, if `app.stores.redis`, the repository
will inmediately see the new store.


## IndexedList

An enumerable of objects that makes it easy to create custom collections.
It allows to find items by a custom key, similar to a Hash.
When iterating through the items it only passes just the object, not the keys.
Allows to define a build proc, so you can add new items with the `add_new` method.
Plays well with `ForwardingDsl::Getsetter`:

```ruby
require 'forwarding_dsl'
require 'mini_object'

class User
  include ForwardingDsl::Getsetter
  getsetter :name
  getsetter :surname
end

users = MiniObject::IndexedList.new.tap do |l|
  l.key {|user| user.name }
  l.build { User.new }
end

users.add_new do
  name 'John'
  surname 'Smith'
end

users['John'] # => #<User:0x007fd91e05deb8 @name="John", @surname="Smith">

users.each {|user| puts "#{user.name} #{user.surname}" }
# => John Smith
```

## Contributing

Do not forget to run the tests with:

```bash
bundle exec rake
```

And bump the version with any of:

```bash
$ gem bump --version 1.1.1       # Bump the gem version to the given version number
$ gem bump --version major       # Bump the gem version to the next major level (e.g. 0.0.1 to 1.0.0)
$ gem bump --version minor       # Bump the gem version to the next minor level (e.g. 0.0.1 to 0.1.0)
$ gem bump --version patch       # Bump the gem version to the next patch level (e.g. 0.0.1 to 0.0.2)
```


## License

Released under the MIT License.
See the [LICENSE](LICENSE.txt) file for further details.

