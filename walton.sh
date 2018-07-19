#!/bin/bash
#Only save this file with LF (linefeed), not windows default of CRLF, use notepad++ to ensure this.
#Notepad++/VSCode/Sublimetext displays which LF/CRLF it will be saving it with in the bottom right.
#You should call this script like: source walton.sh  or equivalently:  . ./walton.sh
#The results are stored in results.txt, which is best viewable with anything other than notepad.
#FOR ADVANCED CONFIGURATION: Look in the wMain() function at the bottom of the script.
unset NUMBER_OF_WALTONS
unset WALLET
unset EXTRA_DATA
unset RPC_PORT
unset IP
declare -a NUMBER_OF_WALTONS
declare -a WALLET
declare -a EXTRA_DATA
declare -a RPC_PORT
declare -a IP

################################[USER OPTIONS]#####################################\
NUM_OF_RIGS=1

###RIG1###
NUMBER_OF_WALTONS[0]=1                                  #walton.exe's                 
WALLET[0]=0xf3faf814cd115ebba078085a3331774b762cf5ee                                
EXTRA_DATA[0]=glyph                                     #less than or equal to 31 characters                                  
RPC_PORT_START[0]=8545                                                            
IP[0]=127.0.0.1

###RIG2###
#NUMBER_OF_WALTONS[1]=1                                                                     
#WALLET[1]=0xf3faf814cd115ebba078085a3331774b762cf5ee                                
#EXTRA_DATA[1]=glyph                                                               
#RPC_PORT_START[1]=8545                                                            
#IP[1]=127.0.0.1

###RIG3###
#NUMBER_OF_WALTONS[2]=1                                                                     
#WALLET[2]=0xf3faf814cd115ebba078085a3331774b762cf5ee                                
#EXTRA_DATA[2]=glyph                                                                 
#RPC_PORT_START[2]=8545                                                            
#IP[2]=127.0.0.1
                                                                              
################################[USER OPTIONS]#####################################/


unset RPC_PORTS 
unset PEERS
unset peerCount
unset ENODE_ZEROS
declare -a RPC_PORTS
declare -a PEERS
declare -a peerCount
declare -a ENODE_ZEROS
CT="Content-Type:application/json"
echo " " > results.txt

red=$'\e[1;31m'
grn=$'\e[32m'
yel=$'\e[33m'
blu=$'\e[34m'
mag=$'\e[35m'
cyn=$'\e[36m'
end=$'\e[0m' #produced different color results -- figure out why.

function enumRPCPorts () {    
    for ((i=0;i<${NUMBER_OF_WALTONS[$1]};i++)); do
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
    echo -e -n "\e[32m"
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
        peerCount[$(($i-1))]=$RESULT
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
    unset PEERS
    declare -a PEERS
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
    unset peerCount
    declare -a peerCount
    netPeerCount $1 $2 $3 #needed to set global peer array
    walton=0
    for ((j=1; j<=$1; j++)); do       
        for ((i=0; i<${peerCount[$(($j-1))]}; i++)); do
            OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Getting adminPeerID \e[91m$i\e[32m...\e[33m"`
            echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
            CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":64}' | ./jq -r .[0.?] 2> /dev/null | ./jq .[$i].'id'  2> /dev/null` 
            RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT       
            PEERS[$(($i+$j-1))]=$RESULT
        done               
        walton=$(($walton + 1))        
    done
}
function adminPeersRemoteIP () {
    walton=0    
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32m adminPeersRemoteIP didn't get any arguments -- use at least one argument for the number of instances"
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
    unset peerCount
    declare -a peerCount    
    netPeerCount $1 $2 $3 #needed to set global peer array
    walton=0
    for ((j=1; j<=$1; j++)); do     
        for ((i=0; i<${peerCount[$(($j-1))]}; i++)); do
            OUTPUT=`echo -e "\e[94m[\e[96mwalton:\e[91m$walton\e[94m]\e[95m\e[32m Getting adminPeerRemoteIP \e[91m$i\e[32m...\e[33m"`            
            echo $OUTPUT && echo $OUTPUT | stripColors >> results.txt
            CMD=`curl --silent $RPC_SERVER_IP:''$(($RPC_START_PORT))'' -H $CT -X POST --data '{"jsonrpc":"2.0","method":"admin_peers","params":[],"id":64}' | ./jq -r .[0.?] 2>/dev/null | ./jq .[$i].'network'.'remoteAddress' 2> /dev/null` 
            RESULT=`echo $CMD  | tee -a results.txt` && echo $RESULT       
            PEERS[$(($i+$j-1))]=$RESULT
        done                
        walton=$(($walton + 1))        
    done
}
function pingPeers() {
     
    echo -e "\e[32m"
    if [ -z $1 ]; then
        echo -e "\e[32m pingPeers didn't get any arguments -- use at least one argument for the number of instances"
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
    walton=0
    adminPeersRemoteIP $1 $2 $3
    for PEER in ${PEERS[@]}; do 
        printf "%-8s\n" $grn ${PEER} $yel| tee results.txt    
        ping -4 -w 750 -n 2 $(echo -n ${PEER} | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}') | tail -1 | awk '{print $9}' | cut -d '/' -f 2       
    done #| column 
}
################################[USER OPTIONS]#####################################/
function wMain() { 
        enumRPCPorts $1              
        echo -e "\e[97mIPv4 LAN ADDRESS(ES): "
        ipconfig | grep "IPv4" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"
        echo -e "\e[32mRunning on RPC PORTS: '${RPC_PORTS[*]}'"        

        minerSetEtherbase ${NUMBER_OF_WALTONS[$1]} ${IP[$1]} ${RPC_PORT_START[$1]} ${WALLET[$1]}

        minerSetExtra ${NUMBER_OF_WALTONS[$1]} ${IP[$1]} ${RPC_PORT_START[$1]} ${EXTRA_DATA[$1]}
        
        adminNodeInfoEnode 1 ${IP[$1]} ${RPC_PORTS[0]} 1> /dev/null
        ENODE_ZEROES[$1]=`echo $RESULT`  
        for ((k=0;k<$1+1;k++)); do 
            adminAddPeer 1 ${IP[$1]} ${RPC_PORT_START[$1]} ${ENODE_ZEROES[$1]}
        done            
        
        ethMining ${NUMBER_OF_WALTONS[$1]} ${IP[$1]} ${RPC_PORT_START[$1]}       
        
        ethBlockNumber ${NUMBER_OF_WALTONS[$1]} ${IP[$1]} ${RPC_PORT_START[$1]} 

        adminNodeInfoEnode ${NUMBER_OF_WALTONS[$1]} ${IP[$1]} ${RPC_PORT_START[$1]}
           
        pingPeers ${NUMBER_OF_WALTONS[$1]} ${IP[$1]} ${RPC_PORT_START[$1]}
        
        #adminPeersID $NUMBER_OF_WALTONS $IP $RPC_PORT_START #stand alone adminPeersID example.
        #ethCoinbase $NUMBER_OF_WALTONS $IP $RPC_PORT_START #stand alone coinbase example.
        #adminPeersRemoteIP $NUMBER_OF_WALTONS $IP $RPC_PORT_START #adminPeersRemoteIP stand alone example.
        #netPeerCount $NUMBER_OF_WALTONS $IP $RPC_PORT_START  #netPeerCount stand alone example.  
        #IPv6=$(curl --silent icanhazip.com) && echo "$IPv6"  
        echo -e -n "\e[97m"     
}
################################[USER OPTIONS]#####################################/
#RIGLOOP THROUGH wMain()

for ((r=0;r<$NUM_OF_RIGS;r++)); do    
    wMain $r 
done

