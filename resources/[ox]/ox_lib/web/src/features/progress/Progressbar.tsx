import React from 'react';
import { Box, createStyles, Text } from '@mantine/core';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import { fetchNui } from '../../utils/fetchNui';
import ScaleFade from '../../transitions/ScaleFade';
import type { ProgressbarProps } from '../../typings';

const useStyles = createStyles((theme) => ({
  container: {
    width: "36vh",
    height: "0.5556vh",
    overflow: 'hidden',
    marginTop: "4.75vh",
    borderRadius: "5.5556vh",
    background: "rgba(255, 255, 255, 0.08)"
  },
  wrapper: {
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'center',
    bottom: "8.7037vh",
    left: "69.05vh",
    position: 'absolute',
    borderRadius: "0.25rem",
    width: "40vh",
    height: "8.2778vh",
    border: "0.0625rem solid rgba(194, 244, 249, 0.40)",
    background: "rgba(18, 26, 28, 0.89)"
  },
  bar: {
    height: '100%',
    background: "#C2F4F9",
    borderRadius: "5.5556vh",
    boxShadow: "0 0 1.463vh 0 rgba(194, 244, 249, 0.8)",
  },
  labelWrapper: {
    position: 'absolute',
    display: 'flex',
    alignItems: 'center',
    justifyContent: 'flex-start',
    width: "38.8889vh",
    height: "3.5vh",
    top: "0.9259vh",
    left: "2.5vh",
  },
  label: {
    color: "#ffffff",
    fontFamily: "Inter",
    fontSize: "1.2963vh",
    fontWeight: 600,
    lineHeight: 1.2,
    whiteSpace: 'nowrap'
  },
}));

const Progressbar: React.FC = () => {
  const { classes } = useStyles();
  const [visible, setVisible] = React.useState(false);
  const [label, setLabel] = React.useState('');
  const [duration, setDuration] = React.useState(0);
  const [percent, setPercent] = React.useState(0);
  const intervalRef = React.useRef<NodeJS.Timeout | null>(null);

  useNuiEvent('progressCancel', () => {
    setVisible(false);
    if (intervalRef.current) {
      clearInterval(intervalRef.current);
      intervalRef.current = null;
    }
  });

  useNuiEvent<ProgressbarProps>('progress', (data) => {
    // Clear any existing interval
    if (intervalRef.current) {
      clearInterval(intervalRef.current);
      intervalRef.current = null;
    }

    setVisible(true);
    setLabel(data.label);
    setDuration(data.duration);
    setPercent(0);

    const start = Date.now();
    intervalRef.current = setInterval(() => {
      const elapsed = Date.now() - start;
      const percentage = Math.min((elapsed / data.duration) * 100, 100);
      setPercent(percentage);
      if (percentage >= 100) {
        if (intervalRef.current) {
          clearInterval(intervalRef.current);
          intervalRef.current = null;
        }
      }
    }, 100);
  });

  // Cleanup interval on unmount
  React.useEffect(() => {
    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
        intervalRef.current = null;
      }
    };
  }, []);

  return (
    <>
        <ScaleFade visible={visible} onExitComplete={() => fetchNui('progressComplete')}>
          <Box className={classes.wrapper}>
            <Box className={classes.labelWrapper}>
              <Text className={classes.label}>{label}</Text>
              <div className="percent">
                <p>{Math.round(percent)}%</p>
              </div>
            </Box>
            <div className="pDesc">The process will be complete when the bar is fully filled..</div>
            <Box className={classes.container}>
              <Box
                className={classes.bar}
                onAnimationEnd={() => setVisible(false)}
                sx={{
                  animation: 'progress-bar linear',
                  animationDuration: `${duration}ms`,
                }}
              ></Box>
            </Box>
          </Box>
        </ScaleFade>
    </>
  );
};

export default Progressbar;
