{ config, xdg, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "zdych";
  home.homeDirectory = "/home/zdych";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # basic cli utils
    micro
    neofetch
    alacritty
    fuzzel
    nixfmt
    xdg-utils

    # window manager utils
    gnome3.seahorse
    gnome.eog
    gnome.adwaita-icon-theme
    dunst
    waybar
    font-awesome
    swaybg
    wlsunset
    wlogout
    gnome.nautilus
    monitor
    grim
    slurp
    pamixer
    playerctl
    brightnessctl

    # gui apps
    vscode
    librewolf
    webcord
    lollypop
    obs-studio
    obsidian
  ];

  #programs.gnome-keyring.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

  };

  # fix waybar for hyprland
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];

  xdg.mime.enable = true;

  xdg.configFile."fish/config.fish".text = ''
    if status is-interactive
    # Commands to run in interactive sessions can go here
    end

    # clear greeting message
    set fish_greeting (date)

    # autostart hyprland on tt1 when alacritty is not used
    if test "$XDG_VTNR" = "1"
    if test "$TERM" != "alacritty"
    dbus-run-session Hyprland
    end
    end
  '';

  xdg.configFile."hypr/hyprland.conf".text = ''
    # define desktop monitors
    monitor = DP-1, 3440x1440@144, 1920x0, 1
    monitor = DP-3, 1920x1080@75, 0x200, 1

    # Execute your favorite apps at launch
    exec-once = systemctl --user start polkit-gnome-authentication-agent-1.service
    exec-once = waybar

    # execute swaybg to display wallpaper
    exec-once = swaybg -i ~/img/wallpaper/bg01.jpg -m fill

    # night light
    exec-once = wlsunset -l 50 -L 14.4

    # Super key
    $modkey = SUPER

    # default terminal
    $terminal = alacritty

    # default app launcher
    $launcher = fuzzel

    # czech keyboard layout
    $oneCZ = plus
    $twoCZ = ecaron
    $threeCZ = scaron
    $fourCZ = ccaron
    $fiveCZ = rcaron
    $sixCZ = zcaron
    $sevenCZ = yacute
    $eightCZ = aacute
    $nineCZ = iacute
    $zeroCZ = eacute

    # basic bindings
    bind = $modkey, M, exit, # exists hyprland
    bind = $modkey, Space, exec, $launcher # opens app launcher
    bind = $modkey, Return, exec, $terminal # spawn terminal with super+enter
    bind = $modkey, Q, killactive, # kill currently focused window
    bind = $modkey, E, exec, nautilus --new-window
    bind = $modkey, R, exec, hyprctl reload

    # Move focus with mainMod + arrow keys
    bind = $modkey, left, movefocus, l
    bind = $modkey, right, movefocus, r
    bind = $modkey, up, movefocus, u
    bind = $modkey, down, movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = $modkey, $oneCZ, workspace, 1
    bind = $modkey, $twoCZ, workspace, 2
    bind = $modkey, $threeCZ, workspace, 3
    bind = $modkey, $fourCZ, workspace, 4
    bind = $modkey, $fiveCZ, workspace, 5
    bind = $modkey, $sixCZ, workspace, 6
    bind = $modkey, $sevenCZ, workspace, 7
    bind = $modkey, $eightCZ, workspace, 8
    bind = $modkey, $nineCZ, workspace, 9
    bind = $modkey, $zeroCZ, workspace, 10

    bind = $modkey, KP_END, workspace, 1
    bind = $modkey, KP_DOWN, workspace, 2
    bind = $modkey, KP_NEXT, workspace, 3
    bind = $modkey, KP_LEFT, workspace, 4
    bind = $modkey, KP_BEGIN, workspace, 5
    bind = $modkey, KP_RIGHT, workspace, 6
    bind = $modkey, KP_HOME, workspace, 7
    bind = $modkey, KP_UP, workspace, 8
    bind = $modkey, KP_PRIOR, workspace, 9
    bind = $modkey, KP_INSERT, workspace, 10

    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $modkey SHIFT, $oneCZ, movetoworkspace, 1
    bind = $modkey SHIFT, $twoCZ, movetoworkspace, 2
    bind = $modkey SHIFT, $threeCZ, movetoworkspace, 3
    bind = $modkey SHIFT, $fourCZ, movetoworkspace, 4
    bind = $modkey SHIFT, $fiveCZ, movetoworkspace, 5
    bind = $modkey SHIFT, $sixCZ, movetoworkspace, 6
    bind = $modkey SHIFT, $sevenCZ, movetoworkspace, 7
    bind = $modkey SHIFT, $eightCZ, movetoworkspace, 8
    bind = $modkey SHIFT, $nineCZ, movetoworkspace, 9
    bind = $modkey SHIFT, $zeroCZ, movetoworkspace, 10

    bind = $modkey SHIFT, KP_END, movetoworkspace, 1
    bind = $modkey SHIFT, KP_DOWN, movetoworkspace, 2
    bind = $modkey SHIFT, KP_NEXT, movetoworkspace, 3
    bind = $modkey SHIFT, KP_LEFT, movetoworkspace, 4
    bind = $modkey SHIFT, KP_BEGIN, movetoworkspace, 5
    bind = $modkey SHIFT, KP_RIGHT, movetoworkspace, 6
    bind = $modkey SHIFT, KP_HOME, movetoworkspace, 7
    bind = $modkey SHIFT, KP_UP, movetoworkspace, 8
    bind = $modkey SHIFT, KP_PRIOR, movetoworkspace, 9
    bind = $modkey SHIFT, KP_INSERT, movetoworkspace, 10

    # Toggle fullscreen
    bind = $modkey, F, Fullscreen

    bind = , Print, exec, grim -g "$(slurp)" "/home/zdych/Pictures/Printscreens/$(date +%Y-%m-%d_%H-%M-%S).png"

    # Lock menu
    bind = $modkey, L, exec, wlogout
    # Scroll through existing workspaces with mainMod + scroll
    bind = $modkey, mouse_down, workspace, m+1
    bind = $modkey, mouse_up, workspace, m-1

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $modkey, mouse:272, movewindow
    bindm = $modkey, mouse:273, resizewindow

    # resizing window
    binde = $modkey, I, resizeactive,10 0
    binde = $modkey, U, resizeactive,-10 0
    binde = $modkey, O, resizeactive,0 -10
    binde = $modkey, P, resizeactive,0 10

    # switch keyboard layout to us
    bind = $modkey, K, exec, setxkbmap us

    # sound control
    binde = , XF86AudioLowerVolume, exec, pamixer -d 5 # lower
    binde = , XF86AudioRaiseVolume, exec, pamixer -i 5 # higher
    bind = , XF86AudioMute, exec, pamixer -t # toggle mutes
    bind = , XF86AudioPlay, exec, playerctl play-pause
    bind= , XF86AudioNext, exec, playerctl next
    bind= , XF86AudioPrev, exec, playerctl previous

    bind = CTRL ALT, DELETE, exec, gnome-system-monitor
    bind = CTRL SHIFT, ESCAPE, exec, gnome-system-monitor


    # brightness control
    binde = , XF86MonBrightnessDown, exec, brightnessctl set 20- # lower
    binde = , XF86MonBrightnessUp, exec, brightnessctl set +20 # higher

    input {
    kb_layout = cz,us
    kb_variant =
    kb_model =
    kb_options = grp:alt_shift_toggle
    kb_rules =
    # numlock by default
    numlock_by_default = true

    follow_mouse = 1

    touchpad {
    natural_scroll = yes
    }
    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
    }

    general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle
    }

    decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 15
    blur = yes
    blur_size = 8
    blur_passes = 1
    blur_new_optimizations = on

    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
    }

    animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
    }

    dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
    }

    master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
    }

    gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = on
    }

    # Example per-device config$modkey
    # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
    device:epic-mouse-v1 {
    sensitivity = -0.5
    }
  '';

  xdg.configFile."waybar/config".text = ''
    {
    "margin-left": 4,
    "margin-right": 4,
    "margin-top": 4,
    "spacing": 4, // Gaps between modules (4px)
    "modules-left": ["wlr/workspaces", "custom/media","hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["idle_inhibitor", "pulseaudio", "network", "cpu", "memory", "backlight", "keyboard-state", "tray",
    "battery", "custom/logoutmenu"],
    "keyboard-state": {
    "numlock": true,
    "capslock": true,
    "format": "{name} {icon}",
    "format-icons": {
    "locked": "",
    "unlocked": ""
    }
    },
    "custom/power": {
    "format": "x",
    "on-click": "wlogout",
    },
    "wlr/workspaces": {
    "format": "{icon}"
    },
    "idle_inhibitor": {
    "format": "{icon}",
    "format-icons": {
    "activated": "",
    "deactivated": ""
    }
    },
    "tray": {
    // "icon-size": 21,
    "spacing": 10
    },
    "clock": {
    "format": "{:%H:%M:%S %d.%m.%Y}",
    "interval": 1,
    "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
    "format-alt": "{:%Y-%m-%d}"
    },
    "cpu": {
    "format": "{usage}% ",
    "tooltip": false
    },
    "memory": {
    "format": "{}% "
    },
    "temperature": {
    // "thermal-zone": 2,
    // "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input",
    "critical-threshold": 80,
    // "format-critical": "{temperatureC}°C {icon}",
    "format": "{temperatureC}°C {icon}",
    "format-icons": ["", "", ""]
    },
    "backlight": {
    // "device": "acpi_video1",
    "format": "{percent}% {icon}",
    "format-icons": ["", "", "", "", "", "", "", "", ""]
    },
    "battery": {
    "states": {
    // "good": 95,
    "warning": 30,
    "critical": 15
    },
    "format": "{capacity}% {icon}",
    "format-charging": "{capacity}% ",
    "format-plugged": "{capacity}% ",
    "format-alt": "{time} {icon}",
    // "format-good": "", // An empty format will hide the module
    // "format-full": "",
    "format-icons": ["", "", "", "", ""]
    },
    "battery#bat2": {
    "bat": "BAT2"
    },
    "network": {
    // "interface": "wlp2*", // (Optional) To force the use of this interface
    "format-wifi": "{essid} ({signalStrength}%) ",
    "format-ethernet": "{ipaddr}/{cidr} ",
    "tooltip-format": "{ifname} via {gwaddr} ",
    "format-linked": "{ifname} (No IP) ",
    "format-disconnected": "Disconnected ⚠",
    "format-alt": "{ifname}: {ipaddr}/{cidr}"
    },
    "pulseaudio": {
    // "scroll-step": 1, // %, can be a float
    "format": "{volume}% {icon} {format_source}",
    "format-bluetooth": "{volume}% {icon} {format_source}",
    "format-bluetooth-muted": " {icon} {format_source}",
    "format-muted": " {format_source}",
    "format-source": "{volume}% ",
    "format-source-muted": "",
    "format-icons": {
    "headphone": "",
    "hands-free": "",
    "headset": "",
    "phone": "",
    "portable": "",
    "car": "",
    "default": ["", "", ""]
    },
    "on-click": "pavucontrol"
    },
    "custom/media": {
    "format": "{icon} {}",
    "return-type": "json",
    "max-length": 40,
    "format-icons": {
    "spotify": "",
    "default": "🎜"
    },
    "escape": true,
    "exec": "$HOME/.config/waybar/mediaplayer.py 2> /dev/null" // Script in resources folder
    // "exec": "$HOME/.config/waybar/mediaplayer.py --player spotify 2> /dev/null" // Filter player based on name
    },
    "custom/logoutmenu": {
    "format": "",
    "on-click": "hyprctl dispatch exec wlogout"
    }
    }
  '';
  xdg.configFile."waybar/style.css".text = ''
    * {
    /* `otf-font-awesome` is required to be installed for icons */
    font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
    font-size: 15px;
    border-radius: 10px;
    }

    window#waybar {
    background-color: rgb(27, 27, 27);
    color: #ffffff;
    transition-property: background-color;
    transition-duration: .5s;
    }

    window#waybar.hidden {
    opacity: 0.2;
    }

    window#waybar.termite {
    background-color: #3F3F3F;
    }

    window#waybar.chromium {
    background-color: #000000;
    border: none;
    }

    button {
    /* Use box-shadow instead of border so the text isn't offset */
    box-shadow: inset 0 -3px transparent;
    /* Avoid rounded borders under each button name */
    border: none;
    border-radius: 0;
    }

    /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
    button:hover {
    background: inherit;
    box-shadow: inset 0 -3px #ffffff;
    }


    #mode {
    background-color: #64727D;
    border-bottom: 3px solid #ffffff;
    }

    #clock,
    #battery,
    #cpu,
    #memory,
    #disk,
    #temperature,
    #backlight,
    #network,
    #pulseaudio,
    #wireplumber,
    #custom-media,
    #tray,
    #mode,
    #idle_inhibitor,
    #scratchpad,
    #language,
    #mpd {
    padding: 4px;
    color: #ffffff;
    /* border-radius: 5px; */
    /* background: rgb(2, 92, 116); */
    margin: 4px;
    }

    #window,
    #workspaces {
    margin: 0 4px;
    }

    #workspaces button.active {
    background-color: #ffffff;
    color: #000000;
    }

    .modules-left, .modules-right, .modules-center {
    margin-left: 25px;
    margin-right: 25px;
    }

    /* If workspaces is the leftmost module, omit left margin */
    .modules-left > widget:first-child > #workspaces {
    margin-left: 0;
    }

    /* If workspaces is the rightmost module, omit right margin */
    .modules-right > widget:last-child > #workspaces {
    margin-right: 0;
    }

    #clock {
    font-weight: bold;
    }


    #temperature {
    background-color: #fa485f;
    }

    #temperature.critical {
    background-color: #ba2e18;
    }
  '';

  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    # The main section contains general options for fuzzel
    [main]
    # The font to use, in fontconfig format
    font=monospace:size=20
    # The prompt to use
    prompt=>
    # The icon theme to use
    icon-theme=hicolor
    # Whether to enable icons or not
    icons-enabled=yes
    fuzzy=yes

    # The colors section contains options for colors and themes
    [colors]
    # The background color of the window, in hex format
    background=333333ff
    # The foreground color of the window, in hex format
    text=ffffffff
    # The background color of the selected entry, in hex format
    selection=555555ff
    # The foreground color of the selected entry, in hex format
    selection-text=fa2a2aff
  '';

  xdg.configFile."alacritty/alacritty.yml".text = ''
    window:
    opacity: 0.8
  '';

  # You can also manage environment variables but you will have to manually
  # source
  #
  # ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  # /etc/profiles/per-user/zdych/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
