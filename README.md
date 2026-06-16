## Project Description
This project uses a shell script to autimate school student attendance. 
This projects need directory structure, copies files that are needed or shared with us by our structor. Also, when u run the code it allows threshold configuration, checks for Python installation. Finally, it requires signal specifically CTRL+C interruptions safely.

Steps of on how to run my code: 

Step 1:
clone my repo on your terminal.
by doing this git clone <https://github.com/hahmed2-crypto/deploy_agent_hahmed2-crypto.git> 
Step 2: 
cd to deploy_agent_hahmed2-crypto directory/folder
chmod +x setup_project.sh
Step 3: 
./setup_project.sh file

After running ./setup_project.sh file, it should script files which starts with attendance_tracker_{your input}. In this file, the script will create attendance_checker.py, Helpers, and Reports directories. In Helpers, it will create assets.csv and config.json. In Reports directroy/folder, it will create reports.log 
Step 4:
input or type version control you want and the program will be running.


How to trigger Archive: 
Step 1: 
run this ./setup_project.sh 
Stept 2: 
input the v2 or anything you want to name the directory.
Step 3: 
Do ctrl + C as the program is running. 
That will trigger the Archive. 
Finally, the script will create a file named attendance_tracker_(input)_archive.tar.gz and removes the incomplete project directroy.

Python Health Check

Before completing setup, the script runs:

python3 --version

If Python 3 is installed, a success message is displayed.
Otherwise, a warning message is shown.

Configuration

The script prompts the user to enter Warning and Failure attendance thresholds.
The values are updated in config.json using the sed command.
