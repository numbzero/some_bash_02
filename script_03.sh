#/bin/bash -x

INTERFACE="wlp2s0" # Change according to your interface.

get_amount ()
{
        VAL=`ifconfig $INTERFACE | grep "$1 packets" | grep -o "(.*)" | grep -o "[0-9.]*"`
        echo "$VAL"
}

SEC="3"
MAX_RX="0"
MAX_TX="0"
for i in {0..19}; do
	RX_START="`get_amount "RX"`"
	TX_START="`get_amount "TX"`"
	sleep $SEC
	RX_FINISH="`get_amount "RX"`"
	TX_FINISH="`get_amount "TX"`"
	RX_FLOW=$(printf %.4f $(echo "scale=4; ($RX_FINISH - $RX_START) / $SEC" | bc))
	TX_FLOW=$(printf %.4f $(echo "scale=4; ($TX_FINISH - $TX_START) / $SEC" | bc))
	if [ $(echo "$RX_FLOW > $MAX_RX" | bc) -eq "1" ]; then
		MAX_RX=$RX_FLOW
	fi
	if [ $(echo "$TX_FLOW > $MAX_TX" | bc) -eq "1" ]; then
		MAX_RX=$TX_FLOW
	fi
done

echo "MAX_RX - $MAX_RX kb/s"
echo "MAX_TX - $MAX_TX kb/s"
