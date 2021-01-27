import XMonad
import XMonad.Util.SpawnOnce
import XMonad.Util.Run
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Layout
import XMonad.Layout.NoBorders (noBorders, smartBorders)
import XMonad.Layout.Tabbed
import XMonad.Layout.TwoPane
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing

myTerminal      = "termite"
myModMask       = mod4Mask
myBorderWidth   = 2
myWorkspaces    = ["A","B","C","D","E"]
myFocusedColor  = "#ffdd00"
myNormalColor   = "#505050"

main = do
  xmproc <- spawnPipe "xmobar -x 0 /home/eric/.xmobarrc"
  xmonad $ docks def
    { borderWidth = myBorderWidth
     ,terminal    = myTerminal
     ,modMask     = myModMask
     -- Layout
     ,normalBorderColor  = myNormalColor  -- BORDER COLORS
     ,focusedBorderColor = myFocusedColor -- BORDER COLORS
     ,manageHook = myManageHook
     ,layoutHook = myLayoutHook
     ,startupHook = myStartupHook 
    } 

myManageHook :: ManageHook
myManageHook = composeAll 
            [ className =? "Xmessage"  --> doFloat
            , manageDocks
            ]

myTabConfig = def { activeColor = "#556064"
                  , inactiveColor = "#2F3D44"
                  , urgentColor = "#FDF6E3"
                  , activeBorderColor = "#454948"
                  , inactiveBorderColor = "#454948"
                  , urgentBorderColor = "#268BD2"
                  , activeTextColor = "#FFFF00"
                  , inactiveTextColor = "#FFFFFF"
                  , urgentTextColor = "#FFCC00"
                  , fontName = "xft:Hack:size=10:antialias=true"
                  }

myLayoutHook = avoidStruts $
  noBorders (tabbed shrinkText myTabConfig)
  ||| tiled
  ||| twopane

  where
     -- The last parameter is fraction to multiply the slave window heights
     -- with. Useless here.
     tiled = spacing 3 $ ResizableTall nmaster delta ratio []
     -- In this layout the second pane will only show the focused window.
     twopane = spacing 3 $ TwoPane delta ratio
     -- The default number of windows in the master pane
     nmaster = 1
     -- Default proportion of screen occupied by master pane
     ratio   = 1/2
     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

myStartupHook = do
              spawnOnce "setxkbmap br &"
              spawnOnce "picom &"
              spawnOnce "feh --bg-fill /home/eric/Imagens/wpprs/wppr5.jpg &"
