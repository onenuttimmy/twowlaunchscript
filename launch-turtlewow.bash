#!/bin/bash

# ------------------------------------------------------------------
# Turtle WoW Wayland Launcher Fix (for Bash Shell)
#
# This script fixes the white screen/EGL error on Wayland
# by preloading the system's native Wayland libraries.
# ------------------------------------------------------------------

# --- Configuration ---
# Set the name of your AppImage file here
APPIMAGE_NAME="TurtleWoW.AppImage"
# ---------------------

# Get the directory where this script is located (robust bash method)
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Change to the script's directory so ./$APPIMAGE_NAME works
cd "$SCRIPT_DIR"

if [ ! -f "$APPIMAGE_NAME" ]; then
    echo "Error: AppImage not found: $APPIMAGE_NAME"
    echo "Please edit this script and set the correct APPIMAGE_NAME."
    exit 1
fi

echo "Starting Turtle WoW Launcher with Wayland (EGL) fix..."

# --- The Fix ---
# Find and set the libraries to preload
PRELOAD_LIBS=$(for n in libwayland-client.so.0 libwayland-egl.so.1 libwayland-cursor.so.0; do ldconfig -p 2>/dev/null | awk -v n="$n" '$1==n {print $NF; exit}'; done | paste -sd: -)

# Run the AppImage with the preloaded libraries
LD_PRELOAD="$PRELOAD_LIBS" ./$APPIMAGE_NAME

echo "Launcher closed."
