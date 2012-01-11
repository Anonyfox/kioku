#encoding: utf-8

require 'yaml'
require 'profile'

class Kioku

	# opens up a database file and loads the content, 
	# or creates one first if it doesn't exist yet
	def initialize filepath
		@filepath = filepath
		@data_base = {}
		init_database
	end

	# add any new content to the database, identified by the given key. 
	# returns false if the key is already existing.
	def set key, data
		@data_base[ key ] = data
		update_database
	end

	# a shorthand method for the set method
	def []=(key, data)
		set key, data
	end

	# return the data corresponding to the given key. 
	def get key
		@data_base[ key ]
	end

	# a shorthand method for the get method
	def [](key)
		get key
	end

	# delete the key and all associated data 
	def delete key
		data = @data_base.delete key
		update_database
		data
	end

	def clear
		@data_base = {}
		update_database
	end

	def destroy
		File.delete @filepath
		self.freeze
	end

	def exists? key
		@data_base.has_key? key
	end

	def keys
		@data_base.keys
		#puts @data_base.values
	end

private

	def init_database
		if File.exists? @filepath
			f = File.open @filepath, 'r'
			@data_base = YAML.load_file @filepath
			f.close

			#f = File.open @filepath, 'rb'
			#@data_base = Marshal.load f.read
			#f.close
		else
			f = File.new @filepath, 'wb'
			f.close
		end
	end

	def update_database
		f = File.new @filepath, 'w'
		f << @data_base.to_yaml
		f.close

		#f = File.new @filepath, 'wb'
		#f << Marshal.dump(@data_base)
		#f.close
	end

end