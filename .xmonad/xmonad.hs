import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Util.SpawnOnce

main = do
    xmproc <- spawnPipe "xmobar"

    xmonad $ docks defaultConfig
        { manageHook = manageDocks <+> manageHook defaultConfig
        , layoutHook = avoidStruts  $  layoutHook defaultConfig
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppTitle = xmobarColor "green" "" . shorten 50
                        }
        , startupHook        = myStartupHook
        , modMask = mod4Mask -- Rebind Mod to the Windows key
	, terminal = "alacritty"
        , focusedBorderColor = "#B45BCF"
	, normalBorderColor  = "#000000"
        } `additionalKeys`
        [ ((mod4Mask .|. shiftMask, xK_z), spawn "xfce4-screensaver-command -a")
        , ((controlMask, xK_j), spawn "pulseaudio-ctl up")
        , ((controlMask, xK_k), spawn "pulseaudio-ctl down")
        
        ]

myStartupHook = do
                spawnOnce "nitrogen --restore &"
                spawnOnce "picom &"
		spawnOnce "xinput set-prop 12 322 1 &"
