import { MantineThemeOverride } from '@mantine/core';

export const theme: MantineThemeOverride = {
  colorScheme: 'dark',
  fontFamily: 'Inter',
  shadows: { sm: '0 0 0.5rem rgba(194, 244, 249, 0.2)' },
  primaryColor: 'cyan',
  colors: {
    dark: [
      '#ffffff',
      'rgba(255, 255, 255, 0.9)',
      'rgba(255, 255, 255, 0.7)',
      'rgba(255, 255, 255, 0.5)',
      'rgba(255, 255, 255, 0.3)',
      'rgba(18, 26, 28, 0.89)',
      'rgba(18, 26, 28, 0.95)',
      'rgba(8, 12, 14, 0.95)',
      'rgba(0, 0, 0, 0.8)',
      'rgba(0, 0, 0, 0.9)',
    ],
    cyan: [
      '#E3FBFF',
      '#C2F4F9',
      '#A0EDF3',
      '#7EE6ED',
      '#5CDFE7',
      '#3AD8E1',
      '#2EB3BA',
      '#228E93',
      '#17696C',
      '#0B4445',
    ],
  },
  components: {
    Button: {
      styles: {
        root: {
          border: '0.0625rem solid rgba(194, 244, 249, 0.40)',
          borderRadius: '0.15rem',
          backgroundColor: 'rgba(56, 79, 82, 0.31)',
          color: '#ffffff',
          fontFamily: 'Inter',
          fontWeight: 600,
          transition: 'all 0.2s ease',
          '&:hover': {
            backgroundColor: 'rgba(56, 79, 82, 0.45)',
            borderColor: 'rgba(194, 244, 249, 0.67)',
          },
        },
      },
    },
  },
};
