class Clwjobs
	@queue = :CLW
	def self.perform(test)
	  	if (test["choose_test"] == "JS Console Errors")
			# get links
			get_sitemap = GatherSitemap.new
			get_sitemap.method(test["app_name"])
			@allurl = get_sitemap.pass
			# run job
			run_crawler = JSconsoleErrors.new
			run_crawler.method(@allurl)
			@json_data = run_crawler.pass
			test["json"] = @json_data
			passvar = UpdateJsonColumn.new
			passvar.conn(test)
		elsif (test["choose_test"] == "Status Codes")
			# get links
			get_sitemap = GatherSitemap.new
			get_sitemap.method(test["app_name"])
			@allurl = get_sitemap.pass
			# run job
			run_crawler = StatusCodes.new
			run_crawler.method(@allurl)
			@json_data = run_crawler.pass
			test["json"] = @json_data
			passvar = UpdateJsonColumn.new
			passvar.conn(test)
		end	
	end
end

class UpdateJsonColumn
	def conn(test)
		json = Test.find_by(id: test["id"])
		json.update(json: test["json"])
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


## This section of the modules file is for executing functions on gathered urls ##
##################################################################################

class JSconsoleErrors
	def method(urls)
		#first we need the sitemap
		@allurl = urls
		@json_array = '{"errors":['

		profile = Selenium::WebDriver::Firefox::Profile.new
		profile.add_extension File.join(Rails.root, "app/assets/javascripts/JSErrorCollector.xpi")
		                
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