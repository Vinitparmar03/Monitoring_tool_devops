#!/bin/bash
pwd

cd script
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'


echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════╗"
echo "║          LINUX MONITORING DASHBOARD                 ║"
echo "╚══════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "${CYAN}Date:${NC} $(date)"
echo -e "${CYAN}Hostname:${NC} $(hostname)"
echo ""

for i in "." ".." "..."
do
    echo -ne "\rChecking$i"
    sleep 0.1
done
echo

if [[ ! -f prev_user.txt ]]
then 
	echo "creating the prev_user.txt file for all user data..."
	touch prev_user.txt
	cut -d: -f1,3,4 /etc/passwd > prev_user.txt
fi


if [[ ! -f prev_group.txt ]]
then 
	echo -e "\n\ncreating the prev_group.txt file for all group data..."
	touch prev_group.txt
	cut -d: -f1,3 /etc/group > prev_group.txt
fi

touch data.txt
> data.txt


echo "USER MACHINES CRITICAL DATA" >> data.txt



echo -e "\n${CYAN}════════ CPU MONITORING ════════${NC}"

total_cpu_usage=$( top -bn1 | awk -F',' 'NR==3 {print $4}' | awk -F ' ' '{print 100 - $1}' ) 

if [[ ${total_cpu_usage%.*} -ge 80 ]]
then 
	echo -e "${RED}[CRITICAL]${NC} CPU Usage : $total_cpu_usage%"
	echo -e "\n--------------CPU MONITORING DATA----------------" >> data.txt
	echo "cpu usage: $total_cpu_usage" >> data.txt
else
	echo -e "${GREEN}[OK]${NC} CPU Usage : $total_cpu_usage%"
fi	



echo -e "\n\n${CYAN}════════ MEMORY MONITORING ════════${NC}"

overall_memory=$( free | awk -F" " 'NR==2 {print $2,$3}' )

total_memory=$( echo "$overall_memory" | awk -F" " '{print $1}' )

used_memory=$( echo "$overall_memory" | awk -F" " '{print $2}' )

memory_percentage_used=$(( used_memory * 100 / total_memory ))

if [[ $memory_percentage_used -ge 80 ]]
then	
	echo -e "${RED}[WARNING]${NC} RAM Usage : $memory_percentage_used%"
	echo -e "\n--------------MEMORY(RAM) MONITORING DATA----------------" >> data.txt
	echo "ram usage: $memory_percentage_used" >> data.txt
else
    	echo -e "${GREEN}[OK]${NC} RAM Usage : $memory_percentage_used%"
fi



echo -e "\n\n${CYAN}════════ DISK MONITORING ════════${NC}"

disk_ussage=$( df | awk -F" " 'NR==3 {print $5}' )

if [[ ${disk_ussage%\%} -ge 80 ]]
then 
	echo -e "${RED}[WARNING]${NC} Disk Usage : $disk_ussage"
	echo -e "\n--------------DISK MONITORING DATA----------------" >> data.txt
	echo "disk usage: $disk_ussage" >> data.txt
else
    	echo -e "${GREEN}[OK]${NC} Disk Usage : $disk_ussage"
fi



echo -e "\n\n${CYAN}════════ LOAD MONITORING ════════${NC}"

cores=$(nproc)
load_average=$( uptime | awk -F"load average:" '{print $2}' | awk '{print $1}' )

if [[ ${load_average%.*} -gt $cores ]]
then
       	echo -e "${RED}[WARNING]${NC} Load Average: ${load_average%,}"	
	echo -e "\n--------------LOAD MONITORING DATA----------------" >> data.txt
	echo "Load Average Warning: ${load_average%,}" >> data.txt
else	
    	echo -e "${GREEN}[OK]${NC} Load Average : ${load_average%,}"
fi





echo -e "\n\n${CYAN}════════ USER MONITORING ════════${NC}"

echo -e "Monitoring User is added or not..."

touch curr_user.txt

cut -d: -f1,3,4 /etc/passwd > curr_user.txt

user_added=$(diff prev_user.txt curr_user.txt | grep '^>' | cut -c3-)

if [[ -n "$user_added" ]]
then
	echo -e "${YELLOW}[INFO]${NC} Added Users: \n$user_added"
	
	echo -e "\n--------------USER MONITORING DATA----------------" >> data.txt
	echo -e "\n--------------USER ADDED DATA----------------" >> data.txt
    	while IFS=: read -r user_name user_id group_id
    	do
        	echo -e "username: $user_name\nuser_id: $user_id\ngroup_id: $group_id\n" >> data.txt
    	done <<< "$user_added"

    	cp curr_user.txt prev_user.txt

else
	echo -e "${GREEN}[OK]${NC} No users added"
fi

rm curr_user.txt



echo -e "\nMontioring that user is delete or not..."

touch curr_user.txt

cut -d: -f1,3,4 /etc/passwd > curr_user.txt

user_deleted=$(diff prev_user.txt curr_user.txt | grep '^<' | sed 's/^< //')

if [[ -n "$user_deleted" ]]
then
	echo -e "${YELLOW}[INFO]${NC} Deleted Users:\n$user_deleted"

	echo -e "\n--------------USER DELETED DATA----------------" >> data.txt
    	while IFS=: read -r user_name user_id group_id
    	do
        	echo -e "username: $user_name\nuser_id: $user_id\ngroup_id: $group_id\n" >> data.txt
    	done <<< "$user_deleted"

    	cp curr_user.txt prev_user.txt

else
	echo -e "${GREEN}[OK]${NC} No users deleted"
fi

rm curr_user.txt


echo -e "\n\n${CYAN}════════ GROUP MONITORING ════════${NC}"

echo -e "Monitoring the new group is added or not..."

touch curr_group.txt

cut -d: -f1,3 /etc/group > curr_group.txt

group_added=$(diff prev_group.txt curr_group.txt | grep "^>" | cut -c3-)

if [[ -n "$group_added" ]]
then
	echo -e "${YELLOW}[INFO]${NC} Added Group:\n$group_added "

	echo -e "\n--------------Group MONITORING DATA----------------" >> data.txt
	echo -e "\n--------------Group Added Data----------------" >> data.txt
	while IFS=: read -r group_name group_id
	do
		echo -e "group_id: $group_id\ngroup_name: $group_name" >> data.txt
	done <<< $group_added 

	cp curr_group.txt prev_group.txt
else
	echo -e "${GREEN}[OK]${NC} No Group added"
fi

rm curr_group.txt


echo -e "\nMonitoring the group is deleted or not..."

touch curr_group.txt

cut -d: -f1,3 /etc/group > curr_group.txt

group_deleted=$(diff prev_group.txt curr_group.txt | grep "^<" | sed "s/^< //")

if [[ -n "$group_deleted" ]]
then
	echo -e "${YELLOW}[INFO]${NC} Deleted Groups:\n$group_deleted"

	echo -e "\n--------------Group Deleted Data----------------" >> data.txt
	while IFS=: read -r group_name group_id
	do
		echo -e "group_id: $group_id\ngroup_name: $group_name" >> data.txt
	done <<< $group_deleted 

	cp curr_group.txt prev_group.txt
else
	echo -e "${GREEN}[OK]${NC} No Group Deleted"
fi

rm curr_group.txt



echo -e "\n\n${CYAN}════════ SSH MONITORING ════════${NC}"
echo "Monitoring SSH service is running..."

ssh_status=$(systemctl is-active ssh)

if [[ $ssh_status != "active" ]]
then
	echo -e "\n--------------SSH MONITORING DATA----------------" >> data.txt
	echo -e "${RED}[CRITICAL]${NC} SSH Service Stopped"
	echo "Current Status: $ssh_status"
	echo "SSH service stopped - Status: $ssh_status" >> data.txt
else
	echo -e "${GREEN}[OK]${NC} SSH Service Running"
fi
    


echo -e "\n\n${CYAN}====== SSH ATTACK ANALYSIS ======${NC}"

threshold=10
attack_found=false

while read -r count ip
do
    if [ "$count" -ge "$threshold" ]
    then
        attack_found=true

        echo -e "${RED}[CRITICAL]${NC} SSH Brute Force Detected!"
        echo "Attacker IP: $ip"
        echo "Attempts in Last 10 Minutes: $count"

        echo "$(date '+%Y-%m-%d %H:%M:%S') | SSH Brute Force | $ip | Attempts: $count" >> data.txt

    fi
done < <(
    journalctl --since "10 minutes ago" --no-pager |
    grep -E "Failed password|Invalid user|authentication failure|Connection closed by authenticating user|Disconnected from authenticating user" |
    grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' |
    sort |
    uniq -c
)

if ! journalctl --since "10 minutes ago" --no-pager |
grep -Eq "Failed password|Invalid user|authentication failure|Connection closed by authenticating user|Disconnected from authenticating user"
then
    echo -e "${GREEN}[OK]${NC} No SSH attack activity detected in the last 10 minutes."
elif [ "$attack_found" = false ]
then
    echo -e "${YELLOW}[INFO]${NC} SSH login attempts detected, but below threshold ($threshold)."
fi




echo -e "\n\n${CYAN}════════ PORT MONITORING ════════${NC}"

if [[ -f allowed_ports.txt ]]
then
    	listening_ports=$(netstat -tulpn | grep LISTEN | awk '{print $4}' | rev | cut -d':' -f1 | rev | sort -u)

    	not_allowed_ports=$(comm -23 \
        	<(echo "$listening_ports") \
        	<(sort -u allowed_ports.txt))

    	if [[ -n "$not_allowed_ports" ]]
    	then	
		echo -e "\n--------------PORT MONITORING DATA----------------" >> data.txt
		echo -e "${RED}[Warning]${NC} Unauthorized Ports Detected:\n$not_allowed_ports"
        	echo -e "Unauthorized listening ports detected: \n$not_allowed_ports" >> data.txt
    else
	    echo -e "${GREEN}[OK]${NC} No unauthorized ports are listening"
    fi
fi


current_time=$(date "+%Y-%m-%d %H:%M:%S")
host_name=$(hostname)

if [[ -z "$user_added" ]]
then
    users_added_json="[]"
else
    users_added_json=$(printf '%s\n' "$user_added" | awk -F':' '
    BEGIN { printf "[" }
    NF {
        if(count++) printf ","
        printf "\"%s\"", $1
    }
    END { printf "]" }
    ')
fi

# Users Deleted
if [[ -z "$user_deleted" ]]
then
    users_deleted_json="[]"
else
    users_deleted_json=$(printf '%s\n' "$user_deleted" | awk -F':' '
    BEGIN { printf "[" }
    NF {
        if(count++) printf ","
        printf "\"%s\"", $1
    }
    END { printf "]" }
    ')
fi

# Groups Added
if [[ -z "$group_added" ]]
then
    groups_added_json="[]"
else
    groups_added_json=$(printf '%s\n' "$group_added" | awk -F':' '
    BEGIN { printf "[" }
    NF {
        if(count++) printf ","
        printf "\"%s\"", $1
    }
    END { printf "]" }
    ')
fi

# Groups Deleted
if [[ -z "$group_deleted" ]]
then
    groups_deleted_json="[]"
else
    groups_deleted_json=$(printf '%s\n' "$group_deleted" | awk -F':' '
    BEGIN { printf "[" }
    NF {
        if(count++) printf ","
        printf "\"%s\"", $1
    }
    END { printf "]" }
    ')
fi

# Unauthorized Ports
if [[ -z "$not_allowed_ports" ]]
then
    unauthorized_ports_json="[]"
else
    unauthorized_ports_json=$(printf '%s\n' "$not_allowed_ports" | awk '
    BEGIN { printf "[" }
    NF {
        if(count++) printf ","
        printf "%s", $1
    }
    END { printf "]" }
    ')
fi

failed_attempts=${failed_attempts:-0}
ssh_status=${ssh_status:-unknown}


cat > system_data.json << EOF
{
    	"timestamp": "$current_time",
    	"hostname": "$host_name",

    	"system_metrics": {
        	"cpu_usage_percent": "$total_cpu_usage",
        	"memory_usage_percent": "$memory_percentage_used",
        	"disk_usage_percent": "${disk_ussage%\%}",
        	"load_average": "${load_average%,}",
        	"cpu_cores": "$cores"
    	},

    	"ssh_monitoring": {
        	"status": "$ssh_status",
        	"failed_attempts": "$failed_attempts"
    	},

    	"user_monitoring": {
    		"users_added": $users_added_json,
    		"users_deleted": $users_deleted_json
	},

    	"group_monitoring": {
    		"groups_added": $groups_added_json,
    		"groups_deleted": $groups_deleted_json
	},

    	"port_monitoring": {
        	"unauthorized_ports": $unauthorized_ports_json
    	}
}
EOF
