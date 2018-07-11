#!/bin/bash
#only edit this file with LF or in linux  Do not save with CRLF (windows default) or it will not work.
#You should call this script like: source walton.sh  or equivalently:  . ./walton.sh
#gitbash version
#results .txt best viewable with cat, nano or vi inside bash, or wordpad in windows or basically anything besides notepad.
#create a peers file, for loop restricted by the entries in peer, retry mechanism

################################[USER OPTIONS]#####################################\
NUM_OF_GPUS=3                                                                     #/
WALLET='"0xf3faf814cd115ebba078085a3331774b762cf5ee"'                             #\
EXTRA_DATA='"glyph'                                                               #/
RPC_PORT_START=8545                                                               #\
###################################################################################/

CT="Content-Type:application/json"
echo " " > results.txt

function enumRPCPorts () {    
    declare -a RPC_PORTS
    for ((i=0;i<$NUM_OF_GPUS;i++)); do
        RPC_PORTS[$i]=$(($RPC_PORT_START+$i))
    done
    declare -p RPC_PORTS
}
    
function stripColors () {
    sed "s/\x1B\[\([0-9]\{1,2\}\(;[0-9]\{1,2\}\)\?\)\?[mGK]//g"
}

function arg2Decimal () {
         printf "%d" $1
}

function stripQuotations () {
    sed -e 's/^"//' -e 's/"$//'
}

function ethCoinbase () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32mYou need to use at least one argument for the amount of walton instances, eg: source ./walton.sh 1"
        return -1
    fi
    RPC_START_PORT=$2
    if [ -z $2 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    fi  
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[32m Getting eth_coinbase..."`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent http://127.0.0.1:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"eth_coinbase","params":[''],"id":64}' | ./jq '.result'`
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m Coinbase: \e[33m" && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
}

function minerSetEtherbase () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32mYou need to use at least one argument for the amount of walton instances, eg: source ./walton.sh 1"
        return -1
    fi
    RPC_START_PORT=$2
    if [ -z $2 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    fi
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[32m Setting Etherbase to:\e[32m $WALLET \e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent http://127.0.0.1:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"miner_setEtherbase","params":['$WALLET'],"id":64}'  | ./jq '.result'`
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m Etherbase has been set:\e[33m " && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
    }

function minerSetExtra () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32mYou need to use at least one argument for the amount of walton instances, eg: source ./walton.sh 1"
        return -1
    fi
    fi
    RPC_START_PORT=$2
    if [ -z $2 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    fi
    for ((i=1; i<=$1; i++)); do
        EXTRA_DATA_WITH_GPU=$EXTRA_DATA$walton'"'
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Setting extraData as:\e[32m $EXTRA_DATA_WITH_GPU\e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent http://127.0.0.1:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"miner_setExtra","params":['$EXTRA_DATA_WITH_GPU'],"id":64}' | ./jq '.result'`
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m Extradata has been set:\e[33m " && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
}
#not_finished_function_yet
function adminAddPeers () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32mYou need to use at least one argument for the amount of walton instances, eg: source ./walton.sh 1"
        return -1
    fi
    fi
    RPC_START_PORT=$2
    if [ -z $2 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    fi
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[32mNET PEERCOUNT OF\e[31m \e[32mOF WALTON walton:\e[31m $walton\e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent http://127.0.0.1:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"admin_addPeers","params":['$peer'],"id":74}'  | ./jq '.result'`
        echo -e -n "\e[32mADMIN_ADDPEER RESULT  :: $walton :: \e[33m "
        RESULT=`echo $CMD | tee -a results.txt`
        walton=$(($walton + 1))
    done
}

function netPeerCount () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32mYou need to use at least one argument for the amount of walton instances, eg: source ./walton.sh 1"
        return -1
    fi
    RPC_START_PORT=$2
    if [ -z $2 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    fi
    
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[32m Getting Peer Count..."`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent http://127.0.0.1:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}'  | ./jq '.result'`
        RESULT=`echo -n $CMD | stripQuotations`
        OUTPUT2=`echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m net_peerCount:\e[33m " && arg2Decimal $RESULT | tee -a results.txt` && echo $OUTPUT2
        walton=$(($walton + 1))
    done

}

function wMain () {
    IPv4=$(curl --silent -4 icanhazip.com) && echo "$IPv4"
    #IPv6=$(curl --silent icanhazip.com) && echo "$IPv6"    
    #minerSetEtherbase $NUM_OF_GPUS $RPC_PORT_START
    #echo " "
    #minerSetExtra $NUM_OF_GPUS $RPC_PORT_START
    #echo " "
    #ethCoinbase $NUM_OF_GPUS $RPC_PORT_START
    #echo " "
    netPeerCount $NUM_OF_GPUS    
    #enumRPCPorts 
    echo -e -n "\e[97m"
}

wMain


