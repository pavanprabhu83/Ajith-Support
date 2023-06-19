#!/bin/bash

echo 'project-name,roles/rolename,user:username-and-serviceaccounts' > iamlist.csv
echo "Collecting IAM roles & users for Project: <project_name>"
echo $(gcloud projects get-iam-policy <project-name> --format="table(bindings)[0]" | sed -e 's/^\w*\ *//'|tail -c +2 |python python-format.py <project-name> >> iamlist.csv)
