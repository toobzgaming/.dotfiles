# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import os
import re
import socket
import subprocess
from typing import List  # noqa: F401
from libqtile import layout, bar, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen, Rule
from libqtile.command import lazy

#mod4 or mod = super key
mod = "mod4"
terminal = "alacritty"
browser = "firefox"
editor = os.getenv("EDITOR") or "vim"
editorgui = "env -u WAYLAND_DISPLAY neovide"
filemanager = "dolphin"
mediaplayer = "elisa"
mailclient = "thunderbird"
virtualmachine = "virtualbox"
logout = "archlinux-logout"
home = os.path.expanduser('~')


@lazy.function
def window_to_prev_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

@lazy.function
def window_to_next_group(qtile):
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

keys = [

# Most of our keybindings are in sxhkd file - except these
# SUPER + ... Keys

    Key([mod], "Return", lazy.spawn(terminal)),
    Key([mod], "e", lazy.spawn(filemanager)),
    Key([mod], "i", lazy.spawn(browser)),
    Key([mod], "space", lazy.spawncmd()),
    Key([mod], "q", lazy.window.kill()),
    Key([mod], "x", lazy.spawn(logout)),

# CTRL + ALT KEYS

    Key(["control", "mod1"], "space", lazy.spawncmd()),
    Key(["control", "mod1"], "Return", lazy.spawn(terminal)),
    Key(["control", "mod1"], "t", lazy.spawn(terminal)),
    Key(["control", "mod1"], "e", lazy.spawn(filemanager)),
    Key(["control", "mod1"], "i", lazy.spawn(browser)),
    Key(["control", "mod1"], "delete", lazy.spawn(logout)),

# SUPER + FUNCTION KEYS
    Key([mod], "F1", lazy.spawn(browser)),
    Key([mod], "F2", lazy.spawn(editorgui)),
    Key([mod], "F3", lazy.spawn("inkscape")),
    Key([mod], "F4", lazy.spawn("gimp")),
    Key([mod], "F5", lazy.spawn("kompare")),
    Key([mod], "F6", lazy.spawn("vlc --video-on-top")),
    Key([mod], "F7", lazy.spawn(virtualmachine)),
    Key([mod], "F8", lazy.spawn(filemanager)),
    Key([mod], "F9", lazy.spawn(mailclient)),
    Key([mod], "F10", lazy.spawn(mediaplayer)),
    Key([mod], "F11", lazy.spawn("rofi -theme-str 'window {width: 100%;height: 100%;}' -show drun")),
    Key([mod], "F12", lazy.spawn("rofi -show drun")),


# SUPER + SHIFT KEYS

    Key([mod, "shift"], "q", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "x", lazy.shutdown()),


# QTILE LAYOUT KEYS
    Key([mod], "backslash", lazy.next_layout()),
    Key([mod, "shift"], "backslash", lazy.prev_layout()),
    Key([mod, "control"], "backslash", lazy.layout.normalize()),

# CHANGE FOCUS
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),


# RESIZE UP, DOWN, LEFT, RIGHT
    Key([mod, "control"], "l",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "Right",
        lazy.layout.grow_right(),
        lazy.layout.grow(),
        lazy.layout.increase_ratio(),
        lazy.layout.delete(),
        ),
    Key([mod, "control"], "h",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "Left",
        lazy.layout.grow_left(),
        lazy.layout.shrink(),
        lazy.layout.decrease_ratio(),
        lazy.layout.add(),
        ),
    Key([mod, "control"], "k",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "Up",
        lazy.layout.grow_up(),
        lazy.layout.grow(),
        lazy.layout.decrease_nmaster(),
        ),
    Key([mod, "control"], "j",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),
    Key([mod, "control"], "Down",
        lazy.layout.grow_down(),
        lazy.layout.shrink(),
        lazy.layout.increase_nmaster(),
        ),


# FLIP LAYOUT FOR MONADTALL/MONADWIDE
    Key([mod], "slash", lazy.layout.flip()),
    Key([mod, "shift"], "slash", lazy.layout.flip()),

# FLIP LAYOUT FOR BSP
    Key([mod, "mod1"], "k", lazy.layout.flip_up()),
    Key([mod, "mod1"], "j", lazy.layout.flip_down()),
    Key([mod, "mod1"], "l", lazy.layout.flip_right()),
    Key([mod, "mod1"], "h", lazy.layout.flip_left()),

# MOVE WINDOWS UP OR DOWN BSP LAYOUT
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),

# MOVE WINDOWS UP OR DOWN MONADTALL/MONADWIDE LAYOUT
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Left", lazy.layout.swap_left()),
    Key([mod, "shift"], "Right", lazy.layout.swap_right()),

# TOGGLE FLOATING LAYOUT
    Key([mod, "shift"], "space", lazy.window.toggle_floating()),
    Key([mod], "f", lazy.window.toggle_floating()),
    Key([mod, "shift"], "f", lazy.layout.floating()),
# TOGGLE FULLSCREEN LAYOUT
    Key(["control"], "Return", lazy.window.toggle_fullscreen()),
    Key(["mod1"], "Return", lazy.window.toggle_fullscreen()),
# TOGGLE MAXIMIZE
    Key([mod], "Page_Up", lazy.window.toggle_maximixe()),
# TOGGLE MINIMIZE
    Key([mod], "Page_Down", lazy.window.toggle_minimize()),
# CHANGE OPACITY
    Key([mod, "shift"], "Page_Up", lazy.window.up_opacity()),
    Key([mod, "shift"], "Page_Down", lazy.window.down_opacity()),

    ]

def window_to_previous_screen(qtile, switch_group=False, switch_screen=False):
    i = qtile.screens.index(qtile.current_screen)
    if i != 0:
        group = qtile.screens[i - 1].group.name
        qtile.current_window.togroup(group, switch_group=switch_group)
        if switch_screen == True:
            qtile.cmd_to_screen(i - 1)

def window_to_next_screen(qtile, switch_group=False, switch_screen=False):
    i = qtile.screens.index(qtile.current_screen)
    if i + 1 != len(qtile.screens):
        group = qtile.screens[i + 1].group.name
        qtile.current_window.togroup(group, switch_group=switch_group)
        if switch_screen == True:
            qtile.cmd_to_screen(i + 1)

keys.extend([
    # MOVE WINDOW TO NEXT SCREEN
    Key([mod,"shift"], "period", lazy.function(window_to_next_screen, switch_screen=True)),
    Key([mod,"shift"], "comma", lazy.function(window_to_previous_screen, switch_screen=True)),
    Key([mod], "period", lazy.next_screen()),
    Key([mod], "comma", lazy.prev_screen()),
])

groups = []

# FOR QWERTY KEYBOARDS
group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]

# FOR AZERTY KEYBOARDS
#group_names = ["ampersand", "eacute", "quotedbl", "apostrophe", "parenleft", "section", "egrave", "exclam", "ccedilla", "agrave",]

#group_labels = ["1 ", "2 ", "3 ", "4 ", "5 ", "6 ", "7 ", "8 ", "9 ", "0",]
#group_labels = ["", "", "", "", "", "", "", "", "", "",]
#group_labels = ["Web", "Edit/chat", "Image", "Gimp", "Meld", "Video", "Vb", "Files", "Mail", "Music",]

group_labels = ["󰍹", "", "", "", "", "", "󰏫", "󰕼", "" ]
#group_labels = ["Sys","Dev", "Web", "Term", "Files", Read", "Edit", "Vid", "Aud" ]

group_layouts = ["monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall", "monadtall"]
#group_layouts = ["monadtall", "matrix", "monadtall", "bsp", "monadtall", "matrix", "monadtall", "bsp", "monadtall", "monadtall",]

for i in range(len(group_names)):
    groups.append(
        Group(
            name=group_names[i],
            layout=group_layouts[i].lower(),
            label=group_labels[i],
        ))

for i in groups:
    keys.extend([

#CHANGE WORKSPACES
        Key([mod], i.name, lazy.group[i.name].toscreen()),
        Key([mod], "Tab", lazy.screen.next_group()),
        Key([mod, "shift" ], "Tab", lazy.screen.prev_group()),
        Key(["mod1"], "Tab", lazy.screen.next_group()),
        Key(["mod1", "shift"], "Tab", lazy.screen.prev_group()),

# MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND STAY ON WORKSPACE
        #Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
# MOVE WINDOW TO SELECTED WORKSPACE 1-10 AND FOLLOW MOVED WINDOW TO WORKSPACE
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name) , lazy.group[i.name].toscreen()),
    ])


def init_layout_theme():
    return {"margin":8,
            "border_width":4,
            "border_focus": "#5e81ac",
            "border_normal": "#4c566a"
            }

layout_theme = init_layout_theme()


layouts = [
    #layout.MonadTall(margin=8, border_width=2, border_focus="#5e81ac", border_normal="#4c566a"),
    layout.MonadTall(**layout_theme),
    #layout.MonadWide(margin=8, border_width=2, border_focus="#5e81ac", border_normal="#4c566a"),
    #layout.MonadWide(**layout_theme),
    #layout.Matrix(**layout_theme),
    #layout.Bsp(**layout_theme),
    layout.Floating(**layout_theme),
    #layout.RatioTile(**layout_theme),
    layout.Max(**layout_theme),
]

# COLORS FOR THE BAR
#Theme name : ArcoLinux Default
def init_colors():
    return [["#2F343F", "#2F343F"], # color 0
            ["#2F343F", "#2F343F"], # color 1
            ["#c0c5ce", "#c0c5ce"], # color 2
            ["#fba922", "#fba922"], # color 3
            ["#3384d0", "#3384d0"], # color 4
            ["#f3f4f5", "#f3f4f5"], # color 5
            ["#cd1f3f", "#cd1f3f"], # color 6
            ["#62FF00", "#62FF00"], # color 7
            ["#6790eb", "#6790eb"], # color 8
            ["#a9a9a9", "#a9a9a9"]] # color 9


colors = init_colors()


# WIDGETS FOR THE BAR

def init_widgets_defaults():
    return dict(font="FiraCode Nerd Font",
                fontsize = 14,
                padding = 2,
                background=colors[1])

widget_defaults = init_widgets_defaults()

def get_window_name(text):
    text = text.split(" ")
    text = text[-1].strip() 
    return text

def init_widgets_list():
    prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())
    widgets_list = [
               widget.Prompt(
                        font = "FiraCode Nerd Font Bold",
                        fontsize = 14,
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1],
                        prompt = prompt,
                   ),
               widget.WindowCount(
                        font="FiraCode Nerd Font Bold",
                        fontsize = 16,
                        foreground = colors[5],
                        background = colors[1],
                        padding = 15,
                        show_zero = True,
                       ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.CurrentLayoutIcon(
                        font = "FiraCode Nerd Font Bold",
                        scale = 0.66,
                        fontsize = 10,
                        foreground = colors[5],
                        background = colors[1],
                        padding=10
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.GroupBox(font="FiraCode Nerd Font",
                        fontsize = 24,
                        disable_drag = True,
                        active = colors[9],
                        inactive = colors[5],
                        rounded = True,
                        highlight_method = "text",
                        this_current_screen_border = colors[8],
                        foreground = colors[2],
                        background = colors[1],
                        padding = 10,
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.CPU(
                        font="FiraCode Nerd Font",
                        fontsize = 14,
                        foreground = colors[5],
                        background = colors[1],
                        format="{freq_current:.1f}G\n{load_percent:2.0f}%", 
                        padding=10),
               widget.Memory(
                        font="FiraCode Nerd Font",
                        fontsize = 14,
                        foreground = colors[5],
                        background = colors[1],
                        padding = 10,
                        measure_mem = "G",
                        format = "{MemTotal:.0f}{mm}\n{MemPercent:2.0f}%"
                   ),
               widget.DF(
                        font="FiraCode Nerd Font",
                        fontsize = 14,
                        foreground = colors[5],
                        background = colors[1],
                        padding = 10,
                        visible_on_warn = False,
                        format ="{s}{m}\n{r:2.0f}%"
                       ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                       ),
               widget.WindowName(
                        font="FiraCode Nerd Font Bold",
                        fontsize = 16,
                        foreground = colors[5],
                        background = colors[1],
                        padding = 10,
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.Net(
                        font="FiraCode Nerd Font",
                        fontsize=12,
                        interface="wlan0",
                        foreground=colors[2],
                        background=colors[1],
                        padding = 10,
                        format = "\u2193 {down}\n\u2191 {up}",
                        ),
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               # widget.NetGraph(
               #          font="FiraCode Nerd Font",
               #          fontsize=14,
               #          bandwidth="down",
               #          interface="auto",
               #          fill_color = colors[8],
               #          foreground=colors[2],
               #          background=colors[1],
               #          graph_color = colors[8],
               #          border_color = colors[2],
               #          padding = 0,
               #          border_width = 1,
               #          line_width = 1,
               #          ),
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               # # do not activate in Virtualbox - will break qtile
               # widget.ThermalSensor(
               #          foreground = colors[5],
               #          foreground_alert = colors[6],
               #          background = colors[1],
               #          metric = True,
               #          padding = 3,
               #          threshold = 80
               #          ),
               # battery option 1  ArcoLinux Horizontal icons do not forget to import arcobattery at the top
               # widget.Sep(
               #          linewidth = 1,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               # arcobattery.BatteryIcon(
               #          scale=0.5,
               #          y_poss=2,
               #          theme_path=home + "/.config/qtile/icons/battery_icons_horiz",
               #          update_interval = 5,
               #          background = colors[1]
               #          ),
               # battery option 2  from Qtile
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.Battery(
                        font="FiraCode Nerd Font",
                        update_interval = 10,
                        fontsize = 14,
                        foreground = colors[2],
                        background = colors[1],
                        format ="{percent:2.0%}\n{hour:d}:{min:02d}",
                        padding = 10
	                    ),
               # widget.TextBox(
               #          font="FontAwesome",
               #          text="  ",
               #          foreground=colors[6],
               #          background=colors[1],
               #          padding = 0,
               #          fontsize=16
               #          ),
               # widget.CPUGraph(
               #          border_color = colors[2],
               #          fill_color = colors[8],
               #          graph_color = colors[8],
               #          background=colors[1],
               #          border_width = 1,
               #          line_width = 1,
               #          core = "all",
               #          type = "box"
               #          ),
               # widget.Sep(
               #          linewidth = 1,
               #          padding = 10,
               #          foreground = colors[2],
               #          background = colors[1]
               #          ),
               # widget.TextBox(
               #          font="FontAwesome",
               #          text="  ",
               #          foreground=colors[4],
               #          background=colors[1],
               #          padding = 0,
               #          fontsize=16
               #          ),
               # widget.Memory(
               #          font="FiraCode Nerd Font",
               #          format = '{MemUsed}M/{MemTotal}M',
               #          update_interval = 1,
               #          fontsize = 14,
               #          foreground = colors[5],
               #          background = colors[1],
               #         ),
               widget.Sep(
                        linewidth = 1,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.Clock(
                        foreground = colors[5],
                        background = colors[1],
                        font="FiraCode Nerd Font",
                        fontsize = 14,
                        format="%H:%M (%Z)\n%b | %d-%m-%y | %a",
                        padding=10
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                        ),
               widget.Systray(
                        background=colors[1],
                        icon_size=24,
                        padding = 10
                        ),
               widget.Sep(
                        linewidth = 1,
                        padding = 10,
                        foreground = colors[2],
                        background = colors[1]
                       ),
               widget.QuickExit(
                        foreground = colors[3],
                        background = colors[1],
                        font="FiraCode Nerd Font",
                        fontsize = 28,
                        default_text = "󰗽 ",
                        padding=10,
                        countdown_format="{}s"
                       ),
              ]
    return widgets_list

widgets_list = init_widgets_list()


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2

widgets_screen1 = init_widgets_screen1()
widgets_screen2 = init_widgets_screen2()


def init_screens():
    return [Screen(top=bar.Bar(widgets=init_widgets_screen1(), 
                               size=36, 
                               opacity=0.8, 
                               margin=[8,8,0,8], 
                               )),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), 
                               size=36, 
                               opacity=0.8, 
                               margin=[8,8,0,8], 
                               ))]
screens = init_screens()


# MOUSE CONFIGURATION
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size())
]

dgroups_key_binder = None
dgroups_app_rules = []

# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME
# BEGIN

#########################################################
################ assgin apps to groups ##################
#########################################################
# @hook.subscribe.client_new
# def assign_app_group(client):
#     d = {}
#     #####################################################################################
#     ### Use xprop fo find  the value of WM_CLASS(STRING) -> First field is sufficient ###
#     #####################################################################################
#     d[group_names[0]] = ["Navigator", "Firefox", "Vivaldi-stable", "Vivaldi-snapshot", "Chromium", "Google-chrome", "Brave", "Brave-browser",
#               "navigator", "firefox", "vivaldi-stable", "vivaldi-snapshot", "chromium", "google-chrome", "brave", "brave-browser", ]
#     d[group_names[1]] = [ "Atom", "Subl", "Geany", "Brackets", "Code-oss", "Code", "TelegramDesktop", "Discord",
#                "atom", "subl", "geany", "brackets", "code-oss", "code", "telegramDesktop", "discord", ]
#     d[group_names[2]] = ["Inkscape", "Nomacs", "Ristretto", "Nitrogen", "Feh",
#               "inkscape", "nomacs", "ristretto", "nitrogen", "feh", ]
#     d[group_names[3]] = ["Gimp", "gimp" ]
#     d[group_names[4]] = ["Meld", "meld", "org.gnome.meld" "org.gnome.Meld" ]
#     d[group_names[5]] = ["Vlc","vlc", "Mpv", "mpv" ]
#     d[group_names[6]] = ["VirtualBox Manager", "VirtualBox Machine", "Vmplayer",
#               "virtualbox manager", "virtualbox machine", "vmplayer", ]
#     d[group_names[7]] = ["Thunar", "Nemo", "Caja", "Nautilus", "org.gnome.Nautilus", "Pcmanfm", "Pcmanfm-qt",
#               "thunar", "nemo", "caja", "nautilus", "org.gnome.nautilus", "pcmanfm", "pcmanfm-qt", ]
#     d[group_names[8]] = ["Evolution", "Geary", "Mail", "Thunderbird",
#               "evolution", "geary", "mail", "thunderbird" ]
#     d[group_names[9]] = ["Spotify", "Pragha", "Clementine", "Deadbeef", "Audacious",
#               "spotify", "pragha", "clementine", "deadbeef", "audacious" ]
#     ######################################################################################
#
# wm_class = client.window.get_wm_class()[0]
#
#     for i in range(len(d)):
#         if wm_class in list(d.values())[i]:
#             group = list(d.keys())[i]
#             client.togroup(group)
#             client.group.cmd_toscreen(toggle=False)

# END
# ASSIGN APPLICATIONS TO A SPECIFIC GROUPNAME



main = None

@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/scripts/autostart.sh'])

@hook.subscribe.startup
def start_always():
    # Set the cursor to something sane in X
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.client_new
def set_floating(window):
    if (window.window.get_wm_transient_for()
            or window.window.get_wm_type() in floating_types):
        window.floating = True

floating_types = ["notification", "toolbar", "splash", "dialog"]


follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
    Match(wm_class='Arcolinux-welcome-app.py'),
    Match(wm_class='Arcolinux-calamares-tool.py'),
    Match(wm_class='confirm'),
    Match(wm_class='dialog'),
    Match(wm_class='download'),
    Match(wm_class='error'),
    Match(wm_class='file_progress'),
    Match(wm_class='notification'),
    Match(wm_class='splash'),
    Match(wm_class='toolbar'),
    Match(wm_class='Arandr'),
    Match(wm_class='feh'),
    Match(wm_class='Galculator'),
    Match(wm_class='archlinux-logout'),
    Match(wm_class='xfce4-terminal'),

],  fullscreen_border_width = 0, border_width = 0)
auto_fullscreen = True

focus_on_window_activation = "focus" # or smart

wmname = "LG3D"
