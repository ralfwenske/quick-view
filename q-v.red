Red [
    Needs:  'view
    Title:  "q-v"
    File:   %q-v.red
    Author: "Ralf Wenske"
    Date:   11-Jun-2020
    Purpose: {
        create a resizable window with up to 5 panels
        as base for further development
        (q-v --> quick-view)
    }   
]

do q-v: make object! [
    w-size: 900x600
    w-limits: []
    sizes: [top 60 right 30 bottom 30 left 150]
    order: [t b l r]

    dims: [top [0 0 0] right [0 0 0] bottom [0 0 0] left [0 0 0] ]
    sizes-hidden: copy sizes 
    top: right: bottom: left: center: none
    drag-marker: false
    window: none
    styles: [
        style t-fxd: text font-name "Courier New" font-size 14
        style a-fxd: area font-name "Courier New" font-size 14
    ]; styles

    resize: func [][ ;[w /extern top right bottom left center][        
        ;unless object? w  [exit]
        if none = top [exit]
        top/offset:     as-pair (dims/top/1 * sizes/left) 0
        top/size:       as-pair window/size/x - top/offset/x - (dims/top/3 * sizes/right) sizes/top 
        right/offset:   as-pair window/size/x - sizes/right dims/right/1 * sizes/top
        right/size:     as-pair sizes/right window/size/y - right/offset/y - (dims/right/3 * sizes/bottom)
        bottom/offset:  as-pair dims/bottom/1 * sizes/left window/size/y - sizes/bottom
        bottom/size:    as-pair window/size/x - bottom/offset/x - (dims/bottom/3 * sizes/right) sizes/bottom 
        left/offset:    as-pair 0 (dims/left/1 * sizes/top)
        left/size:      as-pair sizes/left window/size/y - left/offset/y - (dims/left/3 * sizes/bottom)
        center/offset:  as-pair sizes/left sizes/top
        center/size:    (as-pair right/offset/x bottom/offset/y) - center/offset
        ;w
    ]; resize

    mix: function [default [block!] mixin [block!]][
        foreach [pnl val] mixin [
            default/:pnl: val
        ]
        default
    ]

    init: func [parms [block!]] [
        if parms/w-size [w-size: parms/w-size]
        if parms/w-limits [w-limits: parms/w-limits]
        if parms/sizes [
            sizes: mix sizes parms/sizes
            sizes-hidden: copy sizes]
        if parms/order [order: parms/order]

        is-set: func [val [integer!]][either val > 0 [1][0]]
        foreach p order [   ;order determines what extent a panel claims
            switch p [
                t [dims/top: reduce [ is-set dims/left/2 sizes/top is-set dims/right/2 ] ]
                r [dims/right: reduce [ is-set dims/top/2 sizes/right is-set dims/bottom/2 ] ]
                b [dims/bottom: reduce [ is-set dims/left/2 sizes/bottom is-set dims/right/2 ] ]
                l [dims/left: reduce [ is-set dims/top/2 sizes/left is-set dims/bottom/2 ] ]
            ]
        ]
        window: layout/tight compose [
            size (w-size)
            panel (w-size) [
                panel gray 
                panel pewter 
                panel gray 
                panel pewter 
                panel yellow 
            ]
                react [
                    if (object? face) [
                        if (object? face/parent)[
                            face/size: face/parent/size
                            resize face/parent
                            ;if  (block? face/parent/extra) [
                            ;    face/size: face/parent/size
                            ;    face/parent/extra/obj/resize face/parent
                            ;    ;resize face/parent
                            ;]
                        ]
                    ]
                ]
        ]
        if parms/title [window/text: parms/title]
        top:      window/pane/1/pane/1 
        right:    window/pane/1/pane/2 
        bottom:   window/pane/1/pane/3 
        left:     window/pane/1/pane/4 
        center:   window/pane/1/pane/5 
        if (length? w-limits) = 2 [
            offs: 10x10
            layout/parent/tight compose/deep [ 
                at (window/size - offs) dragger: base red offs cursor 'hand loose  
                    on-down [system/view/auto-sync?: off ] 
                    on-up   [show face/parent system/view/auto-sync?: on ] 
                    on-drag [
                        face/offset: max (w-limits/1) min (w-limits/2) face/offset 
                        face/parent/size: face/offset + (offs) 
                        show face/parent            
                    ]       
            ]  window none
            drag-marker: true
        ]
    ]; init

    confirm-quit: function [][ 
        txt: ""
        unless unset! = type? :confirm-quit-text [
            txt: confirm-quit-text
        ]
        if txt = "" [
            return true
        ]
        res: none 
        view/flags [size 200x100
            title "Quit application?"
            text txt return 
            button "OK" [res: true unview] 
            button "NO" [res: false unview]
        ][no-buttons  modal popup]
        res
    ]; confirm-quit

    menu: func [menu-src [block!]][
        the-menu: copy []
        the-actors: copy []

        m-ix: 0
        foreach [main sub] menu-src [
            append the-menu main 
            ;append the-menu newline
            blk-a: copy []
            blk-m: copy []
            foreach [nm fc] sub [
                either nm = '--- [
                    append blk-m '---
                ][
                    m-ix: m-ix + 1
                    lb: to-word rejoin ['menu- m-ix]
                    append blk-m reduce [nm lb]
                    append blk-a reduce [lb fc]
                ]
            ]
            append/only the-menu blk-m
            append the-actors copy blk-a                  
        ]

        window/actors: context compose/deep [
            on-menu: func [f e][
                switch e/picked [(the-actors)]
            ]
            on-close: func [f e][
                unless confirm-quit ['continue]
            ]   
        ] 
        ;add-confirm-quit
        window/menu: copy the-menu  
    ]; menu

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
            top [sizes/top: sizes/top + px]
            right [sizes/right: sizes/right + px]
            bottom [sizes/bottom: sizes/bottom + px]
            left [sizes/left: sizes/left + px]
        ]
        sizes-hidden: copy sizes
        resize window
    ]

    visible: func [p yn [logic!]][
        switch p [
            top     [sizes/top:     either yn [sizes-hidden/top][0]]
            right   [sizes/right:   either yn [sizes-hidden/right][0]]
            bottom  [sizes/bottom:  either yn [sizes-hidden/bottom][0]]
            left    [sizes/left:    either yn [sizes-hidden/left][0]]
        ]
        resize window
    ]

    size-limits: function [ min-size [pair!] max-size [pair!]][
        offs: 10x10
        layout/parent/tight compose/deep [ 
            at (window/size - offs) dragger: base red offs cursor 'hand loose  
                on-down [system/view/auto-sync?: off ] 
                on-up   [show face/parent system/view/auto-sync?: on ] 
                on-drag [
                    face/offset: max (min-size) min (max-size) face/offset 
                    face/parent/size: face/offset + (offs) 
                    show face/parent            
                ]       
        ]  window none
        drag-marker: true
    ]; add-drag-marker

    about: does [
        rejoin ["Red " system/version
            " for " system/platform
            " built " system/build/date
        ]
    ]
]; q-v    