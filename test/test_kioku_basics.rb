#encoding: utf-8

require_relative 'helper'

class TestKiokuBasics < Test::Unit::TestCase

	def setup
		require 'pp'
	end

  def test_general_working_and_syntax
  	@k = Kioku.new "sample.yml"
  	@k["entry"] = "a sample"
  	assert_equal( "a sample", @k["entry"] )
  	@k.delete "entry"
  	assert_equal( nil, @k["entry"] )
  end

  def test_general_serialization
  	@k = Kioku.new "sample.yml"
  	@k["entry"] = "This!"
  	assert_equal( @k["entry"], "This!" )
  end

  def test_umlauts
  	@k = Kioku.new "sample.yml"
  	@k["höhö"] = "süß"
  	assert_equal( @k["höhö"], "süß" )
  end

  def test_object_data
  	@k = Kioku.new "sample.yml"
  	@k["obj"] = [1,2,4]
  	assert_equal( @k["obj"], [1,2,4] )
  end

  def test_binary_data
  	@k = Kioku.new "sample.yml"
  	f = File.open("bindata.bz2","rb").read
  	@k["bin"] = f.dup
  	assert_equal( @k["bin"], f )
  end

  def test_all
  	@k = Kioku.new "sample.yml"
  	@k["entry"] = "a sample"
  	@k["höhö"] = "süß"
  	@k["obj"] = [1,2,4]
  	assert_equal( @k.all.sort, ["entry","höhö","obj","bin"].sort)
  	#pp @k
  end

  def test_search
  	@k = Kioku.new "sample.yml"
  	assert_equal( @k.search("obj"), ["obj"] )
  	assert_equal( @k.search("bin"), ["bin"] )
  	assert_equal( @k.search("höhö"), ["höhö"])
  end
end
