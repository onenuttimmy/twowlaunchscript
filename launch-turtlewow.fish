#!/usr/bin/env fish

# ------------------------------------------------------------------
# Turtle WoW Wayland Launcher Fix (for Fish Shell)
#
# This script fixes the white screen/EGL error on Wayland
# by preloading the system's native Wayland libraries.
# ------------------------------------------------------------------

# --- Configuration ---
# Set the name of your AppImage file here
set APPIMAGE_NAME "TurtleWoW.AppImage"
# ---------------------

# Get the directory where this script is located
set SCRIPT_DIR (dirname (status --current-filename))

# Change to the script's directory so ./$APPIMAGE_NAME works
cd "$SCRIPT_DIR"

if not test -f "$APPIMAGE_NAME"
    echo "Error: AppImage not found: $APPIMAGE_NAME"
    echo "Please edit this script and set the correct APPIMAGE_NAME."
    exit 1
end

echo "Starting Turtle WoW Launcher with Wayland (EGL) fix..."

# --- The Fix ---
# Preload the system's Wayland libraries
env LD_PRELOAD=(for n in libwayland-client.so.0 libwayland-egl.so.1 libwayland-cursor.so.0; ldconfig -p 2>/dev/null | awk -v n="$n" '$1==n {print $NF; exit}'; end | paste -sd: -) ./$APPIMAGE_NAME

echo "Launcher closed."
