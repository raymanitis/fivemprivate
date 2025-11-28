import React from 'react';
import {createStyles, keyframes, RingProgress, Stack, Text, useMantineTheme, Box} from '@mantine/core';
import {useNuiEvent} from '../../hooks/useNuiEvent';
import {fetchNui} from '../../utils/fetchNui';
import ScaleFade from '../../transitions/ScaleFade';
import type {CircleProgressbarProps} from '../../typings';

const progressCircle = keyframes({
  '0%': { strokeDasharray: `0, ${33.5 * 2 * Math.PI}` },
  '100%': { strokeDasharray: `${33.5 * 2 * Math.PI}, 0` },
});

const useStyles = createStyles((theme, params: { position: 'middle' | 'bottom'; duration: number }) => ({
  container: {
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
  progress: {
    marginTop: "0vh",
    width: "6.9444vh",
    height: "6.9444vh",
    '> svg': {
      display: "flex",
      width: "6.9444vh",
      height: "6.9444vh",
    },
    marginLeft: "-30vh",
    '> svg > circle:nth-child(1)': {
      display: "flex",
      width: "6.9444vh",
      height: "6.9444vh",
      stroke: "radial-gradient(50% 50% at 50% 50%, rgba(217, 217, 217, 0.00) 57.69%, rgba(115, 115, 115, 0.14) 100%)"
    },
    '> svg > circle:nth-child(2)': {
      display: "flex",
      width: "6.9444vh",
      height: "6.9444vh",
      transition: 'none',
      animation: `${progressCircle} linear forwards`,
      animationDuration: `${params.duration}ms`,
      stroke: "#C2F4F9",
      boxShadow: "0 0 1.463vh 0 rgba(194, 244, 249, 0.8)"
    },
  },
  value: {
    textAlign: 'center',
    fontFamily: "Inter",
    textShadow: theme.shadows.sm,
    color: 'rgba(255, 255, 255, 0.5)',
  },
  label: {
    position: 'absolute',
    textAlign: "left",
    marginTop: "-1.75vh",
    marginLeft: "-13.25vh",
    color: "#ffffff",
    fontFamily: "Inter",
    fontSize: "1.25rem",
    fontWeight: 600
  },
  wrapper: {
    marginTop: params.position === 'middle' ? 25 : undefined,
  },
}));

const CircleProgressbar: React.FC = () => {
  const [visible, setVisible] = React.useState(false);
  const [progressDuration, setProgressDuration] = React.useState(0);
  const [position, setPosition] = React.useState<'middle' | 'bottom'>('middle');
  const [value, setValue] = React.useState(0);
  const [label, setLabel] = React.useState('');
  const theme = useMantineTheme();
  const { classes } = useStyles({ position, duration: progressDuration });

  useNuiEvent('progressCancel', () => {
    setValue(99);
    setVisible(false);
  });

  useNuiEvent<CircleProgressbarProps>('circleProgress', (data) => {
    if (visible) return;
    setVisible(true);
    setValue(0);
    setLabel(data.label || '');
    setProgressDuration(data.duration);
    setPosition(data.position || 'middle');
    const onePercent = data.duration * 0.01;
    const updateProgress = setInterval(() => {
      setValue((previousValue) => {
        const newValue = previousValue + 1;
        newValue >= 100 && clearInterval(updateProgress);
        return newValue;
      });
    }, onePercent);
  });

  return (
    <>
        <ScaleFade visible={visible} onExitComplete={() => fetchNui('progressComplete')}>
          <Box className={classes.container}>
            {/* <Stack spacing={0} align="center" className={classes.wrapper}> */}
              <RingProgress
                size={69}
                thickness={6}
                sections={[{ value: 0, color: theme.primaryColor }]}
                onAnimationEnd={() => setVisible(false)}
                className={classes.progress}
              />

              <div className="progbg2"></div>
              {label && <Text className={"classeslabel"}>Progressbar</Text> || <Text className={"classeslabel"}>Progressbar</Text>}
              <div className="percent2">
                <p>{value}%</p>
              </div>
              <div className="percent3">
                <p>{value}%</p>
              </div>

              <div className="pDesc2">The process will be complete when the bar is fully filled..</div>
            {/* </Stack> */}
          </Box>
        </ScaleFade>
    </>
  );
};

export default CircleProgressbar;
