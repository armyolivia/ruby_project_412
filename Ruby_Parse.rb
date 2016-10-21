# Olivia Thomas
# 21 October 2016
# TCMG 412 - DevOps
# Project 3: Building an App in Ruby
require 'open-uri'

#Configuration
REMOTE_URL = 'http://s3.amazonaws.com/tcmg412-fall2016/http_access_log'
LOCAL_FILE = 'http_access_log.bak'
download = open(REMOTE_URL)
IO.copy_stream(download, LOCAL_FILE)


#Initilizations 
total_requests = 0
status_3xx = 0
status_4xx = 0
listed_files = {}


File.foreach(LOCAL_FILE) do |line|
	#Counts the total number of requests (all of the iterations).
	total_requests += 1
	
	#Breaks up the information we need.
	check = /.*\[(.*) \-[0-9]{4}\] \"([A-Z]+) (.+?)( HTTP.*\"|\") ([2-5]0[0-9]) .*/.match(line)
	
	#If there is an error, it just moves on to the next line.
	if !check then
		next
	end
	
	#The location of the HTTP's in the line.
	http = check[2] 
	#The location of the file names in the line.
	file_names = check[3] 
	#The location of the the status codes in the line array.
	#It is negative one because it is the last item in the array.
	codes = check [-1] 
	
	#If the first digit in the array for codes is a 3 or a 4.
	#It adds it to the total number of times it see it occur.
	if codes[0] == "3" then status_3xx += 1 end
	if codes[0] == "4" then status_4xx += 1 end
	
	#Everytime the program encounters the same file name, it increments by one.
	listed_files[file_names] = (if listed_files[file_names] then listed_files[file_names]+=1 else 1 end)
	
end
#Calculates the percentage of failed and redirected requests, respectfully.
failed_req_4xx = (status_4xx.to_f / total_requests.to_f * 100).truncate
redirected_req_3xx = (status_3xx.to_f / total_requests.to_f * 100).truncate

#Sorts the files from greatest number of occurences to the least.
sorted_files = listed_files.sort_by { |k, v| -v }

title = '      ~Apache Parsing Statistics~'
puts
puts title #.center(10, '*')
#Displays the results.
puts "The Total Number of Requests Made: #{total_requests}"
puts "Percentage of Unsuccessful Requests: #{failed_req_4xx}%"
puts "Percentage of Redirected Requests: #{redirected_req_3xx}%"
puts "The Most-Requested File: #{sorted_files[0][0]}"
puts "The Least-Requested File: #{sorted_files[-1][0]}"
