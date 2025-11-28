import { Text, Transition, Flex, useMantineTheme, Button, Stack, Card } from '@mantine/core';
import { useEffect, useState, useRef } from 'react';
import { isEnvBrowser } from '../../utils/misc';
import { HeartPulse, Cross } from 'lucide-react';

interface AmbulanceMessage {
  type: string;
  text?: string;
  timer?: number;
  canCallHelp?: boolean;
  helpCooldown?: number;
}

function formatTime(seconds: number): string {
  const mins = Math.floor(seconds / 60);
  const secs = seconds % 60;
  return `${mins}:${secs.toString().padStart(2, '0')}`;
}

export function UI() {
  const theme = useMantineTheme();
  const isBrowser = isEnvBrowser();
  const [isVisible, setIsVisible] = useState(isBrowser);
  const [respawnTimer, setRespawnTimer] = useState<number | null>(isBrowser ? 900 : null);
  const [canCallHelp, setCanCallHelp] = useState(true);
  const [helpCooldown, setHelpCooldown] = useState<number | null>(null);
  const intervalRef = useRef<ReturnType<typeof setInterval> | null>(null);

  useEffect(() => {
    const handleMessage = (event: MessageEvent<AmbulanceMessage>) => {
      const data = event.data;
      

      if (data.type === 'ambulance_reset') {
        setIsVisible(false);
        setRespawnTimer(null);
        setCanCallHelp(true);
        setHelpCooldown(null);
        if (intervalRef.current) {
          clearInterval(intervalRef.current);
          intervalRef.current = null;
        }
      } else if (data.type === 'eliminated' || data.type === 'knocked_down') {
        setIsVisible(true);
        setRespawnTimer(data.timer ?? 900); // Default 15 minutes
        setCanCallHelp(true); // Always allow showing help text
        setHelpCooldown(data.helpCooldown ?? null);
      } else if (data.type === 'update_respawn_timer') {
        setRespawnTimer(data.timer ?? null);
      } else if (data.type === 'update_respawn_available') {
        setRespawnTimer(0);
      } else if (data.type === 'help_called') {
        setHelpCooldown(data.helpCooldown ?? 300); // 5 minutes cooldown
      } else if (data.type === 'update_help_cooldown') {
        setHelpCooldown(data.helpCooldown ?? null);
      }
    };

    window.addEventListener('message', handleMessage);
    return () => window.removeEventListener('message', handleMessage);
  }, []);

  // Countdown timer effect
  useEffect(() => {
    if (intervalRef.current) {
      clearInterval(intervalRef.current);
    }

    if (!isVisible) {
      intervalRef.current = null;
      return;
    }

    intervalRef.current = setInterval(() => {
      if (respawnTimer !== null && respawnTimer > 0) {
        setRespawnTimer((prev) => (prev !== null && prev > 0 ? prev - 1 : 0));
      }
      if (helpCooldown !== null && helpCooldown > 0) {
        setHelpCooldown((prev) => {
          const newVal = prev !== null && prev > 0 ? prev - 1 : 0;
          if (newVal === 0) {
            setCanCallHelp(true);
          }
          return newVal;
        });
      }
    }, 1000);

    return () => {
      if (intervalRef.current) {
        clearInterval(intervalRef.current);
      }
    };
  }, [isVisible, respawnTimer, helpCooldown]);

  // Expose test functions for dev mode
  useEffect(() => {
    if (isBrowser) {
      (window as any).testAmbulanceUI = {
        show: () => {
          setRespawnTimer(900);
          setCanCallHelp(true);
          setIsVisible(true);
        },
        reset: () => {
          setIsVisible(false);
          setRespawnTimer(null);
          setCanCallHelp(true);
          setHelpCooldown(null);
        },
      };
    }
  }, [isBrowser]);

  if (!isVisible || respawnTimer === null) return null;

  return (
    <>
      <Transition mounted={isVisible} transition="fade" duration={400} timingFunction="ease">
        {(transStyles) => (
          <Flex
            pos="fixed"
            w="100vw"
            h="100vh"
            style={{
              ...transStyles,
              pointerEvents: 'none',
              justifyContent: 'center',
              alignItems: 'flex-end',
              paddingBottom: '40px',
              inset: 0,
              zIndex: 1000,
            }}
          >
            <Stack gap="xs" align="center" style={{ width: '100%', maxWidth: '450px' }}>
              {/* Help Call Prompt or Cooldown - Always show one message */}
              <Card
                p="sm"
                style={{
                  backgroundColor: 'rgba(0, 0, 0, 0.7)',
                  border: `1px solid ${theme.colors.dark[6]}`,
                  borderRadius: theme.radius.md,
                  boxShadow: '0 2px 10px rgba(0,0,0,0.5)',
                  width: 'fit-content',
                  maxWidth: '100%',
                }}
              >
                <Text
                  size="sm"
                  fw={600}
                  ta="center"
                  c="white"
                  style={{
                    fontFamily: 'Nexa-Book, sans-serif',
                    textShadow: '0 2px 4px rgba(0,0,0,0.5)',
                    whiteSpace: 'nowrap',
                  }}
                >
                  {helpCooldown !== null && helpCooldown > 0 ? (
                    <>
                      Help already called. Available again in{' '}
                      <Text
                        component="span"
                        c="red"
                        fw={700}
                        style={{
                          backgroundColor: 'rgba(0,0,0,0.3)',
                          padding: '2px 6px',
                          borderRadius: '4px',
                        }}
                      >
                        {formatTime(helpCooldown)}
                      </Text>
                    </>
                  ) : (
                    <>
                      Press{' '}
                      <Text
                        component="span"
                        c="red"
                        fw={700}
                        style={{
                          backgroundColor: 'rgba(0,0,0,0.3)',
                          padding: '2px 6px',
                          borderRadius: '4px',
                        }}
                      >
                        [H]
                      </Text>{' '}
                      to call for help
                    </>
                  )}
                </Text>
              </Card>

              {/* Main Timer Panel - Always the same */}
              <Card
                p="sm"
                style={{
                  backgroundColor: theme.colors.dark[8],
                  border: `1px solid ${theme.colors.dark[6]}`,
                  borderRadius: theme.radius.md,
                  minWidth: '280px',
                  maxWidth: '320px',
                  boxShadow: '0 4px 20px rgba(0,0,0,0.5)',
                }}
              >
                {/* Timer Display with Icons */}
                <Flex align="center" gap="md" justify="space-between" style={{ width: '100%' }}>
                  {/* Left Icon */}
                  <HeartPulse
                    size={20}
                    color={theme.colors.red[6]}
                    style={{ flexShrink: 0 }}
                  />

                  {/* Timer Display */}
                  <Text
                    size="xl"
                    fw={700}
                    c="white"
                    style={{
                      fontFamily: 'monospace',
                      fontSize: '1.5rem',
                      letterSpacing: '2px',
                    }}
                  >
                    {formatTime(respawnTimer)}
                  </Text>

                  {/* Right Icon */}
                  <Cross
                    size={20}
                    color={theme.colors.red[6]}
                    style={{ flexShrink: 0 }}
                  />
                </Flex>
              </Card>
            </Stack>
          </Flex>
        )}
      </Transition>

      {/* Dev Controls - Only visible in browser/dev mode */}
      {isBrowser && (
        <Card
          pos="fixed"
          top={20}
          right={20}
          p="md"
          style={{
            zIndex: 10000,
            backgroundColor: theme.colors.dark[8],
            border: `1px solid ${theme.colors.dark[6]}`,
            minWidth: '280px',
          }}
        >
          <Stack gap="xs">
            <Text size="sm" fw={600} c="white">
              🔧 Dev Controls
            </Text>
            <Button
              size="xs"
              variant="light"
              onClick={() => {
                setRespawnTimer(900);
                setCanCallHelp(true);
                setHelpCooldown(null);
                setIsVisible(true);
              }}
            >
              Show UI (15min)
            </Button>
            <Button
              size="xs"
              variant="light"
              onClick={() => {
                setCanCallHelp(false);
                setHelpCooldown(300);
              }}
            >
              Call Help (5min cooldown)
            </Button>
            <Button
              size="xs"
              variant="light"
              color="red"
              onClick={() => {
                setIsVisible(false);
                setRespawnTimer(null);
                setCanCallHelp(true);
                setHelpCooldown(null);
              }}
            >
              Reset/Hide
            </Button>
          </Stack>
        </Card>
      )}
    </>
  );
}
