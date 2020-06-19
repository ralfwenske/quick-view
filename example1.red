Red [    File: %example1.red    Purpose: {demo quick-view (q-v)}    ]
#include %q-v.red

;CREATE THE 5-PANEL VIEW ------------------------------------------------
v: make q-v []
v/init [                     ;each of following can be omitted
    w-size: 1150x750                ;window size
    w-limits: [1000x500 1300x900]   ;min max window size   atm. use view if set
    sizes: [top 100 right 20 ]      ;panel widths. 
    order: [t b l r]                ;panels claim available space in this order
    title: "DEMO %example1.red"     ;window title
]
v/menu ["File" [                 ; optional
    "Load Text"  [load-editor]   ; different to system/layout !! no submenus!
    "Save Text"  [save-editor]   
    --- --
    "Quit" [if v/confirm-quit [unview]]
    ]
    "About" [
        "Author"  [log/text: "by Ralf Wenske May 2020"]
    ]
] 

;FILL IT WITH LIFE ------------------------------------------------------
images: [] foreach os ['mac 'w10 'gtk] [append images do load rejoin [%example1- os %.jpg]]

load-editor: func [][log/text: "Dummy loaded" confirm-quit-text: ""]
save-editor: func [][log/text: "Dummy saved" confirm-quit-text: ""]

v/add-style [style a-fxd-blue: a-fxd font-color blue font-size 12 ] ;a-fxd --> area fixed 

v/pane v/top compose [                                          ;put VID into top pane
    chk: check "left panel"  true [v/visible 'left chk/data]
    t-fxd "%example1.red" black font-size 30 font-color yellow  ;t-fxd --> text fixed  
        react [face/offset: as-pair ((v/top/size/x - face/size/x) / 2) 05] ;keep centered
]; top panel--------------------------------------------------------------

v/pane v/left [ below
    button "<" [v/change-width 'left -10]
    button ">" [v/change-width 'left +10]
]; left panel-------------------------------------------------------------

v/pane v/center compose/deep [                                  
    at 5x0 tab-panel [
        "Source" [at 0x0 editor: a-fxd-blue 
            on-key [confirm-quit-text: "Unsaved Data! QUIT ?"]
                react [face/size: v/center/size - 0x55]
        ]
        "on Mac" [image (images/1) react [face/size: v/center/size - 30x55]]
        "on W10" [image (images/2) react [face/size: v/center/size - 30x55]]
        "on GTK" [image (images/3) react [face/size: v/center/size - 30x55]]
    ] react [face/size: v/center/size]
]; center panel-----------------------------------------------------------

v/pane v/bottom compose [
    at 10x4 log: t-fxd (v/about) font-color yellow
    t-fxd (now/date) yellow
        react [ face/offset: as-pair (v/bottom/size/x - face/size/x - 30) 4]
]; bottom panel-----------------------------------------------------------

confirm-quit-text: ""
editor/text: read rejoin [%example1.red]

;view v/window                   ; no resizing or v/size-limits called
view/flags v/window 'resize    ; if no v/size-limits