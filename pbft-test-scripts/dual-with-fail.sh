#!/bin/bash

LOG_LEVEL=${RUST_LOG:-afp=trace}

RUST_LOG=$LOG_LEVEL ./target/debug/node-template --alice --tmp --port 30334 2>&1 | tee alice.log &
THREAD_1=$!

# let alice enter view_change mode.
sleep 10

RUST_LOG=$LOG_LEVEL ./target/debug/node-template --bob --tmp --bootnodes /ip4/127.0.0.1/tcp/30334/p2p/12D3KooWHnGca3CUcGm5WKsg7b28rv8hJcEb1dwjw5L81XJngNhD 2>&1 | tee bob.log &
THREAD_2=$!

# wait for signal, then kill thread
trap 'kill $THREAD_1 $THREAD_2' SIGINT SIGTERM

wait $THREAD_1 $THREAD_2