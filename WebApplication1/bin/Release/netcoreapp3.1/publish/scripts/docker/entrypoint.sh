#!/bin/sh

SERVICE=svc
DIR=/var/www/$SERVICE/current

su - rails -c "cd $DIR && PGPASSFILE=~/.pgpass ASPNETCORE_ENVIRONMENT=Production dotnet WebApplication1.dll"