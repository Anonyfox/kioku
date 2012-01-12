#encoding: utf-8

require './helper'

Shoes.app do
	stack do

		# input line
		flow do
			@in_key = edit_line
			@in_val = edit_line
			@in_go = button("add")
		end

		# elements
		@k = Kioku.new "./sample.yml"
		@k.get_all.each do {|key|
			para "#{key}: #{@k[key]}", size: 9
		}

	end
end