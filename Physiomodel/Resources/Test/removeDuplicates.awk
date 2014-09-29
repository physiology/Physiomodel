BEGIN { FS=";"; last=""; }
{   if( last!=$0 ){
		last=$0
		print last
    } 
}
END { print "\r\n" }
