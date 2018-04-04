BEGIN {
highest_packet_id = 0; n=0; tm=0; }
{
action = $1; time = $2; flow_id = $4; packet_id = $6; if ( packet_id > highest_packet_id )
highest_packet_id = packet_id;
74
if ( start_time[packet_id] == 0 ) start_time[packet_id] = time;
if ( flow_id == "AGT" && action != "d" ) { if ( action == "r" ) {
end_time[packet_id] = time; }
} else { end_time[packet_id] = -1;
} }
END {
for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ ) {
start = start_time[packet_id];
end = end_time[packet_id]; 
packet_duration = end - start;
printf("%f\n", packet_duration);
if ( start < end ) { n += 1;
tm += packet_duration; #printf("%f\n", tm/n);
} }
printf("%f\n", tm/n); }
