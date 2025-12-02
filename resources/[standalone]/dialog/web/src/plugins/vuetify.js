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
          primary: '#C2F4F9',
          secondary: '#C2F4F9',
          bg: 'transparent',
          surface: 'transparent',
          'on-surface': '#ffffff',
          'on-primary': '#121a1c',
        },
      },
    },
  },
})
