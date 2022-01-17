#!/bin/bash -xe

cp hooks/pre-push .git/hooks/pre-push
chmod 700 .git/hooks/pre-push
