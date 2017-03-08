#!/bin/bash

RRDTOOL="/opt/rocks/bin/rrdtool graph -"
DATAHOME="/home/djennewe/manage/yearly-rrds"
GANGDIR="var/lib/ganglia-disk/rrds"

# Years to process
YEARS="09 10 11 12 13"

BEGIN="0101 00:00"
END="1231 23:59"

# Set LOAD_UPPER to max load for current year.  
# All years will be graphed on current year's scale.
LOAD_LOWER=0
LOAD_UPPER=330 #MAX for 2012

NET_LOWER=0
NET_UPPER=314572800 #300Mb

MEM_LOWER=0
MEM_UPPER=3298534883328 # 3TB #1099511627776 #1TB

for y in $YEARS; do

    year="20${y}"
    start_time="${year}${BEGIN}"
    end_time="${year}${END}"
    rrds="$DATAHOME/$year/$GANGDIR"
    
    # CPU Graph
    $RRDTOOL --start "$start_time" --end "$end_time" \
    --width 800 --height 600 \
    --upper-limit 100 --rigid --lower-limit 0 \
    --title "CPU Utilization $year" --vertical-label Percent \
    DEF:'num_nodes'="$rrds/USD HPC/__SummaryInfo__/cpu_user.rrd":'num':AVERAGE \
    DEF:'cpu_user'="$rrds/USD HPC/__SummaryInfo__/cpu_user.rrd":'sum':AVERAGE \
    CDEF:'ccpu_user'=cpu_user,num_nodes,/ \
    DEF:'cpu_nice'="$rrds/USD HPC/__SummaryInfo__/cpu_nice.rrd":'sum':AVERAGE \
    CDEF:'ccpu_nice'=cpu_nice,num_nodes,/ \
    DEF:'cpu_system'="$rrds/USD HPC/__SummaryInfo__/cpu_system.rrd":'sum':AVERAGE \
    CDEF:'ccpu_system'=cpu_system,num_nodes,/ \
    DEF:'cpu_idle'="$rrds/USD HPC/__SummaryInfo__/cpu_idle.rrd":'sum':AVERAGE \
    CDEF:'ccpu_idle'=cpu_idle,num_nodes,/ \
    AREA:'ccpu_user'#3333bb:'User CPU' \
    STACK:'ccpu_system'#dd0000:'System CPU' \
    DEF:'cpu_wio'="$rrds/USD HPC/__SummaryInfo__/cpu_wio.rrd":'sum':AVERAGE \
    CDEF:'ccpu_wio'=cpu_wio,num_nodes,/ \
    STACK:'ccpu_wio'#ff8a60:'WAIT CPU' \
    STACK:'ccpu_idle'#e2e2f2:'Idle CPU' \
    >"cpu-${year}.png"
    #STACK:'ccpu_nice'#ffea00:'Nice CPU' \

    # Proc Load
    $RRDTOOL --start "$start_time" --end "$end_time" \
    --width 800 --height 600 \
    --lower-limit $LOAD_LOWER --upper-limit $LOAD_UPPER --rigid \
    --title "System Load $year" --vertical-label 'Load/Procs' \
    DEF:'load_one'="$rrds/USD HPC/__SummaryInfo__/load_one.rrd":'sum':AVERAGE \
    DEF:'proc_run'="$rrds/USD HPC/__SummaryInfo__/proc_run.rrd":'sum':AVERAGE \
    DEF:'cpu_num'="$rrds/USD HPC/__SummaryInfo__/cpu_num.rrd":'sum':AVERAGE \
    DEF:'num_nodes'="$rrds/USD HPC/__SummaryInfo__/cpu_num.rrd":'num':AVERAGE \
    AREA:'load_one'#CCCCCC:'1-min Load' \
    LINE2:'cpu_num'#FF0000:'CPUs' \
    LINE2:'proc_run'#0000FF:'Running Processes'\
    >"load-${year}.png"
    #LINE2:'num_nodes'#00FF00:'Nodes' \
    #LINE2:'200'#FF0000:'FOO' \

    # Network
    $RRDTOOL --start "$start_time" --end "$end_time" \
    --width 800 --height 600 \
    --lower-limit $NET_LOWER --upper-limit $NET_UPPER --rigid \
    --title "Network $year" --vertical-label 'Bytes/sec' --base 1024 \
    DEF:'bytes_in'="$rrds/USD HPC/__SummaryInfo__/bytes_in.rrd":'sum':AVERAGE \
    DEF:'bytes_out'="$rrds/USD HPC/__SummaryInfo__/bytes_out.rrd":'sum':AVERAGE \
    LINE2:'bytes_in'#33cc33:'In' LINE2:'bytes_out'#5555cc:'Out'\
    >"network-${year}.png"

	# Memory
    $RRDTOOL --start "$start_time" --end "$end_time" \
	--width 800 --height 600 \
	--lower-limit $MEM_LOWER --upper-limit $MEM_UPPER --rigid \
	--title "Memory $year" --vertical-label Bytes --base 1024 \
	DEF:'mem_total'="$rrds/USD HPC/__SummaryInfo__/mem_total.rrd":'sum':AVERAGE \
	CDEF:'bmem_total'=mem_total,1024,* \
	DEF:'mem_shared'="$rrds/USD HPC/__SummaryInfo__/mem_shared.rrd":'sum':AVERAGE \
	CDEF:'bmem_shared'=mem_shared,1024,* \
	DEF:'mem_free'="$rrds/USD HPC/__SummaryInfo__/mem_free.rrd":'sum':AVERAGE \
	CDEF:'bmem_free'=mem_free,1024,* \
	DEF:'mem_cached'="$rrds/USD HPC/__SummaryInfo__/mem_cached.rrd":'sum':AVERAGE \
	CDEF:'bmem_cached'=mem_cached,1024,* \
	DEF:'mem_buffers'="$rrds/USD HPC/__SummaryInfo__/mem_buffers.rrd":'sum':AVERAGE \
	CDEF:'bmem_buffers'=mem_buffers,1024,* \
	CDEF:'bmem_used'='bmem_total','bmem_shared',-,'bmem_free',-,'bmem_cached',-,'bmem_buffers',- \
	AREA:'bmem_used'#5555cc:'Memory Used' \
	STACK:'bmem_shared'#0000aa:'Memory Shared' \
	STACK:'bmem_cached'#33cc33:'Memory Cached' \
	STACK:'bmem_buffers'#99ff33:'Memory Buffered' \
	DEF:'swap_total'="$rrds/USD HPC/__SummaryInfo__/swap_total.rrd":'sum':AVERAGE \
	DEF:'swap_free'="$rrds/USD HPC/__SummaryInfo__/swap_free.rrd":'sum':AVERAGE \
	CDEF:'bmem_swapped'='swap_total','swap_free',-,1024,* \
	STACK:'bmem_swapped'#9900CC:'Memory Swapped' \
	LINE2:'bmem_total'#FF0000:'Total In-Core Memory' \
	>"memory-${year}.png"

done

exit 0

