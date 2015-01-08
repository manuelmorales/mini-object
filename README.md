# MiniObject

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


## Contributing

Do not forget to run the tests with:

```bash
rake
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

