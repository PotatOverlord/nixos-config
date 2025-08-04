{ inputs, config, lib, pkgs, userSettings, systemSettings, ... }: let 
  pkgs-hyprland = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ../app/terminal/alacritty.nix
  ];


  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = if (config.stylix.polarity == "light") then "Quintom_Ink" else "Quintom_Snow";
    size = 36;
  };

  wayland.windowManager.hyprland = {
  enable = true;
  package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  plugins = [ ];
  settings = {
    bind = [
    # Generic binds
    "SUPER, Q, exec, ${userSettings.term}"
    "SUPER, C, killactive"
    "SUPER, E, exec, ranger"
    "SUPER, V, togglefloating"
    "SUPER, R, exec, rofi -show drun"
    "SUPER, J, togglesplit"
    "SUPER, W, exec,${userSettings.browser}"
    "SUPER, A, exec, vesktop"
    "SUPER, F, fullscreen"
    "SUPER, P, pin"

    # opaque toggle
    "SUPER, T, exec, hyprctl dispatch setprop active opaque toggle lock"

    # Screencap stuff TODO: put in app name to file
    # shift - slurp  ctrl - clipboard  alt - screenrec  SUPER - end screenrec
    ", Print, exec, grim $HOME/screenshots/$(date +''%y-%m-%d_%H-%M-%S'')_screenshot.png"
    "SHIFT, Print, exec, grim -g ''$(slurp)'' $HOME/screenshots/$(date +''%y-%m-%d_%H-%M-%S'')_screenshot.png"
    "CTRL, Print, exec, grim - | wl-copy"
    "CTRL SHIFT, Print, exec, grim -g ''$(slurp)'' - | wl-copy"
    "ALT, Print, exec, wf-recorder --audio --file=$HOME/screenshots/$(date +''%y-%m-%d_%H-%M-%S'')_screenrec.mkv "
    "ALT CTRL, Print, exec, wf-recorder -y --audio -f /tmp/fuck-you.mkv && wl-copy < /tmp/fuck-you.mkv "
    "ALT SHIFT, Print, exec, wf-recorder -g ''$(slurp)'' --audio --file=$HOME/screenshots/$(date +''%y-%m-%d_%H-%M-%S'')_screenrec.mkv "
    "ALT CTRL SHIFT, Print, exec, wf-recorder -y -g ''$(slurp)''--audio -f /tmp/fuck-you.mkv && wl-copy < /tmp/fuck-you.mkv"
    "SUPER, Print, exec, killall wf-recorder"

    "SUPER, left, movefocus, l"
    "SUPER, right, movefocus, r"
    "SUPER, up, movefocus, u"
    "SUPER, down, movefocus, d"

    # Example special workspace (scratchpad)
    "SUPER, S, togglespecialworkspace, magic"
    "SUPER SHIFT, S, movetoworkspace, special:magic"
    ]
    ++ (
      # Workspaces
      builtins.concatLists (builtins.genList (i:
        let ws = i + 1;
	in [
          "SUPER, code:1${toString i}, workspace, ${toString ws}"
          "SUPER SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
	]
      )
      9)
    );
    
    bindm = [ # mouse stuff
    # Move/resize windows with mainMod + LMB/RMB and dragging
    "SUPER, mouse:272, movewindow"
    "SUPER, mouse:273, resizewindow"
    ];

    binde = [ # repeats on hold
    # zoom
    "SUPER, equal , exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 1.1}')"
    "SUPER, minus , exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor | awk '/^float.*/ {print $2 * 0.9}')"
    ];

    bindel = [ # above + works in lockscreem
    # Laptop multimedia keys for volume and LCD brightness
    ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
    ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
    ];

    bindl = [ # works in lockscreen
    # Requires playerctl
    ",XF86AudioNext, exec, playerctl next"
    ",XF86AudioPause, exec, playerctl play-pause"
    ",XF86AudioPlay, exec, playerctl play-pause"
    ",XF86AudioPrev, exec, playerctl previous"
    ];

    monitor=",highres,auto,1";
    
    exec-once = [
    "dbus-update-activation-environment --systemd DISPLAY XAUTHORITY WAYLAND_DISPLAY XDG_SESSION_DESKTOP=Hyprland XDG_CURRENT_DESKTOP=Hyprland XDG_SESSION_TYPE=wayland"
    "hyprctl setcursor ${config.gtk.cursorTheme.name} ${toString config.gtk.cursorTheme.size}"

    "nm-applet && blueman-applet"
    "waybar"
    "ydotoold"
    "hyprpaper"
    ];

    env =[
    "XCURSOR_SIZE,12"
    "HYPRCURSOR_SIZE,12"
    ];

    general = {
      gaps_in = 5;
      gaps_out = 20;

      border_size = 2;

      # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
      "col.active_border" = "0xff${config.lib.stylix.colors.base08} 0xff${config.lib.stylix.colors.base09} 0xff${config.lib.stylix.colors.base0A} 0xff${config.lib.stylix.colors.base0B} 0xff${config.lib.stylix.colors.base0C} 0xff${config.lib.stylix.colors.base0D} 0xff${config.lib.stylix.colors.base0E} 0xff${config.lib.stylix.colors.base0F} 270deg";
      "col.inactive_border" = "0xaa${config.lib.stylix.colors.base02}";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = false;

      # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
      allow_tearing = false;

      layout = "dwindle";
    };

    decoration = {
      rounding = 8;
      dim_special = 0.0;
      blur = {
        enabled = true;
        size = 5;
        passes = 2;
        ignore_opacity = true;
        contrast = 1.17;
        brightness = (if (config.stylix.polarity == "dark") then "0.8" else "1.25");

        xray = true;
        special = true;
        popups = true;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#animations
    animations = {
      enabled = "yes, please :)";

	# Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

      bezier = [
      "easeOutQuint,0.23,1,0.32,1"
      "easeInOutCubic,0.65,0.05,0.36,1"
      "linear,0,0,1,1"
      "almostLinear,0.5,0.5,0.75,1.0"
      "quick,0.15,0,0.1,1"
      ];

      animation = [
      "global, 1, 10, default"
      "border, 1, 5.39, easeOutQuint"
      "windows, 1, 4.79, easeOutQuint"
      "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
      "windowsOut, 1, 1.49, linear, popin 87%"
      "fadeIn, 1, 1.73, almostLinear"
      "fadeOut, 1, 1.46, almostLinear"
      "fade, 1, 3.03, quick"
      "layers, 1, 3.81, easeOutQuint"
      "layersIn, 1, 4, easeOutQuint, fade"
      "layersOut, 1, 1.5, linear, fade"
      "fadeLayersIn, 1, 1.79, almostLinear"
      "fadeLayersOut, 1, 1.39, almostLinear"
      "workspaces, 1, 1.94, almostLinear, fade"
      "workspacesIn, 1, 1.21, almostLinear, fade"
      "workspacesOut, 1, 1.94, almostLinear, fade"
      ];
    };

    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    dwindle = {
      pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
      preserve_split = true; # You probably want this
    };

    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    master = {
      new_status = "master";
    };

    # https://wiki.hyprland.org/Configuring/Variables/#input
    input = {
      kb_layout = "gb";
      #kb_variant =
      #kb_model =
      #kb_options =
      #kb_rules =

      follow_mouse = 1;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

      touchpad = {
          natural_scroll = false;
      };
    };

    # https://wiki.hyprland.org/Configuring/Variables/#gestures
    gestures = {
      workspace_swipe = false;
    };

    #device = {
    #};


    windowrulev2 = [ 

    # Ignore maximize requests from apps. You'll probably like this.
    "suppressevent maximize, class:.*"

    # Fix some dragging issues with XWayland
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"

    # terminal opacity
    "opacity 0.85, class:(${userSettings.term}), title:(${userSettings.term})"
    ];
 
    # https://wiki.hyprland.org/Configuring/Variables/#misc
    misc = {
      font_family = userSettings.font;
      disable_hyprland_logo = true;
      force_default_wallpaper = 0;
    };

    xwayland = {
      force_zero_scaling = true;
    };
 
  };
  extraConfig = ''
    # Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
    # "Smart gaps" / "No gaps when only"
    # uncomment all if you wish to use that.
    # workspace = w[tv1], gapsout:0, gapsin:0
    # workspace = f[1], gapsout:0, gapsin:0
    # windowrulev2 = bordersize 0, floating:0, onworkspace:w[tv1]
    # windowrulev2 = rounding 0, floating:0, onworkspace:w[tv1]
    # windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
    # windowrulev2 = rounding 0, floating:0, onworkspace:f[1]

   ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################

    # See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    # See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules

    # Example windowrule v1
    # windowrule = float, ^(kitty)$

    # Example windowrule v2
    # windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
  
    '';
    xwayland.enable = true;
    systemd.enable = true;
  };

  home.packages = (with pkgs; [
    alacritty
    feh
    killall
    polkit_gnome
    rofi
    #papirus-icon-theme
    libva-utils
    #libinput-gestures
    gsettings-desktop-schemas
    zenity
    wlr-randr
    ydotool
    wl-clipboard
    hyprland-protocols
    hyprpicker
    hypridle
    hyprpaper
    fnott
    keepmenu
    pinentry-gnome3
    wev
    grim
    slurp
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    #xdg-desktop-portal-hyprland
    wlsunset
    pavucontrol
    pamixer

  ]);
  services.swayosd.enable = true;
  services.swayosd.topMargin = 0.5;
  programs.waybar = {
    enable = true;
/*    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      postPatch = ''
        # use hyprctl to switch workspaces
        sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch focusworkspaceoncurrentmonitor " + std::to_string(id());\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
        sed -i 's/gIPC->getSocket1Reply("dispatch workspace " + std::to_string(id()));/gIPC->getSocket1Reply("dispatch focusworkspaceoncurrentmonitor " + std::to_string(id()));/g' src/modules/hyprland/workspaces.cpp
      '';
      patches = [./patches/waybarpaupdate.patch ./patches/waybarbatupdate.patch];
    }); */
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        margin = "7 7 3 7";
        spacing = 2;

        modules-left = [ "group/power" "group/battery" "group/backlight" "group/cpu" "group/memory" "group/pulseaudio" "keyboard-state" ];
        modules-center = [ "custom/hyprprofile" "hyprland/workspaces" ];
        modules-right = [ "group/time" "idle_inhibitor" "tray" ];

        "custom/os" = {
          "format" = " {} ";
          "exec" = ''echo "" '';
          "interval" = "once";
          "on-click" = "rofi -show drun";
          "tooltip" = false;
        };
        "group/power" = {
            "orientation" = "horizontal";
            "drawer" = {
                "transition-duration" = 500;
                "children-class" = "not-power";
                "transition-left-to-right" = true;
            };
            "modules" = [
                "custom/os"
                "custom/hyprprofileicon"
                "custom/lock"
                "custom/quit"
                "custom/power"
                "custom/reboot"
            ];
        };
        "custom/quit" = {
            "format" = "󰍃";
            "tooltip" = false;
            "on-click" = "hyprctl dispatch exit";
        };
        "custom/lock" = {
            "format" = "󰍁";
            "tooltip" = false;
            "on-click" = "hyprlock";
        };
        "custom/reboot" = {
            "format" = "󰜉";
            "tooltip" = false;
            "on-click" = "reboot";
        };
        "custom/power" = {
            "format" = "󰐥";
            "tooltip" = false;
            "on-click" = "shutdown now";
        };
        "custom/hyprprofileicon" = {
          "format" = "󱙋";
          "on-click" = "hyprprofile-dmenu";
          "tooltip" = false;
        };
        "custom/hyprprofile" = {
          "format" = " {}";
          "exec" = ''cat ~/.hyprprofile'';
          "interval" = 3;
          "on-click" = "hyprprofile-dmenu";
        };
        "keyboard-state" = {
          "numlock" = true;
          "format" = "{icon}";
          "format-icons" = {
            "locked" = "󰎠 ";
            "unlocked" = "󱧓 ";
          };
        };
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "1" = "󱚌";
            "2" = "󰖟";
            "3" = "";
            "4" = "󰎄";
            "5" = "󰋩";
            "6" = "";
            "7" = "󰄖";
            "8" = "󰑴";
            "9" = "󱎓";
            "scratch_term" = "_";
            "scratch_ranger" = "_󰴉";
            "scratch_music" = "_";
            "scratch_btm" = "_";
            "scratch_pavucontrol" = "_󰍰";
          };
          "on-click" = "activate";
          "on-scroll-up" = "hyprnome";
          "on-scroll-down" = "hyprnome --previous";
          "all-outputs" = false;
          "active-only" = false;
          "ignore-workspaces" = ["scratch" "-"];
          "show-special" = false;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶"; # had a wtype but that was throwing errors CHECK
            deactivated = "󰾪";
          };
        };
        tray = {
          #"icon-size" = 21; "spacing" = 10;
        };
        "clock#time" = {
          "interval" = 1;
          "format" = "{:%I:%M:%S %p}";
          "timezone" = systemSettings.timezone;
          "tooltip-format" = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        "clock#date" = {
          "interval" = 1;
          "format" = "{:%a %Y-%m-%d}";
          "timezone" = systemSettings.timezone;
          "tooltip-format" = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        "group/time" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = false;
          };
          "modules" = [ "clock#time" "clock#date" ];
        };

        cpu = { "format" = "󰍛"; };
        "cpu#text" = { "format" = "{usage}%"; };
        "group/cpu" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [ "cpu" "cpu#text" ];
        };

        memory = { "format" = ""; };
        "memory#text" = { "format" = "{}%"; };
        "group/memory" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [ "memory" "memory#text" ];
        };

        backlight = {
          "format" = "{icon}";
          "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
        };
        "backlight#text" = { "format" = "{percent}%"; };
        "group/backlight" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [ "backlight" "backlight#text" ];
        };

        battery = {
          "states" = {
            "good" = 75;
            "warning" = 30;
            "critical" = 15;
          };
          "fullat" = 80;
          "format" = "{icon}";
          "format-charging" = "󰂄";
          "format-plugged" = "󰂄";
          "format-full" = "󰁹";
          "format-icons" = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          "interval" = 10;
        };
        "battery#text" = {
          "states" = {
            "good" = 75;
            "warning" = 30;
            "critical" = 15;
          };
          "fullat" = 80;
          "format" = "{capacity}%";
        };
        "group/battery" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [ "battery" "battery#text" ];
        };
        pulseaudio = {
          "scroll-step" = 1;
          "format" = "{icon}";
          "format-bluetooth" = "{icon}";
          "format-bluetooth-muted" = "󰸈";
          "format-muted" = "󰸈";
          "format-source" = "";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" "" ];
          };
          "on-click" = "hyprctl dispatch togglespecialworkspace scratch_pavucontrol; if hyprctl clients | grep pavucontrol; then echo 'scratch_ranger respawn not needed'; else pavucontrol; fi";
        };
        "pulseaudio#text" = {
          "scroll-step" = 1;
          "format" = "{volume}%";
          "format-bluetooth" = "{volume}%";
          "format-bluetooth-muted" = "";
          "format-muted" = "";
          "format-source" = "{volume}%";
          "format-source-muted" = "";
          "on-click" = "hyprctl dispatch togglespecialworkspace scratch_pavucontrol; if hyprctl clients | grep pavucontrol; then echo 'scratch_ranger respawn not needed'; else pavucontrol; fi";
        };
        "group/pulseaudio" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [ "pulseaudio" "pulseaudio#text" ];
        };
      };
    };
    style = ''
      * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: FontAwesome, ''+userSettings.font+'';

          font-size: 20px;
      }

      window#waybar {
          background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + "," + config.lib.stylix.colors.base00-rgb-g + "," + config.lib.stylix.colors.base00-rgb-b + "," + ''0.55);
          border-radius: 8px;
          color: #'' + config.lib.stylix.colors.base07 + '';
          transition-property: background-color;
          transition-duration: .2s;
      }

      tooltip {
        color: #'' + config.lib.stylix.colors.base07 + '';
        background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + "," + config.lib.stylix.colors.base00-rgb-g + "," + config.lib.stylix.colors.base00-rgb-b + "," + ''0.9);
        border-style: solid;
        border-width: 3px;
        border-radius: 8px;
        border-color: #'' + config.lib.stylix.colors.base08 + '';
      }

      tooltip * {
        color: #'' + config.lib.stylix.colors.base07 + '';
        background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + "," + config.lib.stylix.colors.base00-rgb-g + "," + config.lib.stylix.colors.base00-rgb-b + "," + ''0.0);
      }

      window > box {
          border-radius: 8px;
          opacity: 0.94;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      button {
          border: none;
      }

      #custom-hyprprofile {
          color: #'' + config.lib.stylix.colors.base0D + '';
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
          background: inherit;
      }

      #workspaces button {
          padding: 0px 6px;
          background-color: transparent;
          color: #'' + config.lib.stylix.colors.base04 + '';
      }

      #workspaces button:hover {
          color: #'' + config.lib.stylix.colors.base07 + '';
      }

      #workspaces button.active {
          color: #'' + config.lib.stylix.colors.base08 + '';
      }

      #workspaces button.focused {
          color: #'' + config.lib.stylix.colors.base0A + '';
      }

      #workspaces button.visible {
          color: #'' + config.lib.stylix.colors.base05 + '';
      }

      #workspaces button.urgent {
          color: #'' + config.lib.stylix.colors.base09 + '';
      }

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
      #custom-hyprprofileicon,
      #custom-quit,
      #custom-lock,
      #custom-reboot,
      #custom-power,
      #mpd {
          padding: 0 3px;
          color: #'' + config.lib.stylix.colors.base07 + '';
          border: none;
          border-radius: 8px;
      }

      #custom-hyprprofileicon,
      #custom-quit,
      #custom-lock,
      #custom-reboot,
      #custom-power,
      #idle_inhibitor {
          background-color: transparent;
          color: #'' + config.lib.stylix.colors.base04 + '';
      }

      #custom-hyprprofileicon:hover,
      #custom-quit:hover,
      #custom-lock:hover,
      #custom-reboot:hover,
      #custom-power:hover,
      #idle_inhibitor:hover {
          color: #'' + config.lib.stylix.colors.base07 + '';
      }

      #clock, #tray, #idle_inhibitor {
          padding: 0 5px;
      }

      #window,
      #workspaces {
          margin: 0 6px;
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
          color: #'' + config.lib.stylix.colors.base0D + '';
      }

      #battery {
          color: #'' + config.lib.stylix.colors.base0B + '';
      }

      #battery.charging, #battery.plugged {
          color: #'' + config.lib.stylix.colors.base0C + '';
      }

      @keyframes blink {
          to {
              background-color: #'' + config.lib.stylix.colors.base07 + '';
              color: #'' + config.lib.stylix.colors.base00 + '';
          }
      }

      #battery.critical:not(.charging) {
          background-color: #'' + config.lib.stylix.colors.base08 + '';
          color: #'' + config.lib.stylix.colors.base07 + '';
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      label:focus {
          background-color: #'' + config.lib.stylix.colors.base00 + '';
      }

      #cpu {
          color: #'' + config.lib.stylix.colors.base0D + '';
      }

      #memory {
          color: #'' + config.lib.stylix.colors.base0E + '';
      }

      #disk {
          color: #'' + config.lib.stylix.colors.base0F + '';
      }

      #backlight {
          color: #'' + config.lib.stylix.colors.base0A + '';
      }

      label.numlock {
          color: #'' + config.lib.stylix.colors.base04 + '';
      }

      label.numlock.locked {
          color: #'' + config.lib.stylix.colors.base0F + '';
      }

      #pulseaudio {
          color: #'' + config.lib.stylix.colors.base0C + '';
      }

      #pulseaudio.muted {
          color: #'' + config.lib.stylix.colors.base04 + '';
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
      }

      #idle_inhibitor {
          color: #'' + config.lib.stylix.colors.base04 + '';
      }

      #idle_inhibitor.activated {
          color: #'' + config.lib.stylix.colors.base0F + '';
      }
      '';
  };
  home.file.".config/gtklock/style.css".text = ''
    window {
      background-image: url("''+config.stylix.image+''");
      background-size: auto 100%;
    }
  '';

  services.udiskie.enable = true;
  services.udiskie.tray = "always";
  programs.fuzzel.enable = true;
  programs.fuzzel.package = pkgs.fuzzel;
  programs.fuzzel.settings = {
    main = {
      font = userSettings.font + ":size=20";
      dpi-aware = "no";
      show-actions = "yes";
      #terminal = pkgs.alacritty}/bin/alacritty";
    };
    colors = {
      background = config.lib.stylix.colors.base00 + "bf";
      text = config.lib.stylix.colors.base07 + "ff";
      match = config.lib.stylix.colors.base05 + "ff";
      selection = config.lib.stylix.colors.base08 + "ff";
      selection-text = config.lib.stylix.colors.base00 + "ff";
      selection-match = config.lib.stylix.colors.base05 + "ff";
      border = config.lib.stylix.colors.base08 + "ff";
    };
    border = {
      width = 3;
      radius = 7;
    };
  };
  services.fnott.enable = true;
  services.fnott.settings = {
    main = {
      anchor = "bottom-right";
      stacking-order = "top-down";
      min-width = 400;
      title-font = userSettings.font + ":size=14";
      summary-font = userSettings.font + ":size=12";
      body-font = userSettings.font + ":size=11";
      border-size = 0;
    };
    low = {
      background = config.lib.stylix.colors.base00 + "e6";
      title-color = config.lib.stylix.colors.base03 + "ff";
      summary-color = config.lib.stylix.colors.base03 + "ff";
      body-color = config.lib.stylix.colors.base03 + "ff";
      idle-timeout = 150;
      max-timeout = 30;
      default-timeout = 8;
    };
    normal = {
      background = config.lib.stylix.colors.base00 + "e6";
      title-color = config.lib.stylix.colors.base07 + "ff";
      summary-color = config.lib.stylix.colors.base07 + "ff";
      body-color = config.lib.stylix.colors.base07 + "ff";
      idle-timeout = 150;
      max-timeout = 30;
      default-timeout = 8;
    };
    critical = {
      background = config.lib.stylix.colors.base00 + "e6";
      title-color = config.lib.stylix.colors.base08 + "ff";
      summary-color = config.lib.stylix.colors.base08 + "ff";
      body-color = config.lib.stylix.colors.base08 + "ff";
      idle-timeout = 0;
      max-timeout = 0;
      default-timeout = 0;
    };
  };
}
