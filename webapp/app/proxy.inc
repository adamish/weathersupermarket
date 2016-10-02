<?php

header('Content-type: application/json');

// only using PHP for CGI performance on dreamhost
class Router {
  var $dest;
  function Router($dest) {
     $this->dest = $dest;
  }
  function run() {
        $ch = curl_init(); 

		$encoding = $_SERVER['HTTP_ACCEPT_ENCODING'];
		if (strlen($encoding) > 1) {
			curl_setopt($ch, CURLOPT_HTTPHEADER, array('Accept-Encoding: gzip'));
		}
		$url = $this->dest . str_replace(" ", "%20", $_REQUEST['data']);
		//echo $url;
        curl_setopt($ch, CURLOPT_URL, $url); 

		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_HEADER, 1);        
		curl_setopt($ch, CURLOPT_BINARYTRANSFER, 1);        
        curl_setopt($ch, CURLOPT_TIMEOUT_MS, 45000); 
		
		
        $output = curl_exec($ch); 
        	
        if ($output === FALSE) {
        	http_response_code(500);
        	echo '{"error": true}';
        } else {
        	$header_len = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
			$header = substr($output, 0, $header_len);
			if (preg_match("/Content-Encoding:(.*)/m", $header, $m)) {
				header("Content-Encoding: " . $m[1]);
			}
			$body = substr($output, $header_len);
        	echo $body;
       	}
        curl_close($ch); 
  }
}
?>
