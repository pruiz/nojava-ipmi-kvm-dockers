#!/bin/bash -ex

host=$KVM_HOSTNAME
user=root
password=
model=unknown
outfile=$(mktemp)
while :; do
	case "$1" in
	-m)
		shift
		model="$1"
		;;
	-u)
		shift
		user="$1"
		;;
	-p)
		shift
		password="$1"
		;;
	-o)
		shift
		outfile="$1"
		;;
	--)
		shift
		break
		;;
	'')
		break
		;;
	esac
	shift
done

cookies=$(mktemp)

if [ -z "$host" ]
then \
	echo "ERROR: Host not specified" 2>&1
	exit 1
fi

if [ -z "$password" ]
then \
	password=$(cat /dev/stdin | tr -d '\n')
fi

## Try iDRAC7 (or 7-compatible) ones..
[ "$model" == "unknown" ] && curl -s -f -k "https://$host/public/about.html" | grep -q 'Dell Remote Management Controller' && model=DRMC
[ "$model" == "unknown" ] && curl -o /dev/null -s -f -k "https://$host/data/login" && model=iDRAC7

case "$model" in
  iDRAC6-*)
	echo "Trying to log into iDRAC6 w/ user $user..."
	cookie=$(curl \
		--cookie-jar $cookies -s -k \
		--data "WEBVAR_USERNAME=${user}&WEBVAR_PASSWORD=${password}&WEBVAR_ISCMCLOGIN=0" \
		https://${host}/Applications/dellUI/RPC/WEBSES/create.asp \
		| sed -rn '/SESSION_COOKIE/ s/.*SESSION_COOKIE'\'' : '\''([a-zA-Z0-9]+)'\''.*/\1/p' \
	)
	echo "Fetching jnlp file..."
	curl --cookie-jar $cookies --cookie "$cookie" -s -k -o $outfile --cookie "Cookie=SessionCookie=$cookie" "https://${host}/Applications/dellUI/Java/jviewer.jnlp"
	;;
  iDRAC[78])
	echo "Trying to log into iDRAC7+ w/ user $user..."
	ST1=$(curl \
		--cookie-jar $cookies -s -k \
		--data "user=${user}&password=${password}" \
		https://$host/data/login \
		| sed -E 's/.*ST1=([a-z0-9]+),.*/\1/g'
	)
	[[ "$ST1" =~ ^[0-9a-z]+$ ]] || {
		echo "ERROR: Failed to log into bmc" 2>&1
		exit 2
	}
	echo "Fetching jnlp file..."
	curl --cookie-jar $cookies --cookie $cookies -s -k -o $outfile "https://$host/viewer.jnlp($host@0@$host@123@ST1=$ST1)'"
	;;
  DRMC) #< Dell Remote Management Controller (Avocent derivate)
	echo "Trying to log into DMRC w/ user $user..."
	RESULT=$(curl \
		--cookie-jar $cookies -s -k \
		--data "user=${user}&password=${password}" \
		https://$host/data/login \
		| sed -E 's/.*<authResult>([0-9]+)<\/authResult>.*/\1/g'
	)
	[[ "$RESULT" != "0" ]] && {
		echo "ERROR: Failed to log into bmc" 2>&1
		exit 2
	}
	echo "Fetching jnlp file..."
	ST1=$(curl -vv --cookie-jar $cookies --cookie $cookies -s -k "https://$host/index.html"| grep 'var CSRF_TOKEN_1' |sed -r -e 's/.*"([0-9a-z]+)".*/\1/g')
	[[ "$ST1" =~ ^[0-9a-z]+$ ]] || {
		echo "ERROR: Failed to get CSRF TOKEN#1" 2>&1
		sleep 100;
		exit 3
	}
	curl -vv --cookie-jar $cookies --cookie $cookies -s -k -o $outfile "https://$host/viewer.jnlp($host@0@123)?ST1=$ST1"
	;;
  *)
	echo "Can not view $host because of its hardware model '$model'!"
	;;
esac
rm $cookies
#javaws $outfile &
