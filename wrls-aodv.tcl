#wrls-aodv.tcl
# A 100 nodes for ad-hoc simulation with AODV and DSR
# Define options
set val(chan)   Channel/WirelessChannel ;# channel type
set val(prop)   Propagation/TwoRayGround ;# radio-propagation model
set val(netif)  Phy/WirelessPhy ;# network interface type



set val(ant)    Antenna/OmniAntenna ;# antenna model
set val(ifqlen) 50  ;# max packet in ifq
set val(nn)     15  ;# number of mobilenodes
set val(rp)     AODV ;# routing protocol AODV or DSR

set val(x)      500 ;# X dimension of topography
set val(y)      400 ;# Y dimension of topography
set val(mac)    Mac/802_11 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue ;# interface queue type
set val(ll)     LL ;# link layer type








set val(stop) 100 ;# time of simulation end
set ns [new Simulator]
set tracefd [open tracef.tr w]
set windowVsTime2 [open win.tr w]
set namtrace [open simwrls.nam w]
$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)
# set up topography object
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)
# Create nn mobilenodes [$val(nn)] and attach them to the channel. # configure the nodes
$ns node-config -adhocRouting $val(rp) \
  -llType $val(ll) \
  -macType $val(mac) \
  -ifqType $val(ifq) \
  -ifqLen $val(ifqlen) \
  -antType $val(ant) \
  -propType $val(prop) \
  -phyType $val(netif) \
  -channelType $val(chan) \
  -topoInstance $topo \
  -agentTrace ON \
  -routerTrace ON \
  -macTrace OFF \
  -movementTrace ON
for {set i 0} {$i < $val(nn) } { incr i } {
set node_($i) [$ns node] }



 # Provide initial location of mobilenodes
$node_(0) set X_ 5.0 $node_(0) set Y_ 5.0 $node_(0) set Z_ 0.0
$node_(1) set X_ 490.0 B$node_(1) set Y_ 285.0 $node_(1) set Z_ 0.0
$node_(2) set X_ 150.0 $node_(2) set Y_ 240.0 $node_(2) set Z_ 0.0
$node_(3) set X_ 250.0 $node_(3) set Y_ 240.0 $node_(3) set Z_ 0.0
$node_(4) set X_ 100.0 $node_(4) set Y_ 70.0 $node_(4) set Z_ 0.0
$node_(5) set X_ 170.0 $node_(5) set Y_ 70.0 $node_(5) set Z_ 0.0
# Generation of movements
$ns at 10.0 "$node_(0) setdest 250.0 250.0 10.0"
$ns at 15.0 "$node_(1) setdest 245.0 285.0 10.0"
$ns at 20.0 "$node_(0) setdest 480.0 300.0 10.0"
$ns at 25.0 "$node_(3) setdest 280.0 30.0 10.0"
$ns at 30.0 "$node_(4) setdest 287.0 30.0 10.0"
$ns at 35.0 "$node_(5) setdest 189.0 30.0 10.0"
# Set a TCP connection between node_(0) and node_(1)
set tcp [new Agent/TCP/Newreno]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp
$ns attach-agent $node_(1) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 10.0 "$ftp start"
# Printing the window size
proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file" }
$ns at 10.1 "plotWindow $tcp $windowVsTime2"
# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
# 30 defines the node size for nam
$ns initial_node_pos $node_($i) 30
}
# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
$ns at $val(stop) "$node_($i) reset"; }
# ending nam and the simulation
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 150.01 "puts \"end simulation\";$ns halt"

proc attach-expoo-traffic { node sink size burst idle rate } {
#Get an instance of the simulator
set ns [Simulator instance]
#Create a UDP agent and attach it to the node
set source [new Agent/UDP]


$ns attach-agent $node $source
#Create an Expoo traffic agent and set its configuration parameters
set traffic [new Application/Traffic/Exponential]
$traffic set packetSize_ $size
$traffic set burst_time_ $burst
$traffic set idle_time_ $idle
$traffic set rate_ $rate
# Attach traffic source to the traffic generator
$traffic attach-agent $source
#Connect the source and the sink
$ns connect $source $sink
return $traffic
}
set sink0 [new Agent/LossMonitor]
set sink1 [new Agent/LossMonitor]
set sink2 [new Agent/LossMonitor]
$ns attach-agent $node_(3) $sink0
$ns attach-agent $node_(3) $sink1
$ns attach-agent $node_(3) $sink2
set source0 [attach-expoo-traffic $node_(0) $sink0 200 2s 1s 100k]
set source1 [attach-expoo-traffic $node_(1) $sink1 200 2s 1s 200k]
set source2 [attach-expoo-traffic $node_(2) $sink2 200 2s 1s 300k]
#In this project we use Agent/LossMonitor objects as traffic sinks, since they store the amount of bytes received, which can be used to calculate the bandwidth.
#VIII.2. Recording Data in Output Files
#Now we have to open three output files. The following lines have to appear 'early' in the Tcl script.


set f0 [open out0.tr w]
set f1 [open out1.tr w]
set f2 [open out2.tr w]
#--------------------------------------- proc finish from file wlan.tcl---------------------------- #=============================================================
proc stop {} {
global ns tracefd namtrace f0 f1 f2
#Close the output files
$ns flush-trace
close $tracefd
close $namtrace
#-------------------------------------------------------------------------------
close $f0
close $f1
close $f2
#Call xgraph to display the results
exec xgraph out0.tr out1.tr &
exec nam simwrls.nam &
exit 0 }
#------------------------------------------------------------------------------------------------------- #Now we can write the procedure which actually writes the data to the output files.
 proc record {} {
global sink0 sink1 sink2 f0 f1 f2


#Get an instance of the simulator
set ns [Simulator instance]
#Set the time after which the procedure should be called again
set time 0.5
#How many bytes have been received by the traffic sinks?
set bw0 [$sink0 set bytes_]
set bw1 [$sink1 set bytes_]
set bw2 [$sink2 set bytes_]
#Get the current time
set now [$ns now]
#Calculate the bandwidth (in MBit/s) and write it to the files
puts $f0 "$now [expr $bw0/$time*8/1000000]"
puts $f1 "$now [expr $bw1/$time*8/1000000]"
puts $f2 "$now [expr $bw2/$time*8/1000000]"
#Reset the bytes_ values on the traffic sinks
$sink0 set bytes_ 0
$sink1 set bytes_ 0
$sink2 set bytes_ 0
#Re-schedule the procedure
$ns at [expr $now+$time] "record"
}
$ns at 0.0 "record"
$ns at 10.0 "$source0 start"
$ns at 10.0 "$source1 start"
$ns at 10.0 "$source2 start"
$ns at 50.0 "$source0 stop"
$ns at 50.0 "$source1 stop"


$ns at 50.0 "$source2 stop"
$ns at 60.0 "stop"
#Call the finish procedure after 5 seconds of simulation time
$ns run
