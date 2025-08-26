# Architecture Views - Caelestia Desktop Environment

**Document**: Architecture Views (IEEE 1016 Compliant)  
**Author**: Magnus  
**Date**: 2025-01-26  
**Status**: Complete  

## Overview

This document presents multiple architectural views of the Caelestia Desktop Environment following IEEE 1016-2009 standard viewpoints.

## Context View

### System Context
```
┌─────────────────────────────────────────────────────────────┐
│                    External Environment                     │
│                                                             │
│  ┌─────────────┐    ┌─────────────────────────────────────┐ │
│  │   Hardware  │    │        Operating System            │ │
│  │             │    │                                     │ │
│  │ • AMD CPU   │◄──►│ • CachyOS (Arch Linux)            │ │
│  │ • NVIDIA GPU│    │ • Hyprland (Wayland)              │ │
│  │ • 3 Monitors│    │ • SDDM Display Manager            │ │
│  └─────────────┘    │ • Qt6 Framework                    │ │
│                     └─────────────────────────────────────┘ │
│                                     ▲                       │
│                                     │                       │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │          Caelestia Desktop Environment                  │ │
│  │                                                         │ │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────────┐ │ │
│  │  │   Desktop   │  │    Login    │  │  Color Sync     │ │ │
│  │  │    Shell    │  │   Screen    │  │    System       │ │ │
│  │  └─────────────┘  └─────────────┘  └─────────────────┘ │ │
│  └─────────────────────────────────────────────────────────┘ │
│                                     ▲                       │
│                                     │                       │
│  ┌─────────────────────────────────────────────────────────┐ │
│  │                    User                                 │ │
│  │                                                         │ │
│  │ • Magnus (Primary User)                                │ │
│  │ • System Administrators                                │ │
│  │ • Future Contributors                                  │ │
│  └─────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### External Interfaces
- **User Interface**: Visual desktop environment, login screen
- **System Interface**: SDDM, Hyprland, Qt6 framework integration
- **Hardware Interface**: Multi-monitor display management
- **Network Interface**: None (local system only)

## Composition View

### Component Hierarchy
```
Caelestia Desktop Environment
├── Desktop Shell (Caelestia)
│   ├── QuickShell Framework
│   ├── M3 Color System
│   ├── Network Management
│   └── Monitor Management
├── Login Screen (SilentSDDM)
│   ├── Theme Configuration
│   ├── User Authentication
│   └── Session Management  
├── Color Synchronization System
│   ├── Color Extraction Service
│   ├── Template Engine
│   ├── File Watcher
│   └── Theme Generators
└── Configuration Management
    ├── Backup System
    ├── Rollback Mechanism
    └── Validation System
```

### Component Relationships
- **Desktop Shell** → **Color System**: Provides authoritative colors
- **Color System** → **Login Screen**: Generates theme configurations
- **Color System** → **Boot Screen**: Generates GRUB themes (future)
- **Configuration Management** → **All Components**: Provides backup/restore

## Logical View

### Core Abstractions

#### Color Authority Pattern
```
┌─────────────────┐
│ Caelestia Shell │ (Authority)
└─────────┬───────┘
          │ publishes colors
          ▼
┌─────────────────┐
│ Color Sync Hub  │ (Mediator)
└─────────┬───────┘
          │ distributes
          ▼
┌─────────────────┐
│ Theme Consumers │ (Observers)
│ • SilentSDDM    │
│ • GRUB          │
│ • GTK/Qt        │
└─────────────────┘
```

#### Template System Pattern
```
Color Data + Template → Generated Theme File
{colors}   + {format}  → {target_config}
```

### Key Design Patterns
- **Observer Pattern**: Components watch for color changes
- **Template Method**: Standardized theme generation process
- **Strategy Pattern**: Different generators for different targets
- **Mediator Pattern**: Color sync hub coordinates updates

## Dependency View

### Component Dependencies
```
┌─────────────────┐
│ Desktop Shell   │
└─────────┬───────┘
          │ depends on
          ▼
┌─────────────────┐     ┌─────────────────┐
│ QuickShell      │     │ M3 Color System │
└─────────────────┘     └─────────┬───────┘
                                  │ provides
                                  ▼
                        ┌─────────────────┐
                        │ Color Sync Hub  │
                        └─────────┬───────┘
                                  │ generates
                                  ▼
                        ┌─────────────────┐
                        │ SilentSDDM      │
                        │ Theme Files     │
                        └─────────────────┘
```

### External Dependencies
- **Qt6**: Framework for UI components
- **SDDM**: Display manager for login screen
- **Hyprland**: Wayland compositor
- **CachyOS**: Operating system platform

## Information View

### Data Flow Architecture
```
User Changes Theme
        ↓
Caelestia Updates scheme.json
        ↓
File Watcher Detects Change
        ↓
Color Extractor Reads New Colors
        ↓
Template Engine Generates Themes
        ↓
Theme Files Updated
        ↓
Services Reloaded (SDDM, etc.)
        ↓
Visual Changes Applied
```

### Data Structures
```json
// Primary Color Schema
{
  "scheme": "shadotheme",
  "variant": "fruitsalad", 
  "mode": "dark",
  "colours": {
    "m3background": "131317",
    "m3surface": "131317",
    "m3primary": "bfc1ff",
    "m3onPrimary": "282b60",
    "m3onSurface": "e5e1e7"
    // ... 50+ M3 colors
  }
}
```

## Interface View

### Internal Interfaces
- **Color Provider Interface**: Standard API for color access
- **Theme Generator Interface**: Standard API for theme creation
- **File Watcher Interface**: Standard API for change detection

### External Interfaces  
- **SDDM Theme Interface**: Standard theme.conf format
- **GRUB Theme Interface**: Standard GRUB theme format
- **System Service Interface**: systemctl integration

## Structure View

### Physical Architecture
```
File System Layout:
~/.config/caelestia/
├── shell.json                 # Configuration
└── management/                # Scripts

~/.config/quickshell/caelestia/
├── services/Colours.qml       # Color system
└── components/                # UI components

~/.local/state/caelestia/
└── scheme.json               # Runtime colors

/usr/share/sddm/themes/
└── caelestia-silent/         # Generated theme
    ├── theme.conf
    └── Main.qml

/etc/sddm.conf.d/
└── caelestia.conf           # SDDM configuration
```

### Deployment Architecture
- **Single Machine**: All components on same system
- **User Space**: Configuration and state files
- **System Space**: Theme files and service configs
- **Privilege Separation**: Minimal sudo requirements

## Interaction View

### Color Update Sequence
```
User → Caelestia → scheme.json → FileWatcher → ColorExtractor → TemplateEngine → ThemeFiles → SDDM → Display
```

### Login Sequence  
```
Boot → SDDM → Load Theme → Display Login → Authenticate → Start Session → Load Desktop
```

## State Dynamics View

### System States
- **Initializing**: System starting, loading configurations
- **Synchronized**: All components using consistent colors
- **Updating**: Color change in progress
- **Error**: Inconsistent state, rollback required
- **Maintenance**: Manual intervention required

### State Transitions
```
Initializing → Synchronized (successful startup)
Synchronized → Updating (color change detected)  
Updating → Synchronized (successful update)
Updating → Error (update failed)
Error → Synchronized (rollback successful)
Any State → Maintenance (manual intervention)
```

## Algorithm View

### Color Extraction Algorithm
```
1. Monitor scheme.json for changes
2. Parse JSON and validate schema
3. Extract M3 color values
4. Convert hex format (add # prefix)
5. Map to target format requirements
6. Generate theme files from templates
7. Validate generated files
8. Apply changes atomically
9. Restart affected services
10. Verify successful application
```

### Rollback Algorithm
```
1. Detect failure condition
2. Stop current update process
3. Restore previous theme files
4. Restart affected services  
5. Verify system stability
6. Log failure for analysis
7. Notify user of rollback
```

## Resource View

### Performance Requirements
- **Memory**: < 50MB total system impact
- **CPU**: < 5% during color updates
- **Disk**: < 100MB for all theme files
- **Network**: None (local system only)

### Scalability Considerations
- **Theme Count**: Support 10+ simultaneous themes
- **Update Frequency**: Handle changes every 30 seconds
- **File Size**: Theme files < 1MB each
- **Service Restart**: < 3 seconds for SDDM reload

---

**Status**: Architecture views complete  
**Compliance**: IEEE 1016-2009 standard  
**Next Document**: [06-validation-criteria.md](06-validation-criteria.md)
