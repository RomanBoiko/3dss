#!/bin/bash

echo "#########STARTING###########"
erl -config app -s inets 
#-mnesia dir '"./db"' -s db
#-noshell
