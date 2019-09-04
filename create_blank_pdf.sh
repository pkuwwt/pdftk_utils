#!/bin/bash

# create_blank width height dpi out.pdf
create_blank() {
	echo showpage | ps2pdf -g${1}x${2} -r${3} - ${4}
}

# mm_to_pt mm
mm_to_pt() {
	echo "scale=4;$1*72/25.4" | bc -l
}

# 1inch = 72pt = 25.4mm
mm_to_in() {
	echo "scale=4;$1/25.4" | bc -l
}

pt_to_mm() {
	echo "scale=4;$1*25.4/72" | bc -l
}

# pt_to_px pt dpi
pt_to_px() {
	echo "scale=0;$1*$2/72" | bc -l
}

# mm_to_px mm dpi
mm_to_px() {
	pt_to_px `mm_to_pt $1` $2
}

# 1inch = 72pt = 25.4mm
unit_to_mm() {
	case $1 in
		*inch) inch_to_mm $1;;
		*pt) pt_to_mm $1;;
		*mm) echo ${1%%mm};;
		*) >&2 echo "Not a unit: $1";;
	esac
}

# unit_to_pixel 135mm dpi
# unit_to_pixel 10in dpi
# unit_to_pixel 10pt dpi
unit_to_px() {
	mm_to_px `unit_to_mm $1` $2
}

# print_unit 10mm
print_unit() {
	mm=`unit_to_mm $1`
	pt=`mm_to_pt $mm`
	in=`mm_to_in $mm`
	echo "${mm}mm/${pt}pt/${in}inch"
}


program=$0
help() {
	echo "USAGE: $program width height [out.pdf [dpi=720]]"
	echo "Example:"
	echo "   $program 135mm 235mm out.pdf"
	echo "   $program 10in 23in out.pdf"
	echo "   $program 1000px 2300px out.pdf"
}

if (( $# < 2 )); then
	help
	exit 1
fi

dpi=${4:-720}
width=`unit_to_px $1 $dpi`
height=`unit_to_px $2 $dpi`
out=${3:-out.pdf}

echo "Create a blank pdf with width=`print_unit $1` height=`print_unit $2` dpi=${dpi} output=${out}"
create_blank $width $height $dpi $out

