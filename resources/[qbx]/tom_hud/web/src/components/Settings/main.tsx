import { useState, useEffect } from "react";
import { 
  Modal, 
  Tabs, 
  Select, 
  Text, 
  Title, 
  Stack, 
  Group, 
  Transition,
  useMantineTheme,
  Box,
  Divider,
} from "@mantine/core";
import { useDisclosure } from "@mantine/hooks";
import { fetchNui } from "../../utils/fetchNui";
import { minimapStore, statsStore, vehicleStore } from "../../stores/stats";
import { useTransitionedValue } from "../../utils/useTransitionedValue";
import "../App.css";
import { useNuiEvent } from "../../hooks/useNuiEvent";

const SettingsModal = () => {
  const theme = useMantineTheme();
  const [opened, setOpened] = useState<boolean>(false);
  const [activeTab, setActiveTab] = useState<string | null>('cinematic');
  const [barsHeight, setBarsHeight] = useState<string>('0');
  const [barsVisible, setBarsVisible] = useState(barsHeight !== '0');

  const smoothHeight = useTransitionedValue(parseInt(barsHeight), 300);

  const handleBarsToggle = (value: string | null, _option?: any) => {
    const heightValue = value || '0';
    setBarsHeight(heightValue);
    const shouldShow = heightValue !== '0';
    setBarsVisible(shouldShow);
  
    fetchNui('toggleCinematicBars', { 
      enabled: shouldShow,
      height: parseInt(heightValue)
    });
  };

  useNuiEvent('TOGGLE_SETTINGS', (data: any) => {
    setOpened(data);
  });

  const handleClose = () => {
    setOpened(false);
    fetchNui('closeSettings');
  };


  const CinematicBars = () => {
    if (!barsVisible) return null;
    
    return (
      <Box style={{
        position: 'fixed',
        top: 0,
        left: 0,
        width: '100%',
        height: '100%',
        pointerEvents: 'none',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'space-between'
      }}>
        {/* Top bar */}
        <Box
            style={{
                height: `${smoothHeight}%`,
                width: '100%',
                backgroundColor:'#000000',
                position: 'absolute',
                top: 0,
            }}
        />

        <Box
            style={{
                height: `${smoothHeight}%`,
                width: '100%',
                backgroundColor:'#000000',
                position: 'absolute',
                bottom: 0,
            }}
        />
      </Box>
    );
  };

  return (
    <>
      <CinematicBars />
      
      <Modal
        opened={opened}
        onClose={handleClose}
        centered
        withCloseButton={false}
        size="lg"
        styles={{
          title: {
            fontWeight: 700,
            fontSize: '1.5rem',
          },
          body: {
            backgroundColor: theme.colors.dark[8],
            boxShadow: `0 0 10px ${theme.colors.dark[8]}`,
          },
        }}
      >
        <Tabs value={activeTab} onChange={setActiveTab} variant="pills" color="blue.4">
          <Tabs.List grow>
            <Tabs.Tab value="player">Player</Tabs.Tab>
            <Tabs.Tab value="vehicle">Vehicle</Tabs.Tab>
            <Tabs.Tab value="cinematic">Cinematic</Tabs.Tab>
          </Tabs.List>

          <Divider my="sm" />

          <Tabs.Panel value="player" pt="md">
            <Stack>
              <Text size="sm" c="dimmed">
                Player UI settings coming soon
              </Text>
            </Stack>
          </Tabs.Panel>

          <Tabs.Panel value="vehicle" pt="md">
            <Stack>
              <Text size="sm" c="dimmed">
                Vehicle UI settings coming soon
              </Text>
            </Stack>
          </Tabs.Panel>

          <Tabs.Panel value="cinematic" pt="md">
            <Stack gap="xl">
              <Group justify="space-between" align="flex-end">
                <Stack gap={0}>
                  <Title order={4}>Cinematic Bars</Title>
                  <Text size="sm" c="dimmed">
                    Add black bars for cinematic effect
                  </Text>
                </Stack>
                
                <Select
                  value={barsHeight}
                  onChange={handleBarsToggle}
                  data={[
                    { value: '0', label: 'Disabled' },
                    { value: '10', label: 'Small (10%)' },
                    { value: '15', label: 'Medium (15%)' },
                    { value: '20', label: 'Large (20%)' },
                    { value: '25', label: 'Extra Large (25%)' },
                  ]}
                  style={{ width: '180px' }}
                  styles={{
                    input: {
                      backgroundColor: theme.colors.dark[6],
                      borderColor: theme.colors.dark[4],
                    },
                    dropdown: {
                      backgroundColor: theme.colors.dark[6],
                      borderColor: theme.colors.dark[4],
                    },
                    option: {
                      '&[data-selected]': {
                        backgroundColor: theme.colors.dark[4],
                        color: theme.colors.gray[0],
                      },
                      '&:hover': {
                        backgroundColor: theme.colors.dark[5],
                      },
                    },
                  }}
                />
              </Group>
              
              <Box>
                <Title order={5} mb="xs">Preview</Title>
                <Box 
                  style={{
                    height: '150px',
                    backgroundColor: theme.colors.dark[6],
                    borderRadius: theme.radius.sm,
                    position: 'relative',
                    overflow: 'hidden',
                  }}
                >
                  <Box
                    style={{
                      position: 'absolute',
                      top: 0,
                      left: 0,
                      right: 0,
                      height: `${barsHeight}%`,
                      backgroundColor: theme.colors.dark[9],
                      transition: 'height 0.3s ease',
                    }}
                  />
                  <Box
                    style={{
                      position: 'absolute',
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: `${barsHeight}%`,
                      backgroundColor: theme.colors.dark[9],
                      transition: 'height 0.3s ease',
                    }}
                  />
                  <Box
                    style={{
                      display: 'flex',
                      alignItems: 'center',
                      justifyContent: 'center',
                      height: '100%',
                    }}
                  >
                    <Text c="dimmed">Cinematic preview</Text>
                  </Box>
                </Box>
              </Box>
            </Stack>
          </Tabs.Panel>
        </Tabs>
      </Modal>
    </>
  );
};

export default SettingsModal;
