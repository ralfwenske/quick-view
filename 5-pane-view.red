Red [ author: "Gregg Irwin"]

_5-panes-ctx: context [
	layout-spec: none									; layout spec we build
	p-top: p-left: p-center: p-right: p-bottom: none    ; area panels

	def-panel-sizes: [top 50 left 200 right 150 bottom 25]
	sizes: []											; panel sizes used in layout

	win-sizes: compose [								;!! may be better to separate default
		default 900x600
		min     640x480
		max     (system/view/screens/1/size)
	]
	
	panel-layouts: [
		top    [text bold "TBD: top"]
		left   [text bold "TBD: left"]
		center [text bold "TBD: center"]
		right  [text bold "TBD: right"]
		bottom [text bold "TBD: bottom"]
	]
	
	init: func [/local w-sz p-mid-x p-mid-y] [
		sizes: append copy sizes def-panel-sizes	; put user sizes ahead of defaults

		w-sz: win-sizes/default						; shortcuts for layout composition
		p-mid-y: w-sz/y - sizes/top - sizes/bottom
		p-mid-x: w-sz/x - sizes/left - sizes/right
		
		layout-spec: compose/only [
			size (w-sz)
			origin 0x0
			space 0x0
			p-top:    panel sky    (as-pair w-sz/x sizes/top)    (panel-layouts/top)    return
			p-left:   panel gray   (as-pair sizes/left p-mid-y)  (panel-layouts/left) 
			p-center: panel silver (as-pair p-mid-x p-mid-y)     (panel-layouts/center) 
			p-right:  panel water  (as-pair sizes/right p-mid-y) (panel-layouts/right)  return
			p-bottom: panel wheat  (as-pair w-sz/x sizes/bottom) (panel-layouts/bottom) 
		]
	]
	
]

make-_5-panes-view: function [spec [block!]][
	v: make _5-panes-ctx spec
	v/init
	lay: layout v/layout-spec
	if spec/menu [
		lay/menu: spec/menu
	]
	lay
]

;-------------------------------------------------------------------------------
;-- Examples

view _5pv: make-_5-panes-view []

view _5pv: make-_5-panes-view [
	sizes: [top 75 left 250 right 0]
]

view _5pv: make-_5-panes-view [
	win-sizes: [default 640x480]
	sizes: [left 50 top 200 right 200 bottom 0]
]

view _5pv: make-_5-panes-view [
	menu: [
		"File" [
			"New"				new
			"Open...	F1"		open
			"Close	F2"			close 
			---
			"Save..."			save
			"Save as..."		save-as
			"Save All"			save-all
			---
			"Print..."			print
			"Preview"			preview
			"Page Setup..."		page-setup
			---
			"Exit"				exit
		]
	]
	panel-layouts: compose/deep [
		top    [
			text "%example1.red" black font-size 20 font-color yellow
		]
		left   [
			below
			button "<" ;[v/change-width 'left -10]
			button ">" ;[v/change-width 'left +10]
		]
		center [text bold "TBD: center"]
		right  [text bold "TBD: right"]
		bottom [
			across
			text (mold system/version) font-color brick
			text (now/date) yellow
		]
	]
]