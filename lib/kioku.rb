#encoding: utf-8

require 'yaml'
#require 'profile'

class Kioku

	# opens up a database file and loads the content, 
	# or creates one first if it doesn't exist yet
	def initialize filepath, serialization_type='yaml'
		@filepath = filepath
		@serialization_type = serialization_type
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

	# remove all datasets from the database
	def clear
		@data_base = {}
		update_database
	end

	# deletes the current database file and locks the database-object
	# so it can't be used anymore
	def destroy
		File.delete @filepath
		@data_base = nil
		@data_base.freeze
		self.freeze
	end

	# returns all keys which are actually in the database
	def all
		@data_base.keys.dup || []
	end

	# returns all keys in the database that matches the given pattern-string
	def search pattern
		results = all.map {|key|
			key if key.to_s =~ /#{pattern}/i
		}
		results.delete nil
		results
	end

	# ask the database if exactly this key is already used in it.
	def include? key
		@data_base.has_key? key
	end

private

	def init_database
		#self.send("init_database_#{@serialization_type}")
		init_database_yaml
	end

	def update_database
		#self.send("update_database_#{@serialization_type}")
		update_database_yaml
	end

	#############################################
	### other serialization formats
	#############################################

	def init_database_yaml
		if File.exists? @filepath
			f = File.open @filepath, 'r'
			@data_base = YAML.load_file @filepath
			f.close
		else
			f = File.new @filepath, 'wb'
			f.close
		end
		@data_base ||= {}
	end

	def update_database_yaml
		f = File.new @filepath, 'w'
		f << @data_base.to_yaml
		f.close
	end

	def init_database_marshal
		f = File.open @filepath, 'rb'
		@data_base = Marshal.load f.read
		f.close
	end

	def update_database_marshal
		f = File.new @filepath, 'wb'
		f << Marshal.dump(@data_base)
		f.close
	end

end