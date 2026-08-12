#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# checking if aws-cli package available
if ! aws --version &> /dev/null;
then
	# checking if unzip dependency is installed
	which unzip &> /dev/null
	if [ $? -ne 0 ];
	then 
		echo "Install 'unzip' first"
		exit 1
	fi

	echo "Install 'aws-cli' first"
	exit 1
fi


# checking if user is aws configured
if ! aws sts get-caller-identity &> /dev/null;
then
    echo -e "${YELLOW}AWS credentials are not configured or are invalid. Please validate with 'aws configure'${RESET}"
    exit 1
fi


menu(){
	while true
	do
		clear
		echo "************"
		echo "1. EC2"
		echo "2. S3"
		echo "3. Exit"
		echo "************"
		read -p "Enter choice: " choice

		case "$choice" in
			1) ec2_menu;;
			2) s3_menu;;
			3) 
				echo "Goodbye!"
				exit 0
				;;
			*) 
				echo -e "${RED}Invalid input!${RESET}"
				press_enter
				;;
		esac
	done
}

press_enter(){
	read -p "Press ENTER to continue..."
}
ec2_menu(){
	while true
	do
		clear
		echo "============EC2============"
		echo "1. Create EC2 instance"
		echo "2. List EC2 instances"
		echo "3. Stop EC2 instance"
		echo "4. Delete EC2 instance"
		echo "5. Back"
		echo "==========================="
		read -p "Enter choice: " choice

		case "$choice" in
			1) create_ec2;;
			2) list_ec2;;
			3) stop_delete_ec2 "stop";;
			4) stop_delete_ec2 "terminate";;
			5) break;;
			*) 
				echo -e "${RED}Invalid input!${RESET}"
				press_enter
				;;
		esac
	done

}
create_ec2(){
	echo "----------------------"
	read -p "Enter instance type: " ec2_type
	result=$(aws ec2 run-instances --image-id "ami-0b6d9d3d33ba97d99" --instance-type "$ec2_type" --key-name "EC2 Tutorial" 2> /dev/null)
	if [ $? -ne 0 ];
	then
		echo -e "${RED}Invalid instance type${RESET}"
	else
		ec2_id=$(echo "$result" | jq ".Instances[].InstanceId")
		echo -e "${GREEN}Successfully created Instance ID ${ec2_id}${RESET}" 	
	fi
	press_enter

}
list_ec2(){
	aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | "Instance ID: \(.InstanceId)\nStatus: \(.State.Name)\n--------------------------"'	
	press_enter
}
stop_delete_ec2(){
	echo "----------------------"
	read -p "Enter Instance ID: " ec2_id
	read -p "Are you sure? (y/n): " sure
	case $sure in
		y) 
			if ! aws ec2 $1-instances --instance-ids "$ec2_id" &> /dev/null;
			then
				echo -e "${RED}Invalid instance ID \"${ec2_id}\"${RESET}"
			else
				[ "$1" == "stop" ] && echo -e "${GREEN}Successfully stopped instance ID \"${ec2_id}\"${RESET}" || echo -e "${GREEN}Successfully terminated instance ID \"${ec2_id}\"${RESET}"
			fi
			;;
		n) return;;
		*) 
			echo -e "${RED}Invalid Input${RESET}"
			return;;
	esac
	press_enter

}



s3_menu(){
	while true
	do
		clear
		echo "========S3========="
		echo "1. Create bucket"
		echo "2. List buckets"
		echo "3. Upload file"
		echo "4. Delete bucket"
		echo "5. Back"
		echo "==================="
		read -p "Enter choice: " choice

		case "$choice" in
			1) create_s3;;
			2) list_s3;;
			3) upload_file_s3;;
			4) delete_s3;;
			5) break;;
			*) 
				echo -e "${RED}Invalid input!${RESET}"
				press_enter
				;;
		esac
	done
}

create_s3(){
	echo "----------------------"
	read -p "Enter bucket name: " s3_name  
	s3_name="s3://${s3_name,,}"

	error=$(aws s3 mb $s3_name 2>&1)
	if [ $? -eq 0 ];
	then
		echo -e "${GREEN}Bucket created successfully!${RESET}"
	else
		if echo "$error" | grep -q "InvalidBucketName";
		then
			echo -e "${RED}Invalid Bucket Name!${RESET}"
		elif echo "$error" | grep -q "BucketAlreadyExists"
		then
			echo -e "${YELLOW}Bucket already exists!${RESET}"
		else
			echo "Something went wrong"
		fi
	fi
	press_enter
}
list_s3(){
	echo "----------------------------------------------------"
	aws s3 ls
	echo "----------------------------------------------------"
	press_enter	
}
upload_file_s3(){
 	BASE="/home/ubuntu"
	echo "-----------------------------------------------"
	read -p "Enter file path (Relative to /home/ubuntu): " filepath
	filepath="${BASE}/${filepath}"
	if [ ! -f $filepath ];
	then
		echo -e "${YELLOW}Provided path doesn't exist.${RESET}"
		press_enter
		return
	fi

	read -p "Enter bucket name: " s3_name
	s3_name="s3://${s3_name}"

	if ! aws s3 cp "$filepath" "$s3_name" --quiet;
	then
		echo -e "${YELLOW}The specified bucket does not exist${RESET}"
	else
		echo -e "${GREEN}File uploaded successfully!${RESET}"
	fi
	press_enter
}
delete_s3(){
	echo "----------------------"
	read -p "Enter bucket name: " s3_name 
	read -p "Are you sure? (y/n): " sure
	case $sure in
		y)
			
			s3_name="s3://${s3_name}"
		
			error=$(aws s3 rb $s3_name 2>&1)

			if [ $? -eq 0 ];
			then
				echo -e "${GREEN}Bucket deleted successfully!${RESET}"
			else
				if echo "$error" | grep -q "NoSuchBucket";
				then
					echo -e "${YELLOW}The specified bucket does not exist${RESET}"				
				elif echo "$error" | grep -q "BucketNotEmpty"
				then
					echo -e "${YELLOW}The bucket you tried to delete is not empty${RESET}"
				fi
			fi
			;;
		n) return;;
		*) 
			echo -e "${RED}Invalid Input${RESET}"
			return;;
	esac
	press_enter
}
menu

