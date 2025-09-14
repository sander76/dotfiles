#!/bin/bash

#AI! this script accepts two arguments: source and target.
# source points to a folder or file
# target points to the symlink target to be created.
#
# implement the following:
# if source not exists (can be a folder or file), exit with an error message.
# if target does not exist, create a symlink from source to target.
# if target exists, check if it is a symlink pointing to source. If so, exit with a non-error code.
# if target exists but does not point to the symlink, ask the user whether to create it:
# if user says No (N), then exit, without doing anything
# if user says Yes (Y), delete the older target and create a symlink from source to target. 