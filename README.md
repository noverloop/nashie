# Nashie

Nashie takes the Hashie concept one step further and allows you to create nested structure with buildin validation logic.

Nashies are used in the wild as presenters for API responses and to validate incoming API calls.

## Installation

Add this line to your application's Gemfile:

    gem 'nashie'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nashie

## Usage

    class Part < Hashie::Nash
       property :name, :required => true
    end

    class Engine < Hashie::Nash
      property :build_year, :required => true
      property :nitro, :default => false
      property :parts, :collection => true, :class => "Part"
    end

    class Car < Hashie::Nash
      property :engine, :required => true, :class => Engine
    end

    car = Car.new "engine" => {"build_year" => 2010, "nitro" => false, :parts => [{"name" => "crankshaft"}, {"name" => "flywheel"}]}
## Overrides

Overriding the initialization method allows you to inject some custom logic if needed.

    class Motorcycle
      def initialize hash
        raise "Euhm, a motorcycle has 2 wheels you know..." if not hash[:wheels].eql? 2
        super hash
      end
    end

## DSL

A DSL is provided for inline declaration.

    class Presentation < Hashie::Nash
      property :users, :collection => true, :required => true do
         property :name
      end
    end

## Future work

- more types of validations
- Customizable error messages

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
