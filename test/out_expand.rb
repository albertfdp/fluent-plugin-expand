require 'fluent/test'
require 'fluent/plugin/out_expand'

require 'test/unit'

class ExpandOutputTest < Test::Unit::TestCase

	def setup
		Fluent::Test.setup
	end

	CONFIG = %[
		type 				expand
		tag 				foo.bar

		add_tag_prefix 		expanded.
		remove_tag_prefix 	test.

		key 				results
	]

	def create_driver(conf = CONFIG)
		Fluent::Test::OutputTestDriver.new(Fluent::ExpandOutput, tag='test').configure(conf)
	end

	def test_configure
		d = create_driver

		assert_equal 'results', d.instance.key
		assert_equal 'expanded.', d.instance.add_tag_prefix
		assert_equal /^test\./, d.instance.remove_tag_prefix

	end

	def test_expand
		d = create_driver

		expanded = d.instance.expand({'meta' => 'some', 'results' => [{'a' => ['1', '2']}, {'b' => ['3', '4']}]})

		expected = [
			{'meta'=>'some', 'results'=>{'a'=>['1', '2']}},
			{'meta'=>'some', 'results'=>{'b'=>['3', '4']}}
		]

		assert_equal(expected, expanded)

		# when no 'key' is not present
		expanded = d.instance.expand({'meta' => 'some'})
		expected = []

		assert_equal expected, expanded

	end

	def test_emit

		# default config
		d = create_driver

		d.run do
			d.emit({'meta' => 'some', 'results' => [{'a' => ['1', '2']}, {'b' => ['3', '4']}]})
		end

		emits = d.emits

		assert_equal 2, emits.count

	 	# when no 'key' is present
	 	d2 = create_driver

	 	d2.run do
	 		d2.emit({'meta' => 'some'})
	 	end

	 	emits = d2.emits

	 	assert_equal 0, emits.count

	end

end
