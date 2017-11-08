#!/bin/perl
# Allan McAleavy Created This.
# November 2017
#

use strict;
my $file=shift;
my $hpov=shift;
my $port=shift;

my $read_hit_iops=0;
my $read_miss_iops=0;
my $write_hit_iops=0;
my $write_miss_iops=0;
my $read_mem_hit_iops=0;
my $read_hit_mb=0;
my $read_miss_mb=0;
my $write_hit_mb=0;
my $write_miss_mb=0;
my $total_read_mb=0;
my $total_write_mb=0;
my $total_writes=0;
my $total_reads=0;
my $total_mb=0;
my $total_iops=0;
my $total_riops=0;
my $total_wiops=0;

# Write miss latency data
my $wmss=0;             # write miss small
my $wmms=0;             # write miss medium
my $wmls=0;             # write miss large
my $wmvls=0;            # write miss very large
my $wmisslat=0;         # write miss latency
# write hit latency data
my $whss=0;             # write hit small
my $whms=0;             # write hit medium
my $whls=0;             # write hit large
my $whvls=0;            # write hit very large
my $whisslat=0;         # write hit miss latency
my $whplusm=0;          # write hit plus miss latency
# read miss latency
my $rmss=0;             # read miss small
my $rmms=0;             # read miss medium
my $rmls=0;             # read miss large
my $rmvls=0;            # readm miss very large
my $rmisslat=0;         # read miss latency
# read hit latency
my $rhss=0;             # read hit small
my $rhms=0;             # read hit medium
my $rhls=0;             # read hit large
my $rhvls=0;            # read hit very large
my $rhisslat=0;         # read hit miss latency
my $rhplusm=0;          # read hit plus miss latency
my $ts=0;               # timestampe counter
my @list;               # array of values to parse

open(XIV,$file) || die("Could not open file $file \n");
my @name = split("\_",$file);

sub get_write_miss_latency {

          my $total_writes = shift;
          if ( $total_writes > 0 )
          {
          # latency * ( latency_iops_type / total_type_iops )
          $wmss = $list[47] * ( $list[46] / $total_writes ) if $list[46] ;
          $wmms = $list[44] * ( $list[43] / $total_writes ) if $list[43] ;
          $wmls = $list[41] * ( $list[40] / $total_writes ) if $list[40] ;
          $wmvls = $list[38] * ( $list[37] / $total_writes ) if $list[37];
          $wmisslat = ( $wmss + $wmms + $wmls + $wmvls ) / 1000 ;
          }
          else
          { return 0; }

         }
sub get_write_hit_latency {
          my $total_writes = shift;
          if ( $total_writes > 0 )
          {
          $whss = $list[35] * ( $list[34] / $total_writes ) if $list[34] ;
          $whms = $list[32] * ( $list[31] / $total_writes ) if $list[31] ;
          $whls = $list[29] * ( $list[28] / $total_writes ) if $list[28] ;
          $whvls = $list[26] * ( $list[25] / $total_writes ) if $list[25];
          $whisslat = ( $whss + $whms + $whls + $whvls ) / 1000 ;
          }
          else
          { return 0; }

}

sub get_read_miss_latency {
          my $total_reads = shift;
          if ( $total_reads > 0 )
          {
          $rmss = $list[23] * ( $list[22] / $total_reads ) if $list[22] ;
          $rmms = $list[20] * ( $list[19] / $total_reads ) if $list[19] ;
          $rmls = $list[17] * ( $list[16] / $total_reads ) if $list[16] ;
          $rmvls = $list[14] * ( $list[13] / $total_reads ) if $list[13];

          $rmisslat = ( $rmss + $rmms + $rmls + $rmvls ) / 1000 ;
            }
          else
          { return 0; }

}

sub get_read_hit_latency {
          my $total_reads = shift;
          if ( $total_reads > 0 )
          {

          $rhss = $list[11] * ( $list[10] / $total_reads ) if $list[10] ;
          $rhms = $list[8] * ( $list[7] / $total_reads ) if $list[7] ;
          $rhls = $list[5] * ( $list[4] / $total_reads ) if $list[4] ;
          $rhvls = $list[2] * ( $list[1] / $total_reads ) if $list[1];

          $rhisslat = ( $rhss + $rhms + $rhls + $rhvls ) / 1000 ;
          }
          else
          { return 0; }

}


while (<XIV>)
{
  chomp();
  if ($_ =~ /Time/)
   {
        next;
   }

      if ( $_ =~ /^"[0-9]/ )
        {
          @list=split("\",\"",$_);

          # get latency figures first.

          $read_hit_iops=$list[1]+$list[4]+$list[7]+$list[10];
          $read_miss_iops=$list[13]+$list[16]+$list[19]+$list[22];
          $write_hit_iops=$list[25]+$list[28]+$list[31]+$list[34];
          $write_miss_iops=$list[37]+$list[40]+$list[43]+$list[46];
          $read_mem_hit_iops=$list[49]+$list[52]+$list[55]+$list[58];

          $read_hit_mb=($list[3]+$list[6]+$list[9]+$list[12]) /1024;
          $read_miss_mb=($list[15]+$list[18]+$list[21]+$list[24]) /1024;

          $write_hit_mb=($list[27]+$list[30]+$list[33]+$list[36])/1024;
          $write_miss_mb=($list[39]+$list[42]+$list[45]+$list[48])/1024;

          $total_read_mb=($read_hit_mb+$read_miss_mb);
          $total_write_mb=($write_hit_mb+$write_miss_mb);
          $total_mb=$total_read_mb+$total_write_mb;

          $total_iops=($read_hit_iops+$read_miss_iops+$write_hit_iops+$write_miss_iops);
          $total_riops=($read_hit_iops+$read_miss_iops);
          $total_wiops=($write_hit_iops+$write_miss_iops);

          $ts=$list[61];
          $ts=~s/"//g;

          $total_writes = $write_miss_iops + $write_hit_iops ;
          my $w_hit_lat = get_write_hit_latency($write_hit_iops);
          my $w_miss_lat = get_write_miss_latency($write_miss_iops);
          my $total_whit_lat = get_write_hit_latency($total_writes);
          my $total_wmiss_lat = get_write_miss_latency($total_writes);
          $whplusm = ( $total_whit_lat + $total_wmiss_lat ) ;

          $total_reads = $read_miss_iops + $read_hit_iops;
          my $r_hit_lat = get_read_hit_latency($read_hit_iops);
          my $r_miss_lat = get_read_miss_latency($read_miss_iops);
          my $total_rhit_lat = get_read_hit_latency($total_reads);
          my $total_rmiss_lat = get_read_miss_latency($total_reads);
          $rhplusm = ( $total_rhit_lat + $total_rmiss_lat ) ;

          if ( $hpov eq "Port" )
          {
             $port=$name[2];
             $port=~s/^Port://g;
          }
          else
          {
             $port=lc $name[1];
             $port=~s/.*\///g;
          }

          if (( $hpov eq "Host" ) || ( $hpov eq "Vol"  ) || ( $hpov eq "Port"))
          {

                #IOPS
                print "XIV" . $hpov . "IO," . $hpov . "IO=$port,type=tiops value=$total_iops $ts\n";
                print "XIV" . $hpov . "IO," . $hpov . "IO=$port,type=riops value=$total_riops $ts\n";
                print "XIV" . $hpov . "IO," . $hpov . "IO=$port,type=wiops value=$total_wiops $ts\n";
                print "XIV" . $hpov . "IORH," . $hpov . "IO=$port,type=rmiops value=$read_miss_iops $ts\n";
                print "XIV" . $hpov . "IORH," . $hpov . "IO=$port,type=wmiops value=$write_miss_iops $ts\n";
                print "XIV" . $hpov . "IORH," . $hpov . "IO=$port,type=rhiops value=$read_hit_iops $ts\n";
                print "XIV" . $hpov . "IORH," . $hpov . "IO=$port,type=whiops value=$write_hit_iops $ts\n";

                # BW
                print "XIV" . $hpov . "BW," . $hpov . "BW=$port,type=tbandw value=$total_mb $ts\n";
                print "XIV" . $hpov . "BW," . $hpov . "BW=$port,type=rbandw value=$total_read_mb $ts\n";
                print "XIV" . $hpov . "BW," . $hpov . "BW=$port,type=wbandw value=$total_write_mb $ts\n";
                print "XIV" . $hpov . "BWHM," . $hpov . "BW=$port,type=rmbandw value=$read_miss_mb $ts\n";
                print "XIV" . $hpov . "BWHM," . $hpov . "BW=$port,type=wmbandw value=$write_miss_mb $ts\n";
                print "XIV" . $hpov . "BWHM," . $hpov . "BW=$port,type=rhbandw value=$read_hit_mb $ts\n";
                print "XIV" . $hpov . "BWHM," . $hpov . "BW=$port,type=whbandw value=$write_hit_mb $ts\n";

                #LATENCY
                print "XIV" . $hpov . "RT," . $hpov . "RT=$port,type=wlat value=$whplusm $ts\n";
                print "XIV" . $hpov . "RT," . $hpov . "RT=$port,type=rlat value=$rhplusm $ts\n";
                print "XIV" . $hpov . "RTHM," . $hpov . "RT=$port,type=wmiss value=$w_miss_lat $ts\n";
                print "XIV" . $hpov . "RTHM," . $hpov . "RT=$port,type=whit value=$w_hit_lat $ts\n";
                print "XIV" . $hpov . "RTHM," . $hpov . "RT=$port,type=rmiss value=$r_miss_lat $ts\n";
                print "XIV" . $hpov . "RTHM," . $hpov . "RT=$port,type=rhit value=$r_hit_lat $ts\n";
          }

          if ( $hpov eq "HPort" )
          {
                $port=lc $name[2];
                $port=~s/port\///g;
                print "XIVHPortIO,PortHIO=$port,type=tiops value=" . $total_iops . " $ts\n";
                print "XIVHPortIO,PortHIO=$port,type=wiops value=" . $total_writes . " $ts\n";
                print "XIVHPortIO,PortHIO=$port,type=riops value=" . $total_reads . " $ts\n";
                print "XIVHPortBW,PortHBW=$port,type=tbandw value=$total_mb $ts\n";
                print "XIVHPortBW,PortHBW=$port,type=wbandw value=$total_write_mb $ts\n";
                print "XIVHPortBW,PortHBW=$port,type=rbandw value=$total_read_mb $ts\n";
                print "XIVHPortRT,PortHRT=$port,type=wlat value=$whplusm $ts\n";
                print "XIVHPortRT,PortHRT=$port,type=rlat value=$rhplusm $ts\n";
         }


         # reset values
          $total_read_mb=0;
          $total_write_mb=0;
          $read_hit_mb=0;
          $read_miss_mb=0;
          $write_hit_mb=0;
          $write_miss_mb=0;
          $total_read_mb=0;
          $total_write_mb=0;
          $read_hit_iops=0;
          $read_miss_iops=0;
          $write_hit_iops=0;
          $write_miss_iops=0;
          $read_mem_hit_iops=0;
          $total_mb=0;
          $total_riops=0;
          $total_wiops=0;
          $total_iops=0;
          $wmss=0;
          $wmms=0;
          $wmls=0;
          $wmvls=0;
          $wmisslat=0;
          $whss=0;
          $whms=0;
          $whls=0;
          $whvls=0;
          $whisslat=0;
          $whplusm=0;
          $rmss=0;
          $rmms=0;
          $rmls=0;
          $rmvls=0;
          $rmisslat=0;
          $rhss=0;
          $rhms=0;
          $rhls=0;
          $rhvls=0;
          $rhisslat=0;
          $rhplusm=0;
        }
}
close(XIV);
