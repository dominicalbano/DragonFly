#require spec helper cuz it has gems and env setup required to run int tests
require_relative  '../spec/spec_helper.rb'  

profile = Selenium::WebDriver::Firefox::Profile.new
profile.add_extension File.join(Rails.root, "/JSErrorCollector.xpi")
                
browser = Watir::Browser.new :firefox, :profile => profile
browser.goto 'http://g5-clw-6jvlo05-corp.herokuapp.com/'
 
errors = browser.execute_script("return window.JSErrorCollector_errors.pump()")
             
if errors.any?
	puts "-------------------------------------------------------------"
	puts "Found #{errors.length} javascript error(s)"
	puts "-------------------------------------------------------------"

	counter = 1
 
	errors.each do |error|
		puts "[error #{counter}]" 
		puts "message: #{error["errorMessage"]}"
		puts "file: #{error["sourceName"]}" 
		puts "line: #{error["lineNumber"]}" 
		puts " "
		counter = counter + 1
	end

else
	puts "-------------------------------------------------------------"
	puts "Found No Errors"	
	puts "-------------------------------------------------------------"
end

browser.quit
