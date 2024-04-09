#!/bin/bash

JENKINS_URL="http://15.206.117.160:8970/"
USERNAME="YadavEerla"
PASSWORD="Desvops@123"

JENKINS_CLI_JAR="jenkins-cli.jar"

check_jenkins_version() {
    echo "Jenkins Version:"
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" version
}

list_all_jobs() {
    echo "List of all Jenkins jobs:"
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" list-jobs
}

create_view() {
    local VIEW_NAME="$1"
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" create-view "$VIEW_NAME"
    echo "Jenkins view '$VIEW_NAME' created successfully."
}

delete_view() {
    local VIEW_NAME="$1"
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" delete-view "$VIEW_NAME"
    echo "Jenkins view '$VIEW_NAME' deleted successfully."
}

create_user() {
    local NEW_USERNAME="$1"
    local USER_CONFIG_FILE="$2"
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" createUser "$NEW_USERNAME" < "$USER_CONFIG_FILE"
    echo "User '$NEW_USERNAME' created successfully."
}

delete_user() {
    local USER_TO_DELETE="$1"
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" delete-user "$USER_TO_DELETE"
    echo "User '$USER_TO_DELETE' deleted successfully."
}

create_single_job() {
    local JOB_NAME="$1"
    local JOB_CONFIG_FILE="$2"
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" create-job "$JOB_NAME" < "$JOB_CONFIG_FILE"
    echo "Jenkins job '$JOB_NAME' created successfully."
}

create_multiple_jobs() {
    local JOBS_CONFIG_DIR="$1"
    for JOB_CONFIG_FILE in "$JOBS_CONFIG_DIR"/*.xml; do
        local JOB_NAME=$(basename "$JOB_CONFIG_FILE" .xml)
        create_single_job "$JOB_NAME" "$JOB_CONFIG_FILE"
    done
}

delete_single_job() {
    local JOB_NAME="$1"
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" delete-job "$JOB_NAME"
    echo "Jenkins job '$JOB_NAME' deleted successfully."
}

delete_multiple_jobs() {
    local JOBS_TO_DELETE="$@"
    for JOB_NAME in "${JOBS_TO_DELETE[@]}"; do
        delete_single_job "$JOB_NAME"
    done
}

trigger_single_job() {
    local JOB_NAME="$1"
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" build "$JOB_NAME"
    echo "Build triggered for Jenkins job: $JOB_NAME"
}

trigger_multiple_jobs() {
    local JOBS_TO_TRIGGER="$@"
    for JOB_NAME in "${JOBS_TO_TRIGGER[@]}"; do
        trigger_single_job "$JOB_NAME"
    done
}

display_installed_plugins() {
    echo "List of all installed Jenkins plugins:"
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" list-plugins
}

restart_jenkins() {
    echo "Restarting Jenkins..."
    java -jar "$JENKINS_CLI_JAR" -s "$JENKINS_URL" -auth "$USERNAME:$PASSWORD" safe-restart
}

display_menu() {
    echo "Choose an option:"
    echo "1. Check Jenkins Version"
    echo "2. List All Jobs"
    echo "3. Create View"
    echo "4. Delete View"
    echo "5. Create User"
    echo "6. Delete User"
    echo "7. Create Single Job"
    echo "8. Create Multiple Jobs"
    echo "9. Delete Single Job"
    echo "10. Delete Multiple Jobs"
    echo "11. Trigger Single Job"
    echo "12. Trigger Multiple Jobs"
    echo "13. Display Installed Plugins"
    echo "14. Restart Jenkins"
    echo "0. Exit"

    read -p "Enter your choice: " choice
}

# Main script logic
while true; do
    display_menu

    case $choice in
        1) check_jenkins_version;;
        2) list_all_jobs;;
        3) read -p "Enter view name: " view_name
           create_view "$view_name";;
        4) read -p "Enter view name to delete: " view_name_to_delete
           delete_view "$view_name_to_delete";;
        5) read -p "Enter new user name: " new_username
           read -p "Enter user config file path: " user_config_file
           create_user "$new_username" "$user_config_file";;
        6) read -p "Enter username to delete: " user_to_delete
           delete_user "$user_to_delete";;
        7) read -p "Enter job name: " job_name
           read -p "Enter job config file path: " job_config_file
           create_single_job "$job_name" "$job_config_file";;
        8) read -p "Enter jobs config directory path: " jobs_config_dir
           create_multiple_jobs "$jobs_config_dir";;
        9) read -p "Enter job name to delete: " job_name_to_delete
           delete_single_job "$job_name_to_delete";;
        10) read -p "Enter jobs to delete (separated by space): " jobs_to_delete
            delete_multiple_jobs $jobs_to_delete;;
        11) read -p "Enter job name to trigger: " job_name_to_trigger
            trigger_single_job "$job_name_to_trigger";;
        12) read -p "Enter jobs to trigger (separated by space): " jobs_to_trigger
            trigger_multiple_jobs $jobs_to_trigger;;
        13) display_installed_plugins;;
        14) restart_jenkins;;
        0) echo "Exiting..."; exit;;
        *) echo "Invalid choice";;
    esac

    read -p "Press enter to continue..."
    clear
    exit
done
