# Shell Scripting Projects 🐧

A collection of hands-on **Bash shell scripting projects** built while learning Linux, shell scripting, automation, system administration, and AWS/DevOps.

The goal of these projects was to move beyond individual Linux commands and practice combining them into useful scripts and automation tools.

---

## 📑 Table of Contents

* [Projects](#-projects)

  * [Filesystem Status Monitor](#1-filesystem-status-monitor)
  * [RAM Status Monitor](#2-ram-status-monitor)
  * [Linux User Creation Script](#3-linux-user-creation-script)
  * [Automated File Archiver](#4-automated-file-archiver)
  * [AWS CLI Management Tool](#5-aws-cli-management-tool)
  * [AWS Resource Tracker](#6-aws-resource-tracker)
* [Requirements](#️-requirements)
* [Getting Started](#-getting-started)
* [What I Learned](#-what-i-learned)
* [Disclaimer](#-disclaimer)

---

## 📂 Projects

### 1. Filesystem Status Monitor

`fs_status.sh`

Checks filesystem usage and displays a warning when disk utilization reaches the defined threshold.

**Concepts practiced:**

* `df`
* `grep`
* `awk`
* `tr`
* Pipes
* Bash conditionals
* Threshold-based monitoring

**Run:**

```bash
./fs_status.sh
```

---

### 2. RAM Status Monitor

`ram_status.sh`

Checks available RAM and reports whether the available memory is below the configured threshold.

**Concepts practiced:**

* `free`
* `grep`
* `awk`
* Variables
* Conditional statements
* System monitoring

**Run:**

```bash
./ram_status.sh
```

---

### 3. Linux User Creation Script

`create_user.sh`

Automates Linux user creation by:

* Creating a user and home directory
* Adding an optional comment
* Generating a random password
* Assigning the password
* Forcing the user to change their password on first login
* Checking for errors during execution

**Concepts practiced:**

* Command-line arguments
* `useradd`
* `chpasswd`
* `passwd`
* `openssl`
* Exit statuses
* Root-user validation
* Error handling

**Run as root:**

```bash
sudo ./create_user.sh USERNAME "COMMENT"
```

**Example:**

```bash
sudo ./create_user.sh john "DevOps learner"
```

> ⚠️ This script creates actual Linux users on the machine. Use it in a test environment such as a VM or EC2 instance.

---

### 4. Automated File Archiver

`archive_old_large_files.sh`

Finds files that are:

* Larger than **20MB**, or
* Older than **9 days**

The script then:

1. Creates an `archive/` directory if it doesn't exist
2. Finds matching files
3. Compresses them using `gzip`
4. Moves the compressed files into the archive directory

**Run:**

```bash
./archive_old_large_files.sh FILE_PATH
```

**Example:**

```bash
./archive_old_large_files.sh ./demo_files/
```

**Concepts practiced:**

* Command-line arguments
* `find`
* File size filtering
* File age filtering
* `gzip`
* File management
* Loops
* Exit-status checking
* Automation with `cron`

#### Automating with Cron

The script can be scheduled to run automatically.

Example: run every day at midnight:

```cron
0 0 * * * /path/to/archive_old_large_files.sh /path/to/demo_files/
```

---

### 5. AWS CLI Management Tool

`aws_cli_mgmt.sh`

An interactive Bash-based AWS CLI management tool for practicing AWS automation.

#### EC2

* Create instances
* List instances
* Stop instances
* Terminate instances

#### S3

* Create buckets
* List buckets
* Upload files
* Delete buckets

**Concepts practiced:**

* Bash functions
* `while` loops
* `case` statements
* User input
* AWS CLI
* `jq`
* Input validation
* Error handling
* EC2 and S3 automation

> ⚠️ AWS resources created by this script can incur AWS charges. Review the commands and make sure your AWS credentials, region, AMI, key pair, and permissions are configured correctly before using it.

---

### 6. AWS Resource Tracker

`aws_resource_tracker.sh`

A Bash script that uses the **AWS CLI** to collect information about commonly used AWS resources and save the results to a local `resourceTracker` file.

The script currently tracks:

* **S3 buckets**
* **EC2 instances**
* **AWS Lambda functions**
* **IAM users**

The collected resource information is written to `resourceTracker`, making it easy to review the AWS resources currently associated with the configured AWS account.

#### How It Works

**S3:**

```bash
aws s3 ls
```

Lists the S3 buckets in the account.

**EC2:**

```bash
aws ec2 describe-instances
```

Uses `jq` to extract EC2 instance IDs.

**Lambda:**

```bash
aws lambda list-functions
```

Uses `jq` to extract Lambda function ARNs.

**IAM:**

```bash
aws iam list-users
```

Uses `jq` to extract IAM user ARNs.

**Output:**

The results are stored in:

```text
resourceTracker
```

The file is overwritten when the script starts and updated as additional AWS resources are collected.

**Run:**

```bash
./aws_resource_tracker.sh
```

**View the generated report:**

```bash
cat resourceTracker
```

**Concepts practiced:**

* Bash scripting
* AWS CLI
* AWS resource management
* `jq`
* JSON parsing
* Output redirection
* File handling
* Append (`>>`) and overwrite (`>`)
* AWS EC2
* AWS S3
* AWS Lambda
* AWS IAM

> ⚠️ The script requires AWS credentials with permission to query the resources being tracked. Make sure your AWS CLI is configured before running it.

---

## 🛠️ Requirements

### Basic Scripts

* Linux / WSL / EC2
* Bash

### `create_user.sh`

* Root/sudo access
* `openssl`

### AWS Scripts

`aws_cli_mgmt.sh` and `aws_resource_tracker.sh` require:

* AWS CLI
* `jq`
* Configured AWS credentials
* Appropriate AWS IAM permissions

Check AWS CLI:

```bash
aws --version
```

Check `jq`:

```bash
jq --version
```

Check AWS credentials:

```bash
aws sts get-caller-identity
```

---

## 🚀 Getting Started

Clone the repository:

```bash
git clone https://github.com/aryan-aroraa/shell-scripting-projects.git
cd shell-scripting-projects
```

Make the scripts executable:

```bash
chmod +x *.sh
```

Then run whichever project you want to explore.

Example:

```bash
./fs_status.sh
```

For the AWS Resource Tracker:

```bash
./aws_resource_tracker.sh
```

Then view the generated resource report:

```bash
cat resourceTracker
```

---

## 🎯 What I Learned

Through these projects, I practiced:

* Bash scripting fundamentals
* Linux system administration
* Command-line arguments
* Variables and quoting
* Conditionals and loops
* Functions
* Pipes and command chaining
* Exit statuses and error handling
* File management and compression
* Linux user management
* Cron job automation
* AWS CLI automation
* AWS resource management
* JSON processing with `jq`
* Output redirection and file handling
* Working with EC2, S3, Lambda, and IAM

These projects were built as hands-on practice while learning **Linux, Bash, automation, cloud, and DevOps concepts**.

---

## 📌 Disclaimer

These are **learning projects**, not production-ready tools.

Review scripts before running them, especially scripts that create/delete users or modify AWS resources.

AWS resources may incur charges depending on how they are created or managed. Always verify the commands, AWS account, region, and IAM permissions before running AWS automation scripts.
