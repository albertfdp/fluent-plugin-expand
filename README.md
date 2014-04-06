# fluent-plugin-expand

fluentd plugin that expands a given input array to multiple emits.

## Usage

Imagine you have a config as below:

	<match test.**>
		type expand

		key foo
		add_tag_prefix		expanded.
		remove_tag_prefix	test.
	</match>

And you feed such a value into fluentd:

	"test" => {
		"meta"=> "data",
		"foo" => [{"bar" => ["hello", "world"]}, {"qux" => ["hoe", "poe"]}]
	}

Then you will get them re-emmited tag/records below:

	"expanded" => {
		"meta" => "data",
		"bar" => ["hello", "world"]
	}

	"expanded" => {
		"meta" => "data",
		"qux" => ["hoe", "poe"]
	}

## Configuration

### key

The `key` is used to point a key whose value contains JSON-formatted array.

### remove_tag_prefix, remove_tag_suffix, add_tag_prefix, add_tag_suffix

These params are included from `Fluent::HandleTagNameMixin`. See that code for details.

You must add at least one of these params.

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-flatten'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-flatten

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
