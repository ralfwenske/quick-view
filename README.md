# quick-view
 
Experimental: changes are likely.
I also would appreciate suggestions to improve and make the code more 'Red' like.
My aim (besides having fun exploring Red) is to be able to quickly have a visual
interface where I can show results of my data processing - without getting lost
in presentation logic and pixel counting...
... and perhaps achieve the same for others - beginners and experts - who so 
generously share their tools and coding insights.

Purpose:
q-v allows to create a GUI with 5 panels.
A fully working graphical user interface with a few lines of
(hopefully self explaining) code:
    Resizable (the window or outer panels)
    Dialog preventing data loss if accidental quitting
    Easy identifying of panels: top right bottom left center

```
Red []
#include %q-v.red
v: q-v/duplicate
view/flags v/window 'resize
```
![alt default view](.view-default.jpg)
- - - -

Outer panel's width can be set with /widths [t r b l]
```
Red []
#include %q-v.red
v: q-v/duplicate/widths [50 50 30 80]
v/window/size: 400x200
view/flags v/window 'resize
```
![alt default view](.view-widths.jpg) ![alt default view](.view-resized.jpg)
- - - -

Determine panels width: the order determines their extent:
```
Red []
#include %q-v.red
v: q-v/duplicate/order [l r t b]
v/window/text: "Quick View Demo"    ;title
view/flags v/window 'resize
```
![alt default view](.view-order.jpg) 
- - - -

%example1.red shows how to place VID code into the panels 
and show how user interaction can be coded
Here the MacOS version:
![alt default view](example1-mac.jpg) 


NOTE:
    
    There are some unexpected things that remind us of the Alpha-status of Red.

    The `area` face when resizing behaves differently on each platform.

    The `text` face on Windows misbehaves.

    Font size seems different on Windows. (Font is "Courier")

    On GTK when a menu is shown the viewable size is not adjusted.