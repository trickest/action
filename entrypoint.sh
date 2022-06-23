#!/bin/bash

# Setup Environment

set -e

cd $GITHUB_WORKSPACE 

# Variables

space=$INPUT_SPACE
project=$INPUT_PROJECT
workflow=$INPUT_WORKFLOW
workflow_new_name=$INPUT_WORKFLOW_NEW_NAME
watch=$INPUT_WATCH
output_dir=$INPUT_OUTPUT_DIR
output_all=$INPUT_OUTPUT_ALL
show_params=$INPUT_SHOW_PARAMS
create_structure=$INPUT_CREATE_STRUCTURE
output=$INPUT_OUTPUT
config_path=$INPUT_CONFIG_PATH
max_machines=$INPUT_MAX_MACHINES


# Create the structure (create_structure: true)
function create_structure() {
    if [[ $project ]] 
    then
                CREATE_PROJECT="echo \"Y\"| trickest create --space \"$space\" --project \"$project\""
                eval $CREATE_PROJECT
                PROJECT_CMD="--project \"$project\""
                SPACE_CMD="--space \"$space\""
    else
                CREATE_SPACE="echo \"Y\" | trickest create --space \"$space\""
                eval $CREATE_SPACE
                PROJECT_CMD=""
                SPACE_CMD="--space \"$space\""
    fi
}

# If create structure is set, this should create new spaces and projects if they don't exist
if [[ $create_structure ]] 
    then
        create_structure
    else
        if [[ $project ]] 
        then
            PROJECT_CMD="--project \"$project\""
        fi
            SPACE_CMD="--space \"$space\""
fi


# Check if config file exist
function check_config_file_exists() {
    if [ ! -f $1 ]; then
        CONFIG_CMD=""
    else 
        CONFIG_CMD="--config $config_path"
    fi
}

# Check if execution should be watched
function check_watch() {
    if [ $watch ]; then
        WATCH_CMD="--watch"
    else
        WATCH_CMD=""
    fi
}

# Check if --output-all is true
function check_output_all() {
    if [ $output_all ]; then
        OUTPUT_ALL="--output-all"
    else
        OUTPUT_ALL=""
    fi
}


# Set output dir
function check_output_dir() {
    if [ $output_dir ]; then
        mkdir -p $output_dir
        OUTPUT_DIR="--output-dir $output_dir"
    else
        OUTPUT_DIR=""
    fi
}

# Set output nodes
function check_output() {
    if [ $output ]; then
        OUTPUT_NODES="--output $output"
    else
        OUTPUT_NODES=""
    fi
}

# Set show params
function show_params() {
    if [ $show_params ]; then
        SHOW_PARAMS_CMD="--show-params"
    else
        SHOW_PARAMS_CMD=""
    fi
}

# Set max_machines
function max_machines() {
    if [ $max_machines ]; then
        MAX_MACHINES_CMD="--max"
    else
        MAX_MACHINES_CMD=""
    fi
}

# Check if name for the workflow on platform is supplied
function check_workflow() {
    if [[ ! $workflow ]]; then
        echo "Workflow flag missing. You can check out the https://trickest.io/dashboard/store?type=workflows to execute workflow directly from the Store"
        exit 1
    else
        WORKFLOW_CMD="--workflow \"$workflow\""
    fi

}

# Check if new name should be created 
function check_set_name() {
    if [[ $workflow_new_name ]]; then
        WORKFLOW_NAME_CMD="--set-name \"$workflow_new_name\""
    else
        WORKFLOW_NAME_CMD=""
    fi

}

function execute_workflow() {
            # --workflow
            check_workflow
            # --config
            if [[ $config_path ]]
                then 
                    check_config_file_exists $config_path
            fi
            # --watch
            check_watch
            # --output-all
            check_output_all
            # --output-dir
            check_output_dir
            # --output
            check_output
            # --show-params
            show_params
            # --set-name
            check_set_name
            # --show-params
            show_params
            # --max-machines
            max_machines
            # Create Command
            TRICKEST_CMD="trickest execute --ci $PROJECT_CMD $SPACE_CMD $WORKFLOW_CMD $WORKFLOW_NAME_CMD $CONFIG_CMD $WATCH_CMD $OUTPUT_DIR $OUTPUT_ALL $OUTPUT_NODES $SHOW_PARAMS_CMD $MAX_MACHINES_CMD"
            # Print Command
            echo "Command: $TRICKEST_CMD"
            # Execute
            eval $TRICKEST_CMD
}

execute_workflow