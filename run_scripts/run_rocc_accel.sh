#!/bin/bash

library="/c/questasim_10.0b/win32/vlib.exe"
compile="/c/questasim_10.0b/win32/vlog.exe"
sim="/c/questasim_10.0b/win32/vsim.exe"

LOG="../log/"
if [ -d "$LOG" ]; then
  # Take action if $LOG_DIR exists. #
  echo "LOG DIR EXISTS...NOT CREATING"
else
  mkdir $LOG
  echo "CREATED LOG DIR"
fi

TRASH="../trash/"
if [ -d "$TRASH" ]; then
	# 
	echo "TRASH EXISTS...NOT CREATING"
	rm -rf $TRASH/*
	echo "REMOVED EXISTING FILES FROM TRASH"
else
	mkdir $TRASH
	echo "CREATED TRASH"
	rm -rf $TRASH/*
	echo "REMOVED EXISTING FILES FROM TRASH"
fi

$library work
$compile -writetoplevels questa.tops -timescale 1ps/1fs -f run_rocc_accel.f 
$sim -f questa.tops -c -do "vsim -voptargs=+acc=npr; run -all; exit" -voptargs=+acc=npr | tee $LOG/log_rocc_accel.txt

mv work $TRASH
mv questa.tops $TRASH
mv dump.vcd $TRASH
mv transcript $TRASH
mv vsim.wlf $TRASH