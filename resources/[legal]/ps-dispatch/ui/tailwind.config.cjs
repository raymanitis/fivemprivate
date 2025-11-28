module.exports = {
  darkmode: true,
  content: [
    "./index.html",
    "./src/**/*.{svelte,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        // Mantine Dark Theme Colors
        primary: '#25262B',        // dark-6
        secondary: '#2C2E33',      // dark-5
        tertiary: '#373A40',       // dark-4
        priority_primary: '#2C1F24',
        priority_secondary: '#33252A',
        priority_tertiary: '#3D2E35',
        priority_quaternary: '#9A003A',
        // Mantine Green Accent Colors
        accent: '#51cf66',         // green-6
        accent_green: '#51cf66',   // green-6
        accent_dark_green: '#37b24d', // green-7
        accent_cyan: '#51cf66',    // green-6 (using green instead of cyan)
        // Mantine Red Accent Colors
        accent_red: '#fa5252',     // red-6
        accent_dark_red: '#e03131', // red-7
        border_primary: '#373A40',  // dark-4
        hover_secondary: '#2C2E33', // dark-5
        // Additional Mantine colors for text
        text_primary: '#C1C2C5',   // dark-0
        text_secondary: '#A6A7AB', // dark-1
        text_muted: '#909296',     // dark-2
        background: '#1A1B1E',     // dark-7
      }
    },
  },
  plugins: [],
}
