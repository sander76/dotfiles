#!/bin/bash

api_key=$(keyring get claude_api token)

#echo "$api_key"

aider --anthropic-api-key "$api_key" --model anthropic/claude-opus-4-5 --watch-files
