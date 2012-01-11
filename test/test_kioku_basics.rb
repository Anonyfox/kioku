#encoding: utf-8

require_relative 'helper'

class TestKiokuBasics < Test::Unit::TestCase

	def setup
		@k = Kioku.new "sample.yml"
	end

  def test_general_working_and_syntax
  	@k.clear
  	@k["entry"] = "a sample"
  	assert_equal( "a sample", @k["entry"] )
  	@k.delete "entry"
  	assert_equal( nil, @k["entry"] )
  end

  def test_general_serialization
  	@k["entry"] = "This!"
  	tmp = Kioku.new "sample.yml"
  	assert_equal( @k["entry"], tmp["entry"] )
  	tmp.destroy
  end

  def test_umlauts
  	@k["höhö"] = "süß"
  	assert_equal( @k["höhö"], "süß" )
  end

  def test_object_data
  	@k["obj"] = [1,2,4]
  	assert_equal( @k["obj"], [1,2,4] )
  end

  def test_binary_data
  	f = File.open("bindata.bz2","rb").read
  	@k["bin"] = f.dup
  	tmp = Kioku.new "sample.yml"
  	assert_equal( tmp.exists?("bin"), true)
  	assert_equal( tmp["bin"], @k["bin"] )
  end
end
