class Vars
	def initialize
		@clw = "http://g5-clw-6jvlo05-corp.herokuapp.com"
		@app = "g5-cms-1tbo672w-qa-test-beds"
		# generate from there
		@cms = "https://#{@app}.herokuapp.com"
	end

	def clw
		@clw
	end

	def cms
		@cms
	end
end
