# require spec helper cuz it has gems and env setup required to run tests
require_relative  '../../spec/spec_helper.rb' 

class TestsController < ApplicationController
	def index
		@tests = Test.order(created_at: :desc)
	end

	def new
	end

	def create
		@test = Test.new(test_params)
		@test.save

		if (@test.app_type == "CMS")
			Resque.enqueue(Cmsjobs, @test)
			redirect_to @test
		end

		if (@test.app_type == "CLW")
			Resque.enqueue(Clwjobs, @test)
			redirect_to @test
		end
	end

	def show
		@test = Test.find(params[:id])
	end

	private
	def test_params
		params.require(:test).permit(:app_type, :app_name, :choose_test)
	end
end











