# Changelog

## [4.0.0] - 2025-06-02

### ✨ Added
- **Major Feature**: Editable stamp functionality
- New `isStampEditable` property to toggle between instant stamp and editable stamp modes
- Interactive stamp editing: drag, resize, rotate, delete
- Visual editing handles for stamp manipulation
- Enhanced touch handling for complex stamp interactions

### 🔧 Changed
- **BREAKING CHANGE**: Minimum iOS deployment target raised to iOS 13.0
- **BREAKING CHANGE**: Stamp behavior can now be controlled via `isStampEditable` flag
- Improved undo/redo functionality for editable stamps
- Enhanced graphics context isolation for pen effects

### ❌ Removed
- Support for iOS 9.0-12.x (now requires iOS 13.0+)

### 🐛 Fixed
- Pen effects (blur/neon) no longer affect stamp editing UI elements

## [3.1.0] - Previous Release
