#!/bin/bash
: "${AWS_PROFILE:?You must set AWS_PROFILE in your environment}"
aws-vault exec "$AWS_PROFILE" -- terraform -chdir=infra "$@"
