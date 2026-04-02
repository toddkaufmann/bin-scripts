#!/bin/bash

# a. rename all current
#     DJI_202510211-TomsRun_joined._720p60.mp4
#     DJI_202510211-TomsRun_stab.720p60.mp4
# 
# b. change this fn
# c. any



function new_name_for_0322() {
    local nom="$1"
    local ret;
    ret=$(echo $nom | sed -e 's/D_joined/joined/; s/joined._720p60/stab.720p60/; ')
    echo "$ret"
}

function downsample-720p() {
    local inpfile="$1"
    local outfile
    # outfile=$(echo "$inpfile" | sed -e 's=mp4$==i; s=_stabilized==;').720p60.mp4

    # before: LawrencevilleFrozenRiver_D_joined_stabilized.mp4
    #  after: LawrencevilleFrozenRiver_stab.729p60.mp4
    
    outfile=$(echo "$inpfile" | sed -e 's=.mp4$==i; s=D_joined=joined=; s=joined_stabilized=stab=;').720p60.mp4
    if [[ -f "$outfile" ]]; then
	echo " *** warning exists - $outfile ****"
	sleep .5
    else
	read -p "input=$inpfile,  output will be $outfile  .. ok or ^C " -t 3 _

	$DSPRE ffmpeg -i "$inpfile" \
	  -vf "scale=-2:720" \
	  -c:v libx264 -preset slow -crf 20 \
	  -c:a aac -b:a 160k \
	  "$outfile"
    fi
}

function downsample-720p-loop() {
    for vid in $(find . -name '*zed.mp4' | grep -v EastL); do
	time downsample-720p "$vid";
    done
}


# 30fps
function cm2() {
    echo impl
}
# lower bitrate
function cm3() {
    echo impl
}
# hw1
function cm4() {
    echo impl
}

# hw2
function cm5() {
    echo impl
}

