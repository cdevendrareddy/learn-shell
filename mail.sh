#!/bin/bash

team_name=$1
server_ip=$2
alert_type=$3
message=$4
to_address=$5
subject=$6
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

if ! command -v msmtp >/dev/null 2>&1; then
    echo "mail.sh: msmtp is required to send email but was not found in PATH." >&2
    exit 127
fi

if [[ ! -r "$script_dir/template.html" ]]; then
    echo "mail.sh: cannot read email template at $script_dir/template.html." >&2
    exit 1
fi

html_escape() {
    local value=$1
    value=${value//&/\&amp;}
    value=${value//</\&lt;}
    value=${value//>/\&gt;}
    value=${value//\"/\&quot;}
    value=${value//\'/\&apos;}
    printf '%s' "$value"
}

replace_placeholder() {
    local text=$1
    local placeholder=$2
    local replacement=$3
    local result=''
    local prefix

    while [[ $text == *"$placeholder"* ]]; do
        prefix=${text%%"$placeholder"*}
        result+=$prefix$replacement
        text=${text#*"$placeholder"}
    done
    printf '%s%s' "$result" "$text"
}

template=$(<"$script_dir/template.html")
template=$(replace_placeholder "$template" TO_TEAM "$(html_escape "$team_name")")
template=$(replace_placeholder "$template" ALERT_TYPE "$(html_escape "$alert_type")")
template=$(replace_placeholder "$template" SERVER_IP "$(html_escape "$server_ip")")
template=$(replace_placeholder "$template" MESSAGE_BODY "$message")

{
echo "To: $to_address"
echo "Subject: $subject"
echo "MIME-Version: 1.0"
echo "Content-Type: text/html; charset=UTF-8"
echo ""
printf '%s\n' "$template"
} | msmtp "$to_address"
