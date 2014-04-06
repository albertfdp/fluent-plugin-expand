require 'json'

module Fluent

	class ExpandOutput < Output

		include Fluent::HandleTagNameMixin

		Fluent::Plugin.register_output('expand', self)

		config_param :key,	:string

		def configure(conf)
			super

			if (
				!add_tag_prefix &&
				!remove_tag_prefix
				)
				raise ConfigError, "out_expand: At least one of add_tag_prefix/remove_tag_prefix is required."
			end
		end

		def emit(tag, es, chain)

			es.each do |time, record|
				expanded = expand(record)

				expanded.each do |item|
					tag_rewritted = tag.clone
					filter_record(tag_rewritted, time, item)
					Engine.emit(tag_rewritted, time, item)
				end

			end

			chain.next

		end

		def expand(record)
			expanded = []

			if record.has_key?(key) && !record[key].empty?
				array = nil # array of records for a particular user
				array = record[key]

				processor = lambda do |root, array|

					expanded = []
					return expanded unless array.is_a?(Array) # filter the key

					array.each do |item|
						modified = record.clone
						modified[key] = item
						expanded << modified
					end

					expanded

				end

				expanded = processor.call(key, array)

			end

			expanded

		end


	end

end
