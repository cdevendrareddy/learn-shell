#!/bin/bash

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
usage_threshold=80  # Set the usage threshold to 80%
server_ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)  # Get the server's local IP address
message="<table role=\"presentation\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\" width=\"100%\" style=\"border-collapse:collapse; font-size:14px; text-align:left;\">
<thead><tr style=\"background-color:#eff6ff; color:#1e3a8a;\">
<th style=\"padding:12px; border-bottom:1px solid #bfdbfe;\">Mount point</th>
<th style=\"padding:12px; border-bottom:1px solid #bfdbfe;\">Filesystem</th>
<th style=\"padding:12px; border-bottom:1px solid #bfdbfe; text-align:right;\">Usage</th>
</tr></thead><tbody>"

html_escape() {
    local value=$1
    value=${value//&/\&amp;}
    value=${value//</\&lt;}
    value=${value//>/\&gt;}
    value=${value//\"/\&quot;}
    value=${value//\'/\&apos;}
    printf '%s' "$value"
}

has_alert=false
while read -r filesystem type size used available usage partition; do
    usage=${usage%\%}
    [[ $usage =~ ^[0-9]+$ ]] || continue
    if (( usage >= usage_threshold )); then
        has_alert=true
        partition=$(html_escape "$partition")
        type=$(html_escape "$type")
        message+="<tr>
<td style=\"padding:12px; border-bottom:1px solid #e2e8f0;\">$partition</td>
<td style=\"padding:12px; border-bottom:1px solid #e2e8f0;\">$type</td>
<td style=\"padding:12px; border-bottom:1px solid #e2e8f0; color:#b91c1c; font-weight:bold; text-align:right;\">${usage}%</td>
</tr>"
    fi
done < <(df -hT)

if [[ $has_alert != true ]]; then
    echo "No filesystems are at or above ${usage_threshold}% usage; no alert email sent."
    exit 0
fi

message+="</tbody></table>
<p style=\"margin:16px 0 0; color:#64748b; font-size:13px;\">Usage threshold: ${usage_threshold}%</p>"

bash "$script_dir/mail.sh" "Devops Team" "$server_ip" "High Disk Usage Alert" "$message" "cheenepallidevendrareddy@gmail.com" "WARNING: High Disk Usage Alert"

