## 2026-07-04 - Custom Tab Bars Drop Screen Reader State
**Learning:** Custom SwiftUI tab bars built with standard `Button`s and `.buttonStyle(.plain)` do not automatically convey their selected state to VoiceOver, even if the background visually indicates selection.
**Action:** When building custom tab bars, always manually apply `.accessibilityAddTraits(isSelected ? .isSelected : [])` to ensure screen readers announce the currently active tab correctly.
