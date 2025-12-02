/**
 * plugins/vuetify.js
 *
 * Framework documentation: https://vuetifyjs.com`
 */

// Styles
import '@mdi/font/css/materialdesignicons.css'
import 'vuetify/styles'

// Composables
import { createVuetify } from 'vuetify'

// https://vuetifyjs.com/en/introduction/why-vuetify/#feature-guides
export default createVuetify({
  theme: {
    defaultTheme: 'dark',
    themes: {
      dark: {
        colors: {
          primary: '#C2F4F9', // Bright cyan - main accent color
          secondary: '#384f52', // Darker teal
          bg: '#121a1c', // Dark teal background
          surface: 'transparent', // Transparent background
          background: 'transparent', // Transparent background
          'on-primary': '#121a1c', // Dark text on cyan
          'on-surface': '#C2F4F9', // Cyan text on dark
        },
      },
    },
  },
})
