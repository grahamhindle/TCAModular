#!/bin/bash

# Usage: ./remove_module.sh <module_name>

if [ -z "$1" ]; then
    echo "Usage: ./remove_module.sh <module_name>"
    exit 1
fi

MODULE_NAME=$1
PROJECT_FILE="Project.swift"

# Remove the module directory if it exists
if [ -d "$MODULE_NAME" ]; then
    echo "Removing directory: $MODULE_NAME"
    rm -rf "$MODULE_NAME"
else
    echo "Directory $MODULE_NAME does not exist. Skipping directory removal."
fi

# Remove the target and test target blocks from Project.swift
awk -v module="$MODULE_NAME" '
    BEGIN { skip=0; }
    {
        if ($0 ~ "Target.target\\(") {
            buffer = $0; getline; buffer = buffer "\n" $0;
            if ($0 ~ "name: \"" module "\"") {
                skip = 1;
                next;
            } else if ($0 ~ "name: \"" module "Tests\"") {
                skip = 1;
                next;
            } else {
                print buffer;
                next;
            }
        }
        if (skip && $0 ~ /^\\s*\\),\\s*$/) {
            skip = 0;
            next;
        }
        if (!skip) print $0;
    }
' "$PROJECT_FILE" > tmp && mv tmp "$PROJECT_FILE"

echo "Removed $MODULE_NAME targets from $PROJECT_FILE."
echo "Done." 