#!/bin/bash

# This script will work it's way through the directories and convert all the files

# Set up some paths
ESGF_DIR="/data/CMIP/curated_ESGF_replica"
THIS_DIR=`pwd`
echo $PWD
info_file="cal_adj_info.csv"
CA_STR="cal-adj"
NO_OVERWRITE="TRUE"

# define a function to test whether the contents of the netcdf file is a regular lat,lon) file
function isLatLon {
  isLatLon_DIR=$1
  isLatLon_filename=$2
  isLatLon_varname=${isLatLon_filename%%_*}
  isLatLon_var_str=`ncdump -h $isLatLon_DIR/$isLatLon_filename | grep float`
  isLatLon_dims=`echo $isLatLon_var_str | cut -d\( -f2 | cut -d\) -f1`
  isLatLon_dims_parsed=`echo ,${isLatLon_dims// }`
  if [[ $isLatLon_dims_parsed == *",lat"* ]] && [[ $isLatLon_dims_parsed == *",lon"* ]]
  then
    return 1
  else
    return 0
  fi
}  

pmip3_gcms="ACCESS-ESM1-5 bcc-csm1-1 CCSM4 CNRM-CM5 COSMOS-ASO CSIRO-Mk3-6-0 CSIRO-Mk3L-1-2 EC-EARTH-2-2 FGOALS-g2 FGOALS-s2 GISS-E2-R HadCM3 HadGEM2-CC HadGEM2-ES IPSL-CM5A-LR KCM1-2-2 LOVECLIM MIROC-ESM MPI-ESM-P MRI-CGCM3"
pmip3_expts="midHolocene lgm"
for gcm in $pmip3_gcms
do
  for expt in $pmip3_expts
  do
    echo $gcm $expt
    case $expt in 
    midHolocene)
      expt_yr=-6000
      ;;
    lig127k)
      expt_yr=-127000  
      ;;
    lgm)
      expt_yr=-21000
      ;;
    *)
      echo "Unrecognised experiment of: " $expt
      exit
      ;;
    esac    
    if [ -d $ESGF_DIR/$gcm/$expt ] 
    then
      mkdir -p $ESGF_DIR/$gcm/$expt\-$CA_STR
      echo "activity,variable,time_freq,model,experiment,ensemble,grid_label,begdate,enddate,suffix,adj_name,calendar_type,begageBP,endageBP,agestep,begyrCE,nsimyrs,source_path,adjusted_path" > $info_file    
      cd $ESGF_DIR/$gcm/$expt
      ncfiles=`ls -d *mon_*.nc`
      #echo "$ncfiles"
      cd $THIS_DIR
      for ncfile in $ncfiles
      do
        if [ $ncfile != "*.nc" ]; then
          #only include is the file is a regular lat,lon grid (PaleoCalAdjust won't work otherwise)
          #isLatLon $ESGF_DIR/$gcm/$expt $ncfile
          #if [ $? == 1 ]; then
            input_file="$ESGF_DIR/$gcm/$expt/$ncfile"
            output_file=${input_file//$expt/$expt\-$CA_STR}
            if [ $NO_OVERWRITE == "TRUE" ] && [ -f $output_file ]; then 
              #skip over this one
              message=`echo "Not overwriting "$output_file`
              # echo $message
            else
              #manipulate string
              no_nc=`echo ${ncfile%.nc}`
              yr_str=${no_nc##*_}
              prior_str=${no_nc%_*}
              start_yr=`echo $yr_str | cut -c-4`
              end_yr=`echo ${yr_str##*-} | cut -c-4`
              let length=$((10#$end_yr))-$((10#$start_yr))+1
              calendar=`ncdump -h $ESGF_DIR/$gcm/$expt/$ncfile | grep time | grep calendar | cut -d\" -f2`
              #write names into csv file
              # echo `pwd`
              echo 'PMIP3,'${prior_str//_/,},,$start_yr'01',$end_yr'12,,'$CA_STR','$calendar','$expt_yr','$expt_yr',1,1000,'$length',"'$ESGF_DIR/$gcm/$expt'/","'$ESGF_DIR/$gcm/$expt\-$CA_STR'/"' >> $info_file 
            fi
          #fi
        fi
      done
      cat $info_file
      ./cal_adjust_curated
    fi
  done
done


#PMIP4
pmip4_gcms="ACCESS-ESM1-5 AWI-ESM CESM2 CNRM-CM6-1 FGOALS-f3-L FGOALS-g3 GISS-E2-1-G HadGEM3-GC31 INM-CM4-8 IPSL-CM6A-LR LOVECLIM MIROC-ES2L MRI-ESM2-0 NESM3 NorESM1-F NorESM2-LM UofT-CCSM-4"
pmip4_expts="midHolocene lig127k lgm"

for gcm in $pmip4_gcms
do
  for expt in $pmip4_expts
  do
    echo $gcm $expt
    case $expt in 
    midHolocene)
      expt_yr=-6000
      ;;
    lig127k)
      expt_yr=-127000  
      ;;
    lgm)
      expt_yr=-21000
      ;;
    *)
      echo "Unrecognised experiment of: " $expt
      exit
      ;;
    esac    
    if [ -d $ESGF_DIR/$gcm/$expt ] 
    then
      mkdir -p $ESGF_DIR/$gcm/$expt\-$CA_STR
      echo "activity,variable,time_freq,model,experiment,ensemble,grid_label,begdate,enddate,suffix,adj_name,calendar_type,begageBP,endageBP,agestep,begyrCE,nsimyrs,source_path,adjusted_path" > $info_file    
      cd $ESGF_DIR/$gcm/$expt
      ncfiles=`ls -d *mon_*.nc`
      #echo "$ncfiles"
      cd $THIS_DIR
      for ncfile in $ncfiles
      do
        if [ $ncfile != "*.nc" ]; then
          #only include is the file is a regular lat,lon grid (PaleoCalAdjust won't work otherwise)
          #isLatLon $ESGF_DIR/$gcm/$expt $ncfile
          #if [ $? == 1 ]; then
            input_file="$ESGF_DIR/$gcm/$expt/$ncfile"
            output_file=${input_file//$expt/$expt\-$CA_STR}
            if [ $NO_OVERWRITE == "TRUE" ] && [ -f $output_file ]; then 
              #skip over this one
              message=`echo "Not overwriting "$output_file`
              # echo $message
            else
              #manipulate string
              echo $input_file $output_file
              no_nc=`echo ${ncfile%.nc}`
              yr_str=${no_nc##*_}
              prior_str=${no_nc%_*}
              echo $prior_str
              start_yr=`echo $yr_str | cut -c-4`
              end_yr=`echo ${yr_str##*-} | cut -c-4`
              let length=$((10#$end_yr))-$((10#$start_yr))+1
              calendar=`ncdump -h $ESGF_DIR/$gcm/$expt/$ncfile | grep time: | grep calendar | cut -d\" -f2`
              #write names into csv file
              # echo `pwd`
              echo 'PMIP4,'${prior_str//_/,},$start_yr'01',$end_yr'12,,'$CA_STR','$calendar','$expt_yr','$expt_yr',1,1000,'$length',"'$ESGF_DIR/$gcm/$expt'/","'$ESGF_DIR/$gcm/$expt\-$CA_STR'/"'
              echo 'PMIP4,'${prior_str//_/,},$start_yr'01',$end_yr'12,,'$CA_STR','$calendar','$expt_yr','$expt_yr',1,1000,'$length',"'$ESGF_DIR/$gcm/$expt'/","'$ESGF_DIR/$gcm/$expt\-$CA_STR'/"' >> $info_file 
            fi
          #fi
        fi
      done
      cat $info_file
      ./cal_adjust_curated
    fi
  done
done
