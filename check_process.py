#!/usr/bin/env python

# Command:      check_service.py
# Description:  Get the pid of service running
# Author:       Rohit Kumar
# Project:      https://gitlab.one.com/commititup/Assignment

import sys
import subprocess
import time
import multiprocessing as mp
import json
from argparse import ArgumentParser

CONFIG_FILE = "server_config.json"

# Read args 
def get_args():    
    global CONFIG_FILE
    parser = ArgumentParser(prog='check_process',usage='%(prog)s --file <config file path> ')
    parser.add_argument('-f','--file',help='Config file path' ,default=CONFIG_FILE,type=str)
    args = parser.parse_args()
    try:
        if args.file:
                CONFIG_FILE = args.file
    except ValueError:
        print("Incorrect format of arguments")
        sys.exit(1)

# Read config file 
def get_config():
    global CONFIG_FILE
    try:
        with open(CONFIG_FILE,'r') as config:
            data = json.load(config)
            server_list= data['server']
            timeout = data['timeout']
            process_search = data['process_name']
            return [server_list,timeout,process_search]
    except KeyError :
        print("config file is incorrect in {0}".format(CONFIG_FILE))
        sys.exit(1)
    except OSError :
        print("config file not found {0}".format(CONFIG_FILE))    
        sys.exit(1)
        
# Perform ssh on server
def ssh_to_server(*args):
        global TIMEOUT
        command_name = args[0][0]
        Hostname = args[0][1]
        timer_end = time.time() + 60 * TIMEOUT
        while time.time() < timer_end:
            cmd = "ssh -n  " +str(Hostname) + " \ " + "'" +str(command_name) + "'" # ADDED ''TO PREVENT COMMAND SPLIT
            result = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE,universal_newlines=True)
            stdout,stderr = result.communicate()
            if stderr:
                print("some error encountered while running command on {0}".format(Hostname))
                stdout=stderr
                break
            if stdout is "":
                continue
            else:
                return Hostname,stdout
        if stdout is "":
            return Hostname,"No pid Found"

# Define main function
def main():
    global TIMEOUT

    get_args()
    server_list,TIMEOUT,process_search = get_config()
    
    command_name = "pgrep -f {0}".format(process_search)
    command = []
    for _ in server_list:
        command.append(command_name)
        
    pool = mp.Pool(processes=len(server_list)) #
    result= pool.map_async(ssh_to_server,zip(command,server_list)).get(9999)
    pool.terminate()

    for rs in result:
        print (rs[0])
        print ("======================")
        print (rs[1])
    
# Calling main function
if __name__ == '__main__':
    main()

