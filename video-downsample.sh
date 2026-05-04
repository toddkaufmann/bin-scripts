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

function backup-processed-videos() {
#     ~/vid.local /Volumes/m4.sync/SYNC/dev-SHARED/infra ~/vid.local/downloads ~/git/personal-scripts ~/git/personal-scripts ~/logs
    # [406]todd@m42_s8 18:26:43 5197  [no py] /Users/todd
    local w4rpi=7
    while ! ssh rpi4 df -h /n/a20b2; do
	echo -n "$(date +%H:%M) wait for rpi4 ";
	sleep $w4rpi
	w4rpi=$((w4rpi+10))
    done
    (cd ~/vid.local;
     rclone copy -v --transfers=1 --max-depth=1 \
	    --exclude '.DJI_*' --exclude '*HDR.mp4' --exclude='I*.mkv' --exclude='*.m3u' \
	    --exclude='*joined.MP4' \
	    . rpi4:/n/a20b2/videos.processed/gyroflow/
    )
    echo Space avail after -
    ssh rpi4 df -h /n/a20b2; 
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

	if $DSPRE ffmpeg -i "$inpfile" \
		  -vf "scale=-2:720" \
		  -c:v libx264 -preset slow -crf 20 \
		  -c:a aac -b:a 160k \
		  "$outfile"; then
	    echo .. "SUCCESS: $outfile"
	else
	    echo .. "FAIL ($?): $outfile" | tee -a downsample-720p.log
	fi
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

# ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function file_ts() {
    date -d "@$(stat -c %Y "$1")" +%Y%m%d.%H%M%S
}
function d4f () { 
    local fn="$1";
    date +"%Y%m%d" -d@$(stat -c '%Y' "$fn")
}

function dmv1() {
    local f="$1"; local d;
    d=$(d4f "$f");
    [[ -f "$f.$(d4f $f)" ]] && return "$f.$(d4f $f)";
    echo " -- already exists, now try with a suffix";
}

################################# 2026-05-02
# update-rpi4-list is a function
function update-rpi4-list () { 
    DEST=rpi4:/media/pi/memir3/st-sync/deluge/data/complete/movies/drone;
    rclone lsl $DEST > rpi4.list
}
# update-aq-list is a function
function update-aq-list () { 
    DEST2=aqe:/n/mir3deluge/SYNC/deluge/data/complete/movies/drone;
    rclone lsl $DEST2 > aq.list
}

# rpi4:/n/a20b2/videos.processed/gyroflow/
function update-processed-list () { 
    DEST3=rpi4:/n/a20b2/videos.processed/gyroflow/
    rclone lsl $DEST3 > processed.list
}
