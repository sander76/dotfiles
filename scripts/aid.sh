#!/bin/bash

api_key=$(keyring get claude_api token)

#echo "$api_key"

aider --anthropic-api-key "$api_key" --model claude-4-sonnet-20250514 --watch-files