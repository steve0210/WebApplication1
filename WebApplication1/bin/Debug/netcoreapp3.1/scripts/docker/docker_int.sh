#!/usr/bin/env bash

SERVICE=svc
docker-compose run -p 5000:5000 $SERVICE bash
