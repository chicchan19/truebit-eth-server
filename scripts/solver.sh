#!/bin/bash
echo "solver mode."
CLEF_PWD=$1
TBNETWORK=$2
SOLVER_WALLET_ID=$3

if [ "$TBNETWORK" == "goerli" ]
then
    bash /tbscripts/goerli_setup.sh "$CLEF_PWD" &
    GETH_IPC='/root/.ethereum/goerli/geth.ipc'
else
    bash /tbscripts/mainnet_setup.sh "$CLEF_PWD" &
    GETH_IPC='/root/.ethereum/geth.ipc'
fi
WALLET="${SOLVER_WALLET_ID:=0}"

echo "Waiting for GETH IPC to Exist..."
until [ -S $GETH_IPC ]; do sleep 1; done
cd /truebit-eth
echo "Starting TrueBit-OS In Solver mode on Wallet [$WALLET]"
./truebit-os -c "start solve -a $WALLET" --batch 2>> ~/logs/truebit-solver.log &
