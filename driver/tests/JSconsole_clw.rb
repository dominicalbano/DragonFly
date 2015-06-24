# require spec helper cuz it has gems and env setup required to run tests
require_relative  '../../spec/spec_helper.rb'  
# get vars
require "#{Rails.root}/driver/modules/modules"

get_sitemap = GatherSitemap.new
get_sitemap.method
@allurl = get_sitemap.pass

# get_cms = CMSpages.new
# get_cms.method
# @allurl = get_cms.pass

run_crawler = JSconsoleErrors.new
run_crawler.method(@allurl)

