import { useNuiEvent } from '../../hooks/useNuiEvent';
import { compassStore, minimapStore } from '../../stores/stats';
import { Transition, useMantineTheme, Box, Text, Group, ThemeIcon, Flex, Divider } from '@mantine/core';
import { BiCurrentLocation } from "react-icons/bi";
import { CompassStore } from "../../typings/stats";

export const MinimapBorder = () => {
  const { visibility, loaded, top, left, width, height } = minimapStore();
  const { open, currentStreet, nextStreet, direction } = compassStore();
  const theme = useMantineTheme();

  useNuiEvent('MINIMAP_LOADED', (data) => {
    if (typeof data === 'object' && data !== null) {
      minimapStore.setState({ ...data, loaded: true });
    }
  });

  useNuiEvent('MINIMAP_UNLOADED', () => {
    minimapStore.setState({ loaded: false });
  });

  useNuiEvent('MINIMAP_SHOW', () => {
    minimapStore.setState({ visibility: true });
  });

  useNuiEvent('MINIMAP_HIDE', () => {
    minimapStore.setState({ visibility: false });
  });

  useNuiEvent<Partial<CompassStore>>('UPDATE_COMPASS', (data) => {
    compassStore.setState(data);
  });

  return (
    <Transition mounted={visibility} transition="slide-right" duration={300} timingFunction="ease">
      {(transStyles) => (
        <>
          <div
            style={{
              position: 'absolute',
              left: left + "%",
              top: top + "%",
              width: width + "px",
              height: height + "px",
              outline: '0.3vh solid #141517',
              boxShadow: `0 0 10px ${theme.colors.dark[8]}`,
              borderRadius: 0,
              pointerEvents: 'none',
              zIndex: 999,
              transition: 'all 0.3s ease-out',
              ...transStyles,
            }}
          />
          <Box
            style={{
              position: 'absolute',
              left: `calc(${left}% - 3px)`,
              top: `calc(${top}% - 55px)`,
              width: `calc(${width}px + 6px)`, 
              backgroundColor: theme.colors.dark[8],
              padding: '0.4rem',
              borderRadius: theme.radius.xxs,
              boxShadow: `0 0 10px ${theme.colors.dark[8]}`,
              pointerEvents: 'none',
              zIndex: 999,
              transition: 'all 0.3s ease-out',
              ...transStyles,
            }}
          >
            <Flex gap="xs" align="center" flex="row"> 
            <Flex direction="column" align="center">
            <Flex
              bg={'var(--mantine-color-teal-light)'}
              style={{
                borderRadius: theme.radius.xs,
                padding: '0.4rem',
                color: 'var(--mantine-color-teal-light-color)',
                boxShadow: `0 0 10px var(--mantine-color-teal-light-hover)`,
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                height: 45,
                width: 45,
                position: 'relative',
              }}
            >
              <Text size="md" fw={700}>
                {direction}
              </Text>
            </Flex>
          </Flex>
              <Flex direction="column" align="flex-start">
              <Flex direction="row" align="center" gap="xs">
              <ThemeIcon color="teal" variant="light" size="sm" style={{ borderRadius: theme.radius.xs, boxShadow: `0 0 10px var(--mantine-color-teal-light-hover)`, }} >
                <BiCurrentLocation size={16} />
              </ThemeIcon>
              <Text size="sm" fw={700} c="teal.6" style={{ textShadow: `0 0 5px ${theme.colors.teal[6]}`}} truncate>
                {currentStreet}
              </Text>
              </Flex>
              
                <Text size="sm" fw={700} style={{ textShadow: '0 0 10px rgba(255, 255, 255, 0.3)' }} c="dimmed" truncate>
                {nextStreet ? nextStreet : 'Not Available'}
                </Text>
             </Flex>
            </Flex>
          </Box>
        </>
      )}
    </Transition>
  );
};