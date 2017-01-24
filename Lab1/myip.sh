#!/bin/bash
#My lab 1.5
wget -qO- whatismypublicip.com | grep \"up_finished | cut -d">" -f 2