#!/bin/bash
#bash assignment 

function mysystem ()
{
    echo ""
    echo "My system name is: $(hostname -s)"
    return 0
}
function mydomain ()
{
    echo ""
    if [ -z $(hostname -d) ];
    then
    echo "This machine has no Domain"
    else
    echo "The Domain name for this machine is $(hostname -d)"
    fi
    return 0
    
}
function ipaddress ()
{
    echo "" 
    if [ -n $(dpkg-query -l | grep ii | awk '{print  $2}' | grep net-tools) ]
    then
    echo "The IP address of my machine is $(ifconfig | grep "inet addr" | head -n1 | cut -d: -f2 | cut -d" " -f1)"
    return 0
    else
    echo "To run this command system must have net-tools installed" >&2
    exit 0
    fi
}
function osversion ()
{
    echo ""
    if [ -n $(ls /etc/os-release ) ]
    then
    echo "This is my OS version $(cat /etc/os-release | grep "VERSION_ID"| cut -d\" -f2)"
    return 0
    else
    echo "To run this command system must have /etc/os-release file" >&2
    exit 0
    fi
}
function osname ()
{
    echo ""
    if [ -n $(ls /etc/os-release ) ]
    then
    echo "The name of operating system of this computer is $(cat /etc/os-release | grep "NAME" | head -n1 | cut -d\" -f2)"
    return 0
    else
    echo "To run this command system must have /etc/os-release file" >&2
    exit 0
    fi
    
}
function cpuinfo ()
{
    echo ""
    echo "This is the model name of my CPU $(cat /proc/cpuinfo | grep "model name" | head -n1 | cut -d: -f2 | cut -d " " -f2-6)"
    echo "This CPU has $(lscpu | grep "^CPU(s):" | awk '{print $2}') cores"
    echo "This CPU can operate $(lscpu | grep "CPU op-mode(s):" | awk '{print $3,$4}') modes"
    return 0
}
function memory ()
{
    echo ""
    echo "This machine has $(free -h |grep "Mem" | awk '{print $2}') of memory installed"
    return 0
}
function diskspaceavailable ()
{
    echo ""
    disk=($(df -Th | grep "^/" | awk '{print $5}'))
    diskname=($(df -Th | grep "^/" | awk '{print $1}'))
    for (( i=0; i < ${#disk[*]}; i++ ))
    {
        echo "The Available disk space on disk ${diskname[$i]} is ${disk[$i]}"
    }
    return 0
}
function printers ()
{
    echo ""
    #Check if cups are installed
    if [ -z $(dpkg-query -l | grep ii | awk '{print  $2}' | grep "^cups" | sort -n |head -1) ]
    then
        echo "cups are not installed" >&2
    else
        service cups status > /dev/null 2>&1
        if [ $? -eq 3 ]
        then
            echo "cups are not running" >&2
            echo "Please start cups to run this command" >&2
        else
            lpstat -a > /dev/null 2>&1
            if [ $? -eq 0 ]
            then
                echo "List of the Available Printers"
                echo "------------------------------"
                lpstat -a | awk '{print $1}'
            else
                echo "This machine has no Printers"
            fi
        fi
    fi
    return 0
}
function softwaresinstalled ()
{
    #check if the script is running in a Linux based debian distribution.
    if [ $(cat /etc/os-release | grep ID_LIKE | cut -d= -f2) != "debian" ]
    then
        echo ""
        echo "This option can just run in a Debian based distribution.">&2
        exit 1
    else
        echo ''
        echo "Name of the Version" | awk '{printf "%-50s %-80s\n", $1, $2}'
        echo "=========================================================="
        dpkg-query -l | grep ii | awk '{printf "%-50s %-80s\n", $2, $3}' | more
        return 0
    fi
    
}
function error ()
{
    params=0
    while [ $params -lt ${#arg[@]} ]
    do 
        case ${arg[$params]} in
    
            -sys)         mysystem
            ;;
            
            -dn)          mydomain
            ;;
            
            -ip)          ipaddress
            ;;
            
            -osv)         osversion
            ;;
            
            -osn)         osname
            ;;
            
            -cpu)         cpuinfo
            ;;
            
            -mem)         memory
            ;;
            
            -ds)          diskspaceavailable
            ;;
            
            -lp)          printers
            ;;
            
            -soft)        softwaresinstalled
            ;;
            
            -help|--h)    help
            ;;
            
            *)              echo "$0: invalid ${arg[$params]}" >&2
                            echo "Try $0 -help or --h"
            ;;
        
    esac
    params=$((params+1))
done
    return 0
}
function help ()
{
    echo ""
    echo "                              HELP                                    "
    echo "======================================================================"
    echo "warning: this script is only compatible with debian system"
    echo "___________________________________________________________"
    echo "This script shows some of the system and hardware configurations"
    echo "usage:"
    echo    "systeminfo.sh [options]"
    echo ""
    echo "Options:"
    echo "-sys        It displays the name of the system"
    echo "-dn         It displays the name of the domain"
    echo "-ip         It displays the ip address of machine"
    echo "-osv        It displays the operating system version"
    echo "-osn        It displays the operating system name"
    echo "-cpu        It displays the cpu model, number of cores and modes of cpu"
    echo "-ds         It displays the total disk space avialable on the machine"
    echo "-lp         It displays the list of printers"
    echo "-soft       It displays the softwares installed on this machine with version"
    echo "-help, --h  It displays the help"
    echo "Do You need additional help?"
    echo ""
    exit 0
}
arg=($(echo "$@"))
if [[ -n ${arg[0]} ]]
then
    error
else
    mysystem
    mydomain
    ipaddress
    osversion
    osname
    cpuinfo
    memory
    diskspaceavailable
    printers
    softwaresinstalled
fi