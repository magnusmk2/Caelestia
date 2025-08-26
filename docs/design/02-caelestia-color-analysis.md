# Caelestia Color System Analysis

**Document**: Research Phase - Caelestia Color System  
**Author**: Magnus  
**Date**: 2025-01-26  
**Status**: Complete  

## Current Color System Overview

Caelestia uses a sophisticated **Material Design 3** color system with dynamic theming capabilities.

### Architecture
- **Primary Source**: `~/.config/quickshell/caelestia/services/Colours.qml`
- **Configuration**: `~/.config/caelestia/shell.json` 
- **Runtime State**: `~/.local/state/caelestia/scheme.json`
- **Current Scheme**: "shadotheme" (fruitsalad variant, dark mode)

### Color System Components

#### 1. M3Palette (Base Colors)
```qml
component M3Palette: QtObject {
    // Material Design 3 standard colors
    property color m3primary: "#bfc1ff"
    property color m3onPrimary: "#282b60"
    property color m3background: "#131317"
    property color m3surface: "#131317"
    property color m3onSurface: "#e5e1e7"
    // ... 50+ M3 color properties
}
```

#### 2. M3TPalette (Transparent/Layered Colors)
```qml
component M3TPalette: QtObject {
    // Applies transparency and layering effects
    readonly property color m3background: root.layer(root.palette.m3background, 0)
    readonly property color m3surface: root.layer(root.palette.m3surface, 0)
    // ... transparent variants of all M3 colors
}
```

#### 3. Dynamic Features
- **Wallpaper-based colors**: ColorQuantizer extracts colors from wallpaper
- **Light/Dark mode switching**: Automatic or manual mode selection
- **Transparency system**: Configurable transparency with layering
- **Live preview**: Preview colors before applying

## Current Color Values (Active Scheme)

### Primary Colors
| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| Primary | `#bfc1ff` | Light blue | Primary buttons, accents |
| On Primary | `#282b60` | Dark blue | Text on primary |
| Background | `#131317` | Very dark | Main background |
| Surface | `#131317` | Very dark | Card/panel backgrounds |
| On Surface | `#e5e1e7` | Light gray | Main text color |

### Secondary Colors
| Role | Color | Hex | Usage |
|------|-------|-----|-------|
| Secondary | `#c5c4e0` | Light purple | Secondary elements |
| Tertiary | `#f4b2e2` | Light pink | Accent elements |
| Error | `#ffb4ab` | Light red | Error states |

### Terminal Colors (16-color palette)
```json
"term0": "#353434",   // Black
"term1": "#a875ff",   // Red (purple)
"term2": "#44def5",   // Green (cyan)
"term3": "#ffdcf2",   // Yellow (pink)
"term4": "#97aad7",   // Blue
"term5": "#b29feb",   // Magenta
"term6": "#9dceff",   // Cyan
"term7": "#e8d3de",   // White
"term8": "#ac9fa9",   // Bright Black
"term9": "#bd95ff",   // Bright Red
"term10": "#89ecff",  // Bright Green
"term11": "#fff0f6",  // Bright Yellow
"term12": "#b4c1dc",  // Bright Blue
"term13": "#c8b5f5",  // Bright Magenta
"term14": "#bae0ff",  // Bright Cyan
"term15": "#ffffff"   // Bright White
```

## Color Extraction Strategy

### For SilentSDDM Integration

#### Core Mapping
| SilentSDDM Property | Caelestia Source | Current Value |
|---------------------|------------------|---------------|
| `Background` | `m3background` | `#131317` |
| `TextColor` | `m3onSurface` | `#e5e1e7` |
| `InputBackgroundColor` | `m3surfaceContainer` | `#1f1f23` |
| `InputTextColor` | `m3onSurface` | `#e5e1e7` |
| `InputBorderColor` | `m3outline` | `#918f9a` |
| `InputFocusColor` | `m3primary` | `#bfc1ff` |
| `ButtonBackgroundColor` | `m3primary` | `#bfc1ff` |
| `ButtonTextColor` | `m3onPrimary` | `#282b60` |

#### Extended Mapping
| SilentSDDM Property | Caelestia Source | Current Value |
|---------------------|------------------|---------------|
| `PlaceholderTextColor` | `m3onSurfaceVariant` | `#c7c5d1` |
| `SessionTextColor` | `m3onSurface` | `#e5e1e7` |
| `ClockColor` | `m3onSurface` | `#e5e1e7` |
| `DateColor` | `m3onSurfaceVariant` | `#c7c5d1` |
| `ButtonHoverColor` | `m3primaryContainer` | `#6f72ac` |

## Technical Implementation Notes

### Color Access Methods

#### 1. Direct File Reading
```bash
# Read current scheme
cat ~/.local/state/caelestia/scheme.json | jq '.colours'
```

#### 2. QML Property Access
```qml
// Access from within QuickShell
Colours.palette.m3primary
Colours.tPalette.m3primary  // Transparent variant
```

#### 3. Command Line Interface
```bash
# Change scheme (triggers updates)
caelestia scheme set --notify -m dark
```

### Update Mechanism
1. **File Watcher**: `FileView` monitors `scheme.json` for changes
2. **Auto-reload**: Colors update automatically when scheme changes
3. **Notification**: System notifies of color changes via `--notify` flag

## Integration Requirements

### For Color Synchronization System

#### Input Requirements
- **Read access** to `~/.local/state/caelestia/scheme.json`
- **JSON parsing** capability for color extraction
- **File watching** for real-time updates

#### Output Requirements
- **Template generation** for SilentSDDM theme files
- **System file modification** (requires sudo for SDDM themes)
- **Service restart** capability for applying changes

#### Color Format Conversion
- **Input**: Hex colors without `#` prefix (e.g., "bfc1ff")
- **Output**: Various formats depending on target:
  - SilentSDDM: `#bfc1ff` (with hash)
  - GRUB: `#bfc1ff` or RGB values
  - CSS: `#bfc1ff` or `rgb(191, 193, 255)`

## Recommendations

### Phase 1: Manual Implementation
1. **Extract current colors** from scheme.json
2. **Create SilentSDDM theme** with hardcoded Caelestia colors
3. **Test functionality** and visual consistency

### Phase 2: Automated Synchronization
1. **Build color extraction script** to read scheme.json
2. **Create template system** for generating theme files
3. **Implement file watching** for real-time updates

### Phase 3: Advanced Features
1. **Multi-component support** (GRUB, GTK, Qt themes)
2. **Color variant generation** (light/dark mode support)
3. **User customization interface**

---

**Status**: Analysis complete, ready for PoC implementation  
**Next Document**: [03-silentsddm-poc.md](03-silentsddm-poc.md)
