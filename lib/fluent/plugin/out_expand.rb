require 'json'

module Fluent

	class ExpandOutput < Output

		include Fluent::HandleTagNameMixin

		Fluent::Plugin.register_output('expand', self)

		config_param :key,	:string
		config_param :reemit_doc, :bool, :default => false

		def configure(conf)
			super

			if conf.has_key?('reemit_doc')
				@reemit_doc = true
			end

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

					if item.has_key?(key)
						tag_rewritted = tag.clone
						filter_record(tag_rewritted, time, item)
						Engine.emit(tag_rewritted, time, item)
					elsif @reemit_doc
						Engine.emit(tag, time, item)
					end

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

					# add one without the key
					modified = record.clone
					modified.delete(key)
					expanded << modified

					expanded

				end

				expanded = processor.call(key, array)

			end

			expanded

		end


	end

end
