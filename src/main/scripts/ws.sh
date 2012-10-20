#!/bin/bash

#erl -compile rest
erlc -Wall rest.erl
echo "#########STARTING###########"
erl -config app -s inets 
#-mnesia dir '"./db"' -s db
#-noshell
