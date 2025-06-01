import json
import os
import math
import subprocess
import sys

# --- Configuration ---

# Path to pywal's generated colors.json file
WAL_COLORS_FILE = os.path.expanduser("~/.cache/wal/colors.json")

# Base GTK theme name (e.g., "Flat-Remix-GTK")
# The script will append the closest color and "-Dark" or "-Light" if needed.
# For example, if 'red' is closest and base is 'Flat-Remix-GTK', it will try 'Flat-Remix-GTK-Red-Dark'
BASE_GTK_THEME_NAME = "Flat-Remix-GTK"

# Suffix for the GTK theme name (e.g., "-Dark" or "-Light")
# Based on your preference, this is set to "-Dark"
GTK_THEME_VARIANT_SUFFIX = "-Dark"

# Base Icon theme name (e.g., "Flat-Remix")
# The script will append the closest color and "-Dark" or "-Light" if needed.
# For example, if 'red' is closest and base is 'Flat-Remix', it will try 'Flat-Remix-Red-Dark'
BASE_ICON_THEME_NAME = "Flat-Remix"

# Suffix for the Icon theme name (e.g., "-Dark" or "-Light")
# Based on your preference, this is set to "-Dark"
ICON_THEME_VARIANT_SUFFIX = "-Dark"

# Dictionary of target colors and their hex codes for comparison
# These are the specific hex codes for your Flat-Remix GTK theme and icon pack variants.
# 'Black' is explicitly excluded as per your request.
COLOR_MAP = {
    "Blue": "#1F5FCA",
    "Brown": "#C37837",
    "Green": "#06A284",
    "Cyan": "#0CCFD9",
    "Grey": "#666666",
    "Magenta": "#CD0245",
    "Orange": "#FD7D00",
    "Red": "#EC0101",
    "Teal": "#0099A1",
    "Violet": "#962AC3",
    "Yellow": "#FFD86E",
}

# --- Helper Functions ---

def hex_to_rgb(hex_color):
    """Converts a hex color string (#RRGGBB) to an RGB tuple (R, G, B)."""
    hex_color = hex_color.lstrip('#')
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hsl(r, g, b):
    """
    Converts an RGB color (0-255) to HSL (Hue 0-360, Saturation 0-1, Lightness 0-1).
    """
    r /= 255.0
    g /= 255.0
    b /= 255.0

    cmax = max(r, g, b)
    cmin = min(r, g, b)
    delta = cmax - cmin

    # Hue calculation
    if delta == 0:
        h = 0
    elif cmax == r:
        h = ((g - b) / delta) % 6
    elif cmax == g:
        h = ((b - r) / delta) + 2
    elif cmax == b:
        h = ((r - g) / delta) + 4
    h = round(h * 60)
    if h < 0:
        h += 360

    # Lightness calculation
    l = (cmax + cmin) / 2.0

    # Saturation calculation
    if delta == 0:
        s = 0
    else:
        s = delta / (1 - abs(2 * l - 1))

    return h, s, l # H (0-360), S (0-1), L (0-1)

def hsl_distance(hsl1, hsl2):
    """
    Calculates a perceptual distance between two HSL color tuples.
    Hue difference is prioritized heavily, but conditionally reduced for grays.
    """
    h1, s1, l1 = hsl1 # Target color (from pywal)
    h2, s2, l2 = hsl2 # Reference color (from COLOR_MAP)

    # Threshold to consider a color "near-achromatic" (gray)
    SATURATION_THRESHOLD_FOR_GRAY = 0.18 # Colors below this saturation are considered near-gray

    # Calculate hue difference (circular, normalized to 0-1 range)
    dh = abs(h1 - h2)
    dh = min(dh, 360 - dh) # Handle wrap-around (e.g., 350 vs 10 is 20, not 340)
    dh_normalized = dh / 180.0 # Max hue difference is 180 degrees, normalize to 1.0

    ds = abs(s1 - s2) # Saturation difference (0-1)
    dl = abs(l1 - l2) # Lightness difference (0-1)

    # Default weights for H, S, L components
    W_H = 100.0 # High weight for hue
    W_S = 10.0  # Medium weight for saturation
    W_L = 5.0   # Lower weight for lightness

    # Conditional weighting for near-achromatic (gray) target colors
    # If the target color from pywal is very desaturated, its hue is unreliable.
    # We drastically reduce the hue weight and increase the saturation/lightness weights.
    if s1 < SATURATION_THRESHOLD_FOR_GRAY:
        W_H = 5.0  # Drastically reduce hue weight for near-gray targets
        W_S = 20.0 # Increase saturation weight to distinguish between grays and slightly colored desaturated
        W_L = 20.0 # Increase lightness weight as it's key for grays in this scenario

    # Sum of weighted absolute differences
    total_distance = (dh_normalized * W_H) + (ds * W_S) + (dl * W_L)
    return total_distance

def get_closest_color(target_hsl, color_map_hsl_precomputed):
    """
    Finds the closest color name from the precomputed HSL color_map
    to the target HSL color using the custom hsl_distance.
    """
    min_distance = float('inf')
    closest_color_name = None

    for name, map_hsl in color_map_hsl_precomputed.items():
        distance = hsl_distance(target_hsl, map_hsl)
        if distance < min_distance:
            min_distance = distance
            closest_color_name = name
    return closest_color_name

def set_gtk_theme(theme_name):
    """
    Sets the GTK theme using the appropriate command for the detected desktop environment.
    """
    desktop = os.environ.get('XDG_CURRENT_DESKTOP', '').lower()
    command = []

    print(f"Attempting to set GTK theme to: {theme_name}")

    command = ["gsettings", "set", "org.gnome.desktop.interface", "gtk-theme", theme_name]

    try:
        subprocess.run(command, check=True, capture_output=True, text=True)
        print(f"Successfully set GTK theme to '{theme_name}' for desktop environment: {desktop}")
    except subprocess.CalledProcessError as e:
        print(f"Error setting GTK theme: {e.stderr}", file=sys.stderr)
        print(f"Command failed: {' '.join(command)}", file=sys.stderr)
    except FileNotFoundError:
        print(f"Error: Command '{command[0]}' not found. Please ensure it's installed and in your PATH.", file=sys.stderr)
        print(f"For GNOME/Cinnamon/MATE, install 'dconf-cli' (provides gsettings).", file=sys.stderr)
        print(f"For XFCE, install 'xfce4-settings' (provides xfconf-query).", file=sys.stderr)

def set_icon_theme(icon_theme_name):
    """
    Sets the Icon theme using the appropriate command for the detected desktop environment.
    """
    desktop = os.environ.get('XDG_CURRENT_DESKTOP', '').lower()
    command = []

    print(f"Attempting to set Icon theme to: {icon_theme_name}")

    command = ["gsettings", "set", "org.gnome.desktop.interface", "icon-theme", icon_theme_name]

    try:
        subprocess.run(command, check=True, capture_output=True, text=True)
        print(f"Successfully set Icon theme to '{icon_theme_name}' for desktop environment: {desktop}")
    except subprocess.CalledProcessError as e:
        print(f"Error setting Icon theme: {e.stderr}", file=sys.stderr)
        print(f"Command failed: {' '.join(command)}", file=sys.stderr)
    except FileNotFoundError:
        print(f"Error: Command '{command[0]}' not found. Please ensure it's installed and in your PATH.", file=sys.stderr)
        print(f"For GNOME/Cinnamon/MATE, install 'dconf-cli' (provides gsettings).", file=sys.stderr)
        print(f"For XFCE, install 'xfce4-settings' (provides xfconf-query).", file=sys.stderr)

# --- Main Script Logic ---

def main():
    if not os.path.exists(WAL_COLORS_FILE):
        print(f"Error: {WAL_COLORS_FILE} not found. Please run 'wal -i /path/to/wallpaper.jpg' first.", file=sys.stderr)
        sys.exit(1)

    try:
        with open(WAL_COLORS_FILE, 'r') as f:
            wal_colors = json.load(f)
    except json.JSONDecodeError:
        print(f"Error: Could not decode JSON from {WAL_COLORS_FILE}. File might be corrupted.", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"An unexpected error occurred while reading {WAL_COLORS_FILE}: {e}", file=sys.stderr)
        sys.exit(1)

    # Precompute HSL values for the COLOR_MAP to avoid recalculating in the loop
    color_map_hsl_precomputed = {}
    for name, hex_code in COLOR_MAP.items():
        r, g, b = hex_to_rgb(hex_code)
        color_map_hsl_precomputed[name] = rgb_to_hsl(r, g, b)

    # Extract the primary accent color (color1) from pywal's output
    wal_primary_hex = wal_colors.get('colors', {}).get('color1')
    if not wal_primary_hex:
        # Fallback to special.background if color1 is not present (though it should be)
        wal_primary_hex = wal_colors.get('special', {}).get('background')
        if not wal_primary_hex:
            print("Error: Could not find primary color (color1 or special.background) in wal_colors.json.", file=sys.stderr)
            sys.exit(1)
        else:
            print("Using background color as primary color for comparison.")

    print(f"Pywal primary color (color1): {wal_primary_hex}")

    # Convert pywal's primary color to RGB and then HSL
    wal_primary_rgb = hex_to_rgb(wal_primary_hex)
    wal_primary_hsl = rgb_to_hsl(*wal_primary_rgb) # Unpack RGB tuple for hsl conversion

    # Find the closest color from our predefined map using HSL distance
    closest_color_name = get_closest_color(wal_primary_hsl, color_map_hsl_precomputed)

    if closest_color_name:
        print(f"Closest predefined color: {closest_color_name} ({COLOR_MAP[closest_color_name]})")

        # Construct and set the GTK theme name
        final_gtk_theme_name = f"{BASE_GTK_THEME_NAME}-{closest_color_name}{GTK_THEME_VARIANT_SUFFIX}"
        print(f"Proposed GTK theme name: {final_gtk_theme_name}")
        set_gtk_theme(final_gtk_theme_name)

        # Construct and set the Icon theme name
        final_icon_theme_name = f"{BASE_ICON_THEME_NAME}-{closest_color_name}{ICON_THEME_VARIANT_SUFFIX}"
        print(f"Proposed Icon theme name: {final_icon_theme_name}")
        set_icon_theme(final_icon_theme_name)

    else:
        print("Could not determine the closest color. COLOR_MAP might be empty.", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
