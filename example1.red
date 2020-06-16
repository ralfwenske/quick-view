Red [    File: %example1.red    Purpose: {demo quick-view (q-v)}    ]
github-url: https://raw.githubusercontent.com/ralfwenske/quick-view/master/
#include rejoin [github-url %q-v.red]
get-img: func [os][load rejoin [github-url %example1- os %.jpg]]
v: q-v/duplicate     ;context for window with   top right bottom left center   -panels
v/window/size: 1150x750
v/add-style [style a-fxd-red: a-fxd font-color red font-size 12 ]             ;a-fxd --> area fixed 

v/pane v/top compose [                                          ;put VID into top pane
    t-fxd "%example1.red" black font-size 30 font-color yellow  ;t-fxd --> text fixed  
        react [face/offset: as-pair ((v/top/size/x - face/size/x) / 2) 05] ;keep centered
]; top panel--------------------------------------------------------------
v/pane v/left [ below
    button "<" [v/change-width 'left -10]
    button ">" [v/change-width 'left +10]
]; left panel-------------------------------------------------------------
v/pane v/center compose/deep [                                               ;VID into center pane
    at 5x0 tab-panel [
        "Source" [at 0x0 editor: a-fxd-red react [face/size: v/center/size - 0x55]]
        "on Mac" [image (get-img 'mac) react [face/size: v/center/size - 30x55]]
        "on W10" [image (get-img 'w10) react [face/size: v/center/size - 30x55]]
        "on GTK" [image (get-img 'gtk) react [face/size: v/center/size - 30x55]]
    ] react [face/size: v/center/size]
]; center panel-----------------------------------------------------------
v/pane v/bottom compose [
    at 10x4 t-fxd (v/about) font-color yellow
    t-fxd (now/date) yellow
        react [ face/offset: as-pair (v/bottom/size/x - face/size/x - 30) 4]
]; bottom panel-----------------------------------------------------------

editor/text: read %example1.red
view/flags v/window 'resize