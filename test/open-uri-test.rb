require 'open-uri'
require 'zlib'

#f = open('http://www.accuweather.com/ajax-service/popular-cities?q=york&lid=1', 'Accept-Encoding' => 'gzip')
f = open('data/metoffice-sitelist.json')

if f.meta['content-encoding'].include? 'gzip'
  puts 'decoding'
  puts f.read
  #puts Zlib::GzipReader.new(f).read
end
puts "status #{f.status}"
