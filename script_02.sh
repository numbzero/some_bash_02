#/bin/bash -x

INTERFACE="wlp2s0" # Change according to your interface.

get_amount ()
{
        VAL=`ifconfig $INTERFACE | grep "$1 packets" | grep -o "(.*)" | grep -o "[0-9.]*"`
        echo "$VAL"
}

SEC="3"

RX_START="`get_amount "RX"`"
TX_START="`get_amount "TX"`"
sleep $SEC
RX_FINISH="`get_amount "RX"`"
TX_FINISH="`get_amount "TX"`"

RX_FLOW=$(printf %.3f $(echo "scale=4; ($RX_FINISH - $RX_START) / $SEC" | bc))
TX_FLOW=$(printf %.3f $(echo "scale=4; ($TX_FINISH - $TX_START) / $SEC" | bc))

echo "RX FLOW - $RX_FLOW kb/s"
echo "TX FLOW - $TX_FLOW kb/s"
