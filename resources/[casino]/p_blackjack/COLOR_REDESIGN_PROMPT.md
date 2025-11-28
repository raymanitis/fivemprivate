# Color Redesign Prompt

## Task Description
Redesign the web interface colors to match Mantine UI's default dark theme color scheme. **Only change color values - do not modify any other styles, layouts, spacing, fonts, or functionality.**

## Color Specifications

### Background Colors
- **Main background**: `#1a1b1e` (Mantine dark background)
- **Surface/Card background**: `#25262b` (Mantine surface color)
- **Background with transparency**: `#1a1b1ee3` and `#25262bde`

### Accent Color
- **Primary accent color**: `#12b886` (Mantine teal[6])
- **Accent color with transparency**: `#12b8861e` (for item backgrounds)
- **Accent color border**: `#12b88667` (for borders with transparency)

### Text Colors
- **Primary text**: `#c1c2c5` (Mantine body text color)
- **Muted/Secondary text**: `#909296` (Mantine muted text color)

### UI Element Colors
- **Key wrapper background**: `#373a404f` (Mantine gray with transparency)
- **Border colors**: `#373a40` with appropriate opacity (e.g., `#373a4014` for subtle borders)

## Implementation Rules
1. **ONLY modify color values** - hex codes, rgba values, and color variables
2. **DO NOT change**:
   - Layout properties (display, flex, grid, positioning)
   - Spacing (padding, margin, gap)
   - Typography (font-family, font-size, font-weight)
   - Border radius, shadows, or other visual effects
   - JavaScript functionality
   - HTML structure
   - Animations or transitions (except color transitions)

## Color Mapping Reference

| Original Color | Mantine Replacement | Usage |
|---------------|---------------------|-------|
| `#121a1c` | `#1a1b1e` | Main backgrounds |
| `#121a1cde` | `#25262bde` | Surface/card backgrounds |
| `#C2F4F9` (cyan) | `#12b886` (teal[6]) | Primary accent color |
| `#c2f4f91e` | `#12b8861e` | Accent with transparency |
| `#c2f4f967` | `#12b88667` | Accent borders |
| `#384f524f` | `#373a404f` | UI element backgrounds |
| `#ffffff14` | `#373a4014` | Subtle borders |
| `rgba(255, 255, 255, 0.5)` | `#909296` | Muted text |
| `#fff` | `#c1c2c5` | Primary text |

## Notes
- Maintain all existing CSS structure and selectors
- Keep all transparency values (opacity suffixes) the same, only change base colors
- Preserve all CSS variables in `:root` but update their color values
- Ensure color contrast meets accessibility standards for readability


