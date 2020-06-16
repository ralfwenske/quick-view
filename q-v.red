Red [
    Needs:  'view
    Title:  "q-v"
    File:   %q-v.red
    Author: "Ralf Wenske"
    Date:   11-Jun-2020
    Purpose: {
        create a resizable window with up to 5 panels
        as base for further develpment
        (q-v --> quick-view)
    }   
]

q-v: context [
    window: none
    top: right: bottom: left: center: none
    w-size: 900x600
    sizes: [60 30 30 150]
    dims: [ [0 0 0] [0 0 0] [0 0 0] [0 0 0] ] ; top right bottom left
    styles: [
        style t-fxd: text font-name "Courier" font-size 14
        style a-fxd: area font-name "Courier" font-size 14
    ]; styles

    resize: function [w /extern top right bottom left center][        
        unless object? w  [exit]
        top/offset:     as-pair (dims/1/1 * sizes/4) 0
        top/size:       as-pair w/size/x - top/offset/x - (dims/1/3 * sizes/2) sizes/1 
        right/offset:   as-pair w/size/x - sizes/2 dims/2/1 * sizes/1
        right/size:     as-pair sizes/2 w/size/y - right/offset/y - (dims/2/3 * sizes/3)
        bottom/offset:  as-pair dims/3/1 * sizes/4 w/size/y - sizes/3
        bottom/size:    as-pair w/size/x - bottom/offset/x - (dims/3/3 * sizes/2) dims/3/2 
        left/offset:    as-pair 0 (dims/4/1 * sizes/1)
        left/size:      as-pair sizes/4 w/size/y - left/offset/y - (dims/4/3 * sizes/3)
        center/offset:  as-pair sizes/4 sizes/1
        center/size:    (as-pair right/offset/x bottom/offset/y) - center/offset
        w
    ]; resize

    duplicate: func [/widths width-blk [block!] /order o [block!] /local v][
        v: copy q-v
        if widths [
            v/sizes: copy width-blk
        ]
        unless order [
            o: [t b l r]        ;default: top bottom left right
        ]
        is-set: func [val [integer!]][either val > 0 [1][0]]
        foreach p o [ 
            switch p [
                t [v/dims/1: reduce [ is-set v/dims/4/2 v/sizes/1 is-set v/dims/2/2 ] ]
                r [v/dims/2: reduce [ is-set v/dims/1/2 v/sizes/2 is-set v/dims/3/2 ] ]
                b [v/dims/3: reduce [ is-set v/dims/4/2 v/sizes/3 is-set v/dims/2/2 ] ]
                l [v/dims/4: reduce [ is-set v/dims/1/2 v/sizes/4 is-set v/dims/3/2 ] ]
                {
                t [v/dims/1: reduce [ v/dims/4/2 v/sizes/1 v/dims/2/2 ] ]
                r [v/dims/2: reduce [ v/dims/1/2 v/sizes/2 v/dims/3/2 ] ]
                b [v/dims/3: reduce [ v/dims/4/2 v/sizes/3 v/dims/2/2 ] ]
                l [v/dims/4: reduce [ v/dims/1/2 v/sizes/4 v/dims/3/2 ] ]
                }
            ]
        ]

        v/window: layout/tight compose [
            size (v/w-size)
            panel (v/w-size) [
                panel gray 
                panel pewter 
                panel gray 
                panel pewter 
                panel yellow 
            ]
                react [
                    if (object? face) [
                        if (object? face/parent)[
                            if  (block? face/parent/extra) [
                                face/size: face/parent/size
                                face/parent/extra/obj/resize face/parent
                                ;self/resize face/parent
                            ]
                        ]
                    ]
                ]
        ]
        v/top:      v/window/pane/1/pane/1 
        v/right:    v/window/pane/1/pane/2 
        v/bottom:   v/window/pane/1/pane/3 
        v/left:     v/window/pane/1/pane/4 
        v/center:   v/window/pane/1/pane/5 
        v/window/extra: [obj: none]
        v/window/extra/obj: v
        v
    ]; duplicate

    add-style: func [newstyle [block!]][
        append styles newstyle
    ]; add-style

    pane: func [p [object!] content [block!]][
        blk: copy styles
        append blk content
        p/pane: layout/only/parent blk p none
    ]; pane

    change-width: func [p px [integer!]][
        switch p [
            top [v/sizes/1: v/sizes/1 + px]
            right [v/sizes/2: v/sizes/2 + px]
            bottom [v/sizes/3: v/sizes/3 + px]
            left [v/sizes/4: v/sizes/4 + px]
        ]
        resize v/window
    ]

    about: does [
        rejoin ["Red " system/version
            " for " system/platform
            " built " system/build/date
        ]
    ]

]; q-v    
