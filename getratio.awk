BEGIN {
sendLine = 0; recvLine = 0;  fowardLine = 0;  sendline1 = 0; fowardLine1 = 0;
}
$0 ~/^s.* AGT/ {sendLine ++ ;
}
$0 ~/^r.* AGT/ {recvLine ++ ;
}
$0 ~/^f.* RTR/ { fowardLine ++ ;
}
$0 ~/^s.* AODV/ { sendLine1 ++ ;}
$0 ~/^f.* AODV/ { fowardLine1 ++ ;}
END {




#printf "s:%d r:%d \n delivery rate ratio:%.4f \nf:%d \n mean hop:%.4f \n normalized routing load:%.4f \n end-end delay:%.5f \n", sendLine, recvLine, (recvLine/sendLine),fowardLine,(sendLine+fowardLine)/sendLine,(sendLine1+foward Line1)/recvLine,( 0.260157/recvLine);cout<< " For LAR-2 Algorithm\t2\n";
pdfraction=(recvLine/sendLine)*100; avg_end_to_end_delay=( 0.260157/recvLine) ;

normal_routing_load= (sendLine1+fowardLine1)/recvLine;
printf(" Total packet sends: %d\t \n", sendLine);
printf(" Total packet receives: %d\t \n", recvLine);
printf(" Packet delivery fraction: %.4f\t \n", pdfraction);
printf(" Average End-to-End delay:%f s\t \n" , avg_end_to_end_delay);
printf(" normalized routing load:%f s\t\n", normal_routing_load);
}
