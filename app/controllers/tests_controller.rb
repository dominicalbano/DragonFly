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
			if (@test.choose_test == "JS Console Errors")
				# get links
				get_cms = CMSpages.new
				get_cms.method(@test.app_name)
				@allurl = get_cms.pass
				# run job
				run_crawler = JSconsoleErrors.new
				run_crawler.method(@allurl)
				@json_data = run_crawler.pass
				@test.update_attribute(:json, @json_data)
			elsif (@test.choose_test == "Status Codes")
				# get links
				get_cms = CMSpages.new
				get_cms.method(@test.app_name)
				@allurl = get_cms.pass
				# run job
				run_crawler = StatusCodes.new
				run_crawler.method(@allurl)
				@json_data = run_crawler.pass
				@test.update_attribute(:json, @json_data)
			end	
		end

		if (@test.app_type == "CLW")
			if (@test.choose_test == "JS Console Errors")
				# get links
				get_sitemap = GatherSitemap.new
				get_sitemap.method(@test.app_name)
				@allurl = get_sitemap.pass
				# run job
				run_crawler = JSconsoleErrors.new
				run_crawler.method(@allurl)
				@json_data = run_crawler.pass
				@test.update_attribute(:json, @json_data)
			elsif (@test.choose_test == "Status Codes")
				# get links
				get_sitemap = GatherSitemap.new
				get_sitemap.method(@test.app_name)
				@allurl = get_sitemap.pass
				# run job
				run_crawler = StatusCodes.new
				run_crawler.method(@allurl)
				@json_data = run_crawler.pass
				@test.update_attribute(:json, @json_data)
			end	
		end
		redirect_to @test
	end

	def show
		@test = Test.find(params[:id])
	end

	private
	def test_params
		params.require(:test).permit(:app_type, :app_name, :choose_test)
	end
end

## class to gather a clw's sitemap
class GatherSitemap
	def method(app_name)
		# # INITIATE VARS # #
		@@all_url = [] 
		if (app_name[-1, 1] == "/")
			app = app_name[0...-1]
		else
			app = app_name
		end
		driver = Selenium::WebDriver.for :firefox 
		driver.get "#{app}/sitemap.xml"

		sleep(1)

		url_tags = driver.find_elements(:tag_name => "url")
		url_tags.each do |inside|
			url = inside.find_element(:tag_name => "loc")
			url_string = url.attribute("innerHTML")
			url_string_array = url_string.split("/")
			domain = url_string_array[2]

			rebuild = app
			counter = 0

			url_string_array.each do |piece|
				if (counter > 2)
					rebuild = "#{rebuild}/#{piece}"
				end
				counter = counter + 1
			end
			@@all_url.push(rebuild)
		end
		driver.quit
	end
	def pass
		return @@all_url
	end
end

class CMSpages
	def method(app_name)
		# # INITIATE VARS # #
		@@all_url = []
		if (app_name[-1, 1] == "/")
			root = app_name[0...-1]
		else
			root = app_name
		end
		# # push relavent urls to array # #
		@@all_url.push(root)
		@@all_url.push("#{root}/saves")

		# # CRAWL CMS FOR URLS # #
		driver = Selenium::WebDriver.for :firefox 
		driver.get root
		# authenticate
		if (driver.title == "G5 Auth")
			email = driver.find_element(:id, "user_email")
			email.send_keys ("dominic.albano@getg5.com")
			pass = driver.find_element(:id, "user_password")
			pass.send_keys ("OmGiGaJ!")
			sub = driver.find_element(:name, "button")
			sub.submit
			driver.get root
		end
		sleep(5)
		# need to find how many sites we got
		sites = driver.find_element(:class,"faux-table-body")
		li = sites.find_elements(:tag_name, "li")
		count_li = 0
		li.each do |add|
			count_li = count_li + 1
		end

		# we need an array that just holds site urls
		@@all_sites = []
		# Add site urls and function urls to array
		for i in 1..count_li
			site_root = driver.find_element(:xpath, "//li[#{i}]/div[3]/a")
			site_root_url = site_root.attribute("href")
			@@all_url.push(site_root_url)
			@@all_url.push("#{site_root_url}/assets")
			@@all_url.push("#{site_root_url}/redirects")
			@@all_url.push("#{site_root_url}/releases")
			@@all_url.push("#{site_root_url}/docs")

			@@all_sites.push(site_root_url)
		end

		# Navigate to page urls per site url and add to array
		for j in 0..(count_li - 1)
			driver.get @@all_sites[j]
			sleep(10)

			cards = driver.find_element(:class,"cards")
			card = cards.find_elements(:class,"card")
			card_count = 0
			card.each do |add|
				card_count = card_count + 1
			end

		 	for k in 1..(card_count - 1)
		 		page = driver.find_element(:xpath,"//div[#{k}]/div/div/div[2]/div[3]/a")
		 		page_url = page.attribute("href")
		 		@@all_url.push(page_url)
		 	end
		end
		driver.quit
	end

	def pass
		return @@all_url
	end
end

class ClientSites
	def method
		# # INITIATE VARS # #
		@@all_url = []
		@var_holder = Vars.new
		root = @var_holder.cms

		# # CRAWL CMS FOR CLW URLS # #
		driver = Selenium::WebDriver.for :firefox 
		driver.get root
		# authenticate
		if (driver.title == "G5 Auth")
			email = driver.find_element(:id, "user_email")
			email.send_keys ("dominic.albano@getg5.com")
			pass = driver.find_element(:id, "user_password")
			pass.send_keys ("OmGiGaJ!")
			sub = driver.find_element(:name, "button")
			sub.submit
			driver.get root
		end
		sleep(5)
		# need to find how many sites we got
		sites = driver.find_element(:class,"faux-table-body")
		li = sites.find_elements(:tag_name, "li")
		count_li = 0
		li.each do |add|
			count_li = count_li + 1
		end
		# Add clw urls to array
		for i in 1..count_li
			site_root = driver.find_element(:xpath, "//li[#{i}]/div[3]/a[2]")
			site_root_url = site_root.attribute("href")
			@@all_url.push(site_root_url)
			puts site_root_url
		end
		driver.quit
	end

	def pass
		return @@all_url
	end
end


## This section of the modules file is for executing functions on gathered urls ##
##################################################################################

class JSconsoleErrors
	def method(urls)
		#first we need the sitemap
		@allurl = urls
		@json_array = '{"errors":['

		profile = Selenium::WebDriver::Firefox::Profile.new
		profile.add_extension File.join(Rails.root, "driver/assets/JSErrorCollector.xpi")
		                
		browser = Watir::Browser.new :firefox, :profile => profile

		page_counter = 1

		@allurl.each do |page|

			browser.goto page
			# authenticate
			if (browser.title == "G5 Auth")
				browser.text_field(:id, "user_email").set("dominic.albano@getg5.com")
				browser.text_field(:id, "user_password").set("OmGiGaJ!")
				browser.button(:name, "button").click
			end
			sleep(2)

			errors = browser.execute_script("return window.JSErrorCollector_errors.pump()")
			             
			if errors.any?

				error_counter = 1
				@json_array.concat('{"id":"')
				page_counter_s = page_counter.to_s
				@json_array.concat(page_counter_s)
				@json_array.concat('",')
				@json_array.concat('"page":"')
				@json_array.concat(page)
				@json_array.concat('",')
				@json_array.concat('"page_errors":[')

				errors.each do |error|
					@json_array.concat('{"message":"')
					@json_array.concat(error["errorMessage"])
					@json_array.concat('",')

					@json_array.concat('"file":"')
					@json_array.concat(error["sourceName"])
					@json_array.concat('",')

					@json_array.concat('"line":"')
					line_string = error["lineNumber"].to_s
					@json_array.concat(line_string)
					@json_array.concat('"}')					
					if (errors.length != error_counter)
						@json_array.concat(',')
					else
						@json_array.concat(']')
					end
					error_counter = error_counter + 1
				end
			else
				@json_array.concat('{"id":"')
				page_counter_s = page_counter.to_s
				@json_array.concat(page_counter_s)
				@json_array.concat('",')
				@json_array.concat('"page":"')
				@json_array.concat(page)
				@json_array.concat('",')
				@json_array.concat('"page_errors":[]')
			end
			
			@json_array.concat('}') 
			if (@allurl.length != page_counter)
				@json_array.concat(',')
			end
			page_counter = page_counter + 1

		end
		@json_array.concat(']}')
		browser.quit
	end

	def pass
		return @json_array
	end
end


class StatusCodes
	def method (urls)
		@allurl = urls

		@json_array = '{"status":['
		page_counter = 1

		@allurl.each do |page|
			uri = URI(page)
			res = Net::HTTP.get_response(uri)

			@json_array.concat('{"id":"')
			page_counter_s = page_counter.to_s
			@json_array.concat(page_counter_s)
			@json_array.concat('",')
			@json_array.concat('"page":"')
			@json_array.concat(page)
			@json_array.concat('",')
			@json_array.concat('"code":"')
			@json_array.concat(res.code)
			@json_array.concat('"}')
			if (@allurl.length != page_counter)
				@json_array.concat(',')
			end

			page_counter = page_counter + 1
		end
		@json_array.concat(']}')
	end

	def pass
		return @json_array
	end
end











