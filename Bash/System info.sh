#!/bin/bash
#bash assignment 

function mysystem ()
{
    echo ""
    hostname -s
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
function IP address ()
{
   echo "" 
   echo "The IP address of my machine is $(ifconfig | grep "inet addr" | head -n1 | cut -d: -f2 | cut -d" " -f1)"
   return 0
}
function Operating System Version ()
{
    echo ""
    echo "This is my OS version $(cat /etc/os-release | grep "VERSION_ID"| cut -d\" -f2)"
    return 0
}
function OS name ()
{
    echo ""
    echo "My Operating System name is $(cat /etc/os-release | grep "NAME" | head -n1 | cut -d\" -f2)"
    return 0
}
function CPU ()
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
function diskspace available ()
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
        if [ -n $(lpstat -a)];
        then
            echo "List of the Available Printers"
            echo "------------------------------"
            lpstat -a | awk '{print $1}'
        else
            echo "This machine has no Printers"
        fi
        return 0
}
function softwares installed ()
{
    #check if the script is running in a Linux based debian distribution.
    if [ $(cat /etc/os-release | grep ID_LIKE | cut -d= -f2) != "debian" ]
    then
        echo ""
        echo "This option just can run in a Debian based distribution.">&2
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
    return 0
}
function help ()
{
    echo ""
    echo "                              HELP                                    "
    echo "======================================================================"
    echo "warning: this script will only works on debian based system"
    echo "___________________________________________________________"
    echo "This script will show some system and hardware configuration"
    echo "usage:"
    echo    "systeminfo.sh [options]"
    echo ""
    echo "Options:"
    echo "-mysys        show system name"
    echo "-mydn         show the domain name"
    echo "-myip         show the ip address of device"
    echo "-myosv        show the operating system version"
    echo "-myosn        show the operating system name"
    echo "-mycpu        show the cpu model, number of cores and modes cpu"
    echo "-myds         show the total available disk space"
    echo "-mylp         show the list of printers"
    echo "-mysoft       show the softwares with version"
    echo "-help, --h    show this help"
    echo "Thanks for using help"
    echo ""
    exit 0
    
}

params=1

while [ $params -le $# ]
do 
    case $1 in
    
        -mysys)         mysystem
        ;;
        
        -mydn)          mydomain
        ;;
        
        -myip)          IP address
        ;;
        
        -myosv)         Operating system Version
        ;;
        
        -myosn)         OS name
        ;;
        
        -mycpu)         CPU
        ;;
        
        -myds)          diskspace available
        ;;
        
        -mylp)          printers
        ;;
        
        -mysoft)        softwares installed
        ;;
    
        -error)         erorr
        ;;
        
        -help|--h)      help
        ;;
        
        *)              error
                        help
        ;;
        
    esac
    shift
done