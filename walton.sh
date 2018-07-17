#!/bin/bash
#only edit this file with LF or in linux  Do not save with CRLF (windows default) or it will not work.
#You should call this script like: source walton.sh  or equivalently:  . ./walton.sh
#gitbash version
#results .txt best viewable with cat, nano or vi inside bash, or wordpad in windows or basically anything besides notepad.
#create a peers file, for loop restricted by the entries in peer, retry mechanism

################################[USER OPTIONS]#####################################\
NUM_OF_GPUS=1                                                                     #/
WALLET=0xf3faf814cd115ebba078085a3331774b762cf5ee                                 #\
EXTRA_DATA=glyph                                                                  #/
RPC_PORT_START=8545                                                               #\
IP=127.0.0.1                                                                      #/
###################################################################################/
unset RPC_PORTS 
unset PEERS  
declare -a RPC_PORTS
declare -a PEERS
CT="Content-Type:application/json"
echo " " > results.txt

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

function enumRPCPorts () {    
    for ((i=0;i<$NUM_OF_GPUS;i++)); do
        RPC_PORTS[$i]=$(($RPC_PORT_START+$i))    
    done        
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
        echo -e "\e[32m ethCoinbase didn't get any arguments -- use at least one argument for the number of instances"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[32m Getting eth_coinbase..."`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"eth_coinbase","params":[''],"id":64}' | ./jq '.result'`
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m Coinbase: \e[33m" && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
}

function minerSetEtherbase () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32m You must set at least one arguments for walton instance, eg: minerSetEtherbase 1"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    if  [ -z $4 ]; then
        echo 'No etherbase was set as argument 4, minerSetEtherbase 1 localhost 8545 0xf3faf814cd115ebba078085a3331774b762cf5ee'
        return -1
    else
        ETHERBASE='"'$4'"'
    fi
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[32m Setting Etherbase to:\e[32m $ETHERBASE \e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"miner_setEtherbase","params":['$ETHERBASE'],"id":64}'  | ./jq '.result'`
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m Etherbase has been set:\e[33m " && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
    }

function minerSetExtra () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32m You must set at least one arguments for walton instance, eg: minerSetExtra 1"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
	else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
	RPC_START_PORT=$3
    fi
    if  [ -z $4 ]; then
        echo 'No extraData was set as argument 4, minerSetExtra 1 localhost 8545 typeYourExtraData'
        return -1
    else
        EXTRADATA=$4
    fi
    for ((i=1; i<=$1; i++)); do
        EXTRADATA_GPU='"'$EXTRADATA$walton'"'
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Setting extraData as:\e[32m $EXTRADATA_GPU\e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"miner_setExtra","params":['$EXTRADATA_GPU'],"id":64}' | ./jq '.result'`
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m Extradata has been set:\e[33m " && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
}

function adminAddPeer () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e '\e[32m adminAddPeer recieved no arguments, usage: adminAddPeer 1 localhost 8545 enode://<id>@<ip:port>'
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    if  [ -z $4 ]; then
        echo 'Nothing was set as argument 4, usage: adminAddPeer 1 localhost 8545 enode://<id>@<ip:port>'
        return -1
    else
        PEER_ENODE=$4
    fi
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Adding Peer... as:\e[32m $PEER_ENODE\e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"admin_addPeer","params":['$PEER_ENODE'],"id":64}' | ./jq '.result'`
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m The Peer has been added:\e[33m " && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
}

function netPeerCount () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32mdidn't get any arguments -- use at least one argument for the number of instances"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[32m Getting Peer Count..."`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}'  | ./jq '.result'`
        RESULT=`echo -n $CMD | stripQuotations`
        OUTPUT2=`echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m net_peerCount:\e[33m " && arg2Decimal $RESULT | tee -a results.txt` && echo $OUTPUT2
        walton=$(($walton + 1))
    done
}
function adminNodeInfoEnode () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32mdidn't get any arguments -- use at least one argument for the number of instances"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Getting adminNodeInfoEnode...\e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":64}' | ./jq '.result' | ./jq '.enode'` 
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[33m " && RESULT=`echo $CMD | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
}
function adminNodeInfo () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32m adminNodeInfo didn't get any arguments -- use at least one argument for the number of instances"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Getting admin_nodeInfo...\e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":64}' | ./jq '.result'` 
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[33m " && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
}
function adminNodeInfoPorts () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32m adminNodeInfoPorts didn't get any arguments -- use at least one argument for the number of instances"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    for ((i=1; i<=$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Getting admin_nodeInfo -- Ports...\e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[],"id":64}' | ./jq -r .[0.] | ./jq .[24].network 2>/dev/null`
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m " && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
}
function ethBlockNumber () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32m ethBlockNumber didn't get any arguments -- use at least one argument for the number of instances"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    for ((i=1; i<=$1; i++)); do
       OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[32m Getting eth_blockNumber..."`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":74}'  | ./jq '.result'`
        RESULT=`echo -n $CMD | stripQuotations`
        OUTPUT2=`echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m eth_blockNumber:\e[33m " && arg2Decimal $RESULT | tee -a results.txt` && echo $OUTPUT2
        walton=$(($walton + 1))
    done
}

function ethMining () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32m ethMining didn't get any arguments -- use at least one argument for the number of peers"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    for ((i=1; i<=$1; i++)); do        
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Getting ming mining status:\e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT + $walton))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"eth_mining","params":[],"id":64}' | ./jq '.result'`
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m Mining Status:\e[33m " && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        walton=$(($walton + 1))
    done
}
function adminPeersID () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32m adminPeersID didn't get any arguments -- use at least one argument for the number of peers"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    for ((i=0; i<$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Getting adminPeersID...\e[96m"`
        echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":64}' | ./jq -r .[0.?] | ./jq .[$i].'id'  2> /dev/null` 
        echo -e -n "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[33m " && RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT
        PEERS[$i]=$RESULT
    done
}
function adminPeersRemoteIP () {
    walton=0
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32m adminPeersRemoteIP didn't get any arguments -- use at least one argument for the number of peers"
        return -1
    fi
    if [ -z $2 ]; then
        RPC_SERVER_IP=127.0.0.1
        echo -e "\e[32mSetting IP to 127.0.0.1..."
        else
            RPC_SERVER_IP=$2
    fi
    if [ -z $3 ]; then
        RPC_START_PORT=8545
        echo "Setting RPC Start Port To: 8545..."
    else
        RPC_START_PORT=$3
    fi
    for ((i=0; i<$1; i++)); do
        OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Getting adminPeerRemoteIP...\e[96m"`
        echo $OUTPUT | stripColors >> results.txt
        CMD=`curl --silent $RPC_SERVER_IP:$RPC_START_PORT -H $CT -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":64}' | ./jq -r .[0.?] | ./jq .[$i].'network'.'remoteAddress' 2> /dev/null` 
        RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT 1>/dev/null
        PEERS[$i]=$RESULT
    done
}
function wMain() {
    enumRPCPorts    
    echo "Running on RPC PORTS: '${RPC_PORTS[*]}'"
    #IPv6=$(curl --silent icanhazip.com) && echo "$IPv6"
    minerSetEtherbase $NUM_OF_GPUS $IP $RPC_PORT_START $WALLET    
    minerSetExtra $NUM_OF_GPUS $IP $RPC_PORT_START $EXTRA_DATA    
    ethCoinbase $NUM_OF_GPUS $IP $RPC_PORT_START    
    netPeerCount $NUM_OF_GPUS $IP $RPC_PORT_START
    peerCount=`echo $RESULT`
    ethMining $NUM_OF_GPUS $IP $RPC_PORT_START       
    ethBlockNumber $NUM_OF_GPUS $IP $RPC_PORT_START    
    adminNodeInfoEnode $NUM_OF_GPUS $IP $RPC_PORT_START
    adminNodeInfoEnode 1 $IP ${RPC_PORTS[0]}
    ENODE_WALTON0=`echo $RESULT`
    adminAddPeer $NUM_OF_GPUS $IP $RPC_PORT_START $ENODE_WALTON0    
    adminPeersID $peerCount $IP ${RPC_PORTS[0]}
    adminPeersRemoteIP $peerCount $IP ${RPC_PORTS[0]}
    echo "Pinging all peers and printing the average... this can take awhile to wait for peers who don't respond."    
    for PEER in ${PEERS[@]}; do 
    printf "%-8s\n" $grn ${PEER} $yel| tee results.txt    
    ping -4 -500 -n 1 $(echo -n ${PEER} | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}') | tail -1| awk '{print $9}' | cut -d '/' -f 2       
    done #| column 
    #adminPeersID $NUM_OF_GPUS $IP $RPC_PORT_START         
    echo -e -n "\e[97m" 
}
wMain
