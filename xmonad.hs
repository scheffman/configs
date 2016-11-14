import XMonad
import qualified XMonad.StackSet as W
import qualified XMonad.Layout.IndependentScreens as LIS
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Fullscreen
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO

--sinkFocus = W.peek >>= maybe id W.sink

-- borders
myBorderWidth :: Dimension
myBorderWidth = 2

myNormalBorderColor, myFocusedBorderColor :: String
myNormalBorderColor = "#FFFFFF"
myFocusedBorderColor = "#0077FF"

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

myLayout = avoidStruts (
    Tall 1 (3/100) (1/2) |||
    Mirror (Tall 1 (3/100) (1/2)) |||
    noBorders (fullscreenFull Full))

myManageHook = composeAll
    [ isFullscreen --> doFullFloat ]

main = do
xmproc <- spawnPipe "/usr/bin/xmobar /home/scheffman/.xmobarrc"
xmonad $ defaultConfig
    { manageHook = manageDocks <+> myManageHook <+> manageHook defaultConfig <+> fullscreenManageHook
    , handleEventHook   = fullscreenEventHook
    , layoutHook        = spacing 3 $ myLayout
    , logHook           = dynamicLogWithPP xmobarPP
                { ppOutput  = hPutStrLn xmproc
                , ppTitle   = xmobarColor "green" "" . shorten 50
                }
    , modMask           = mod4Mask
    , terminal          = "urxvt"
    , focusFollowsMouse = False
    , startupHook       = setWMName "LG3D"
    , workspaces        = myWorkspaces
    , borderWidth       = myBorderWidth
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    }
