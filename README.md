# Qmin

Enables your application to handle method calls in the background without the need to write a worker for every task.


## Assumptions

You can transparently call methods on instances that adhere to some assumptions Qmin makes about your code:

* Classes (i.e. ActiveRecord Models) have a #find class method that takes an ID as an argument and instantiates an instance of that class.
* Instances of that class have a public #id method that returns a value which can be used by the #find class method to instantiate that instance.


## Installation

Add this line to your application's Gemfile:

    gem 'qmin'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qmin

## Usage

### Qmin::Strategy

Currently these strategies are implemented:

* Noop (does nothing)
* Inline (calls the method inline, helpful for testing or development)
* Resque (moves the work off to the resque queue)

## Todo

* better documentation :)
* Qmin::Strategy::DelayedJob
* Qmin::Strategy::Sidekiq

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
