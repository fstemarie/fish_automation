#! /usr/bin/fish
set domains falarie pegleg
set token d05499d5-3208-4b85-8bf2-be3ebbdc3ec2

echo "


-------------------------------------
 "(date -Ins)" 
-------------------------------------
" | tee -a $log

for domain in $domains
	set fulldomain $domain.duckdns.org
	set refresh_url "https://www.duckdns.org/update?domains=$domain&token=$token"
	set response (curl -s -k -o - -- $refresh_url)

	echo $refresh_url
	echo $response 
	if test "$response" = "OK"
		logger -t duckdns.fish "Domain $fulldomain was successfully refreshed"
		echo "duckdns.fish -- Domain $fulldomain was successfully refreshed" | tee -a $log
	else if test "$response" = "KO"
		logger -t duckdns.fish "There was an error while attempting to refresh $fulldomain"
		echo "duckdns.fish -- There was an error while attempting to refresh $fulldomain" | tee -a $log
	else
		logger -t duckdns.fish "Something weird happened while attempting to refresh $fulldomain"
		echo "duckdns.fish -- Something weird happened while attempting to refresh $fulldomain" | tee -a $log
	end
end
