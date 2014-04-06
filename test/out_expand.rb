require 'fluent/test'
require 'fluent/plugin/out_expand'

require 'test/unit'

class ExpandOutputTest < Test::Unit::TestCase

	def setup
		Fluent::Test.setup
	end

	CONFIG = %[
		type expand
		tag foo.bar

		add_tag_prefix expanded.
		remove_tag_prefix test_tag.

		key results
	]

	def create_driver(conf = CONFIG)
		Fluent::Test::OutputTestDriver.new(Fluent::ExpandOutput, tag='test_tag').configure(conf)
	end

	def test_configure
		d = create_driver
		map = d.instance.instance_variable_get(:@map)
	end

	def test_expand
		d = create_driver

		expanded = d.instance.expand({'meta' => 'some', 'results' => [{'a' => ['1', '2']}, {'b' => ['3', '4']}]})

		expected = [
								{'meta'=>'some', 'results'=>{'a'=>['1', '2']}},
								{'meta'=>'some', 'results'=>{'b'=>['3', '4']}}
		]

		assert_equal(expected, expanded)

	end

	def test_emit

		# default config
		d = create_driver

		d.run do
				d.emit({'meta' => 'some', 'results' => [{'a' => ['1', '2']}, {'b' => ['3', '4']}]})
		end

		emits = d.emits

		emits.each do |tag, time, record|
			puts "#{tag}, #{time}, #{record} \n"
		end

		assert_equal 2, emits.count

	end

end
