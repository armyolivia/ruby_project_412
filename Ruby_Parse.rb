require 'open-uri'

#Configuration
REMOTE_URL = 'http://s3.amazonaws.com/tcmg412-fall2016/http_access_log'
LOCAL_FILE = 'http_access_log.bak'
download = open(REMOTE_URL)
IO.copy_stream(download, LOCAL_FILE)

#LOCAL_FILE = 'short_parse.rtf'
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