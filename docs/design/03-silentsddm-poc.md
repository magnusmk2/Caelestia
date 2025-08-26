# SilentSDDM Proof of Concept Implementation

**Document**: PoC Phase - SilentSDDM Integration  
**Author**: Magnus  
**Date**: 2025-01-26  
**Status**: Ready for Implementation  

## PoC Objectives

1. **Prove feasibility** of SilentSDDM + Caelestia color integration
2. **Test visual consistency** between login and desktop
3. **Validate technical approach** before full automation
4. **Identify potential issues** early in the process

## Implementation Plan

### Phase 1: Backup & Preparation
- [x] **Document current SDDM setup** (Catppuccin-Mocha-Mauve)
- [x] **Backup SDDM configuration** files
- [x] **Verify system requirements** (Qt6, SDDM 0.21.0)
- [ ] **Create rollback procedure** documentation

### Phase 2: SilentSDDM Installation
- [ ] **Install SilentSDDM** via AUR package
- [ ] **Verify base installation** works correctly
- [ ] **Test with default theme** before customization

### Phase 3: Manual Color Integration
- [ ] **Extract current Caelestia colors** from scheme.json
- [ ] **Create custom theme variant** with Caelestia colors
- [ ] **Configure SDDM** to use new theme
- [ ] **Test login functionality**

### Phase 4: Validation & Documentation
- [ ] **Visual consistency check** (screenshots)
- [ ] **Functional testing** (login, logout, reboot)
- [ ] **Document findings** and lessons learned
- [ ] **Plan automation approach** based on results

## Technical Implementation

### Current System State
```bash
# SDDM Version
sddm --version  # 0.21.0

# Current Theme
cat /etc/sddm.conf.d/*.conf
# [Theme]
# Current=catppuccin-mocha-mauve

# Available Themes
ls /usr/share/sddm/themes/
# catppuccin-mocha-mauve
```

### Caelestia Colors (Current Scheme: shadotheme)
```json
{
  "background": "#131317",
  "surface": "#131317", 
  "primary": "#bfc1ff",
  "onPrimary": "#282b60",
  "onSurface": "#e5e1e7",
  "surfaceContainer": "#1f1f23",
  "outline": "#918f9a",
  "onSurfaceVariant": "#c7c5d1"
}
```

### SilentSDDM Theme Configuration
```ini
# /usr/share/sddm/themes/caelestia-silent/theme.conf
[General]
type=color
background=#131317
backgroundMode=fill

# Text Colors
textColor=#e5e1e7
placeholderTextColor=#c7c5d1
sessionTextColor=#e5e1e7
clockColor=#e5e1e7
dateColor=#c7c5d1

# Input Fields
inputBackgroundColor=#1f1f23
inputTextColor=#e5e1e7
inputBorderColor=#918f9a
inputFocusColor=#bfc1ff

# Buttons
buttonBackgroundColor=#bfc1ff
buttonTextColor=#282b60
buttonHoverColor=#6f72ac
buttonPressColor=#565992

# System Elements
powerButtonColor=#bfc1ff
sessionButtonColor=#bfc1ff
userButtonColor=#bfc1ff

# Layout
fontSize=12
fontFamily=Inter
borderRadius=8
spacing=16
```

## Step-by-Step Implementation

### Step 1: System Backup
```bash
# Backup current SDDM configuration
sudo cp -r /etc/sddm.conf.d /etc/sddm.conf.d.backup.$(date +%Y%m%d_%H%M%S)

# Backup current theme
sudo cp -r /usr/share/sddm/themes/catppuccin-mocha-mauve \
           /usr/share/sddm/themes/catppuccin-mocha-mauve.backup
```

### Step 2: Install SilentSDDM
```bash
# Install via AUR
yay -S sddm-theme-silent

# Verify installation
ls /usr/share/sddm/themes/ | grep -i silent
```

### Step 3: Create Caelestia Variant
```bash
# Copy SilentSDDM as base
sudo cp -r /usr/share/sddm/themes/SilentSDDM \
           /usr/share/sddm/themes/caelestia-silent

# Create custom theme.conf with Caelestia colors
sudo tee /usr/share/sddm/themes/caelestia-silent/theme.conf << 'EOF'
[General]
type=color
background=#131317
backgroundMode=fill
textColor=#e5e1e7
# ... (full configuration from above)
EOF
```

### Step 4: Configure SDDM
```bash
# Create Caelestia SDDM configuration
sudo tee /etc/sddm.conf.d/caelestia.conf << 'EOF'
[Theme]
Current=caelestia-silent
CursorTheme=Adwaita
CursorSize=24

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot
EOF
```

### Step 5: Test Implementation
```bash
# Test SDDM configuration
sudo sddm --test-mode --theme caelestia-silent

# If test passes, restart SDDM service
sudo systemctl restart sddm
```

## Success Criteria

### Visual Consistency
- [ ] **Background color** matches Caelestia desktop
- [ ] **Text colors** are readable and consistent
- [ ] **Primary accent** (blue) matches desktop theme
- [ ] **Input fields** have consistent styling
- [ ] **Buttons** match desktop button styling

### Functional Requirements
- [ ] **Login works** with username/password
- [ ] **Session selection** functions correctly
- [ ] **Power options** (shutdown/reboot) work
- [ ] **Virtual keyboard** appears on touch screens
- [ ] **Multi-monitor** setup displays correctly

### Technical Validation
- [ ] **No SDDM errors** in system logs
- [ ] **Theme loads** without Qt/QML errors
- [ ] **Performance** is acceptable (fast load times)
- [ ] **Rollback works** if needed

## Risk Mitigation

### High-Risk Scenarios
1. **SDDM fails to start** → Use TTY to restore backup config
2. **Login screen broken** → Boot to recovery mode, restore files
3. **Theme conflicts** → Remove custom theme, restart SDDM

### Rollback Procedure
```bash
# Emergency rollback
sudo rm /etc/sddm.conf.d/caelestia.conf
sudo systemctl restart sddm

# Full rollback
sudo cp -r /etc/sddm.conf.d.backup.* /etc/sddm.conf.d/
sudo rm -rf /usr/share/sddm/themes/caelestia-silent
sudo systemctl restart sddm
```

## Interface Specifications

### Input Interfaces
```json
// ~/.local/state/caelestia/scheme.json
{
  "colours": {
    "m3background": "131317",
    "m3onSurface": "e5e1e7",
    "m3primary": "bfc1ff",
    "m3onPrimary": "282b60"
    // ... additional M3 colors
  }
}
```

### Output Interfaces
```ini
# /usr/share/sddm/themes/caelestia-silent/theme.conf
[General]
background=#131317
textColor=#e5e1e7
buttonBackgroundColor=#bfc1ff
buttonTextColor=#282b60
```

### System Interfaces
- **File System**: Read access to `~/.local/state/caelestia/scheme.json`
- **SDDM Service**: Write access to `/usr/share/sddm/themes/` (requires sudo)
- **System Control**: Ability to restart SDDM service via systemctl

## Expected Outcomes

### Success Scenario
- **Visual harmony** between login and desktop
- **Functional login screen** with Caelestia theming
- **Proof of concept** for automated color sync
- **Clear path forward** for full implementation

### Learning Opportunities
- **SilentSDDM customization** capabilities and limitations
- **SDDM configuration** best practices
- **Color mapping** effectiveness
- **System integration** challenges

## Next Steps After PoC

### If Successful
1. **Document exact process** for automation
2. **Design color sync system** architecture
3. **Plan repository structure** integration
4. **Begin automated implementation**

### If Issues Found
1. **Analyze root causes** of problems
2. **Research alternative approaches**
3. **Adjust color mapping** strategy
4. **Consider different login manager** options

---

**Status**: Ready for implementation  
**Next Action**: Begin Step 1 - System Backup  
**Next Document**: [04-implementation-log.md](04-implementation-log.md)
