# GPU Environment
env = AQ_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1

# Monitors
monitor = eDP-1, 2560x1440@164, 0x0, 1
monitor = HDMI-A-1,1920x1080@75, auto-left, 1

# Workspaces
workspace = 1, monitor:eDP-1, default:true
workspace = 2, monitor:eDP-1
workspace = 3, monitor:eDP-1
workspace = 4, monitor:HDMI-A-1
workspace = 5, monitor:HDMI-A-1
workspace = 6, monitor:HDMI-A-1

#Window Rules
windowrulev2 = pin, class:kitty, workspace:4

# Mouse
#accel_profile=flat

# Autostart apps
exec-once = hyprctl dispatch workspace 1
exec-once = waybar
exec-once = mako
exec-once = wofi
exec-once = wl-clipboard
exec-once = kitty

#Keybinds
bind = LAlt+LShift, S, exec, "grim -g \"$(slurp)\" ~/Pictures/screenshot_$(date +%F_%T).png"
bind = LAlt, t, exec, "kitty"
bind = LAlt, c, exec, "firefox"
bind = LAlt, SPACE, exec, "wofi --show drun"
bind = LAlt, q, forcekillactive
