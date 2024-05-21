#!/bin/bash

git submodule update --recursive --remote

git submodule foreach git checkout main

git submodule foreach git pull origin main
