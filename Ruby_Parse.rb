require 'open-uri'

Configuration
REMOTE_URL = 'http://s3.amazonaws.com/tcmg412-fall2016/http_access_log'
LOCAL_FILE = 'http_access_log.bak'
download = open(REMOTE_URL)
IO.copy_stream(download, LOCAL_FILE)
