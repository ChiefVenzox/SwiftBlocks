## 2024-06-25 - Informing Screen Readers of Custom Element Selection State
**Learning:** Custom selection controls like custom tab bars, color variant pickers, and canvas nodes in Swift UI do not automatically report their selection status to screen readers. VoiceOver users may focus on a selected tab or variant and not realize it is currently selected.
**Action:** Add `.accessibilityAddTraits(.isSelected)` to interactive elements when they represent a selected state in a custom group or picker, ensuring accurate feedback for assistive technologies.
