#####
# checking version of jenkins
# listing all jobs
# create view
# delete view
# create user
# delete user
# create single job
# create multiple job
# delete single job
# delete multiple job
# trigger single job
# trigger multiple jobs
# desplay all installed plugins
# jenkins restart
!/bin/bash

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

check_jenkins_version
list_all_jobs
# create_view "example"
# delete_view "example-view"
# create_user "new-user" "user_config.xml"
# delete_user "new-user"
# create_single_job "example-job" "job_config.xml"
# create_multiple_jobs "jobs_config_directory"
# delete_single_job "example-job"
# delete_multiple_jobs "job1" "job2" "job3"
# trigger_single_job "example-job"
# trigger_multiple_jobs "job1" "job2" "job3"
# display_installed_plugins
# restart_jenkins
