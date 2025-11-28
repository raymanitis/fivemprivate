import { createTheme } from "@mantine/core";

const theme = createTheme({
  defaultRadius: "xs",
  fontFamily: "'Bai Jamjuree', sans-serif",
  primaryColor: "cyan",

  colors: {
    dark: [
      "#C1C2C5",
      "#A6A7AB",
      "#909296",
      "#5c5f66",
      "#373A40",
      "#2C2E33",
      "#25262b",
      "#1A1B1E",
      "#121a1c",
      "#0f1416",
    ],
    cyan: [
      "#E3FBFF",
      "#C2F4F9",
      "#A1EDF3",
      "#80E6ED",
      "#5FDFE7",
      "#3ED8E1",
      "#2DC2CB",
      "#1F9CA3",
      "#17767B",
      "#0F5053",
    ],
  },
});


export default theme;