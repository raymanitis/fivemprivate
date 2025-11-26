import { Flex, Group, Stack, Text, Image } from '@mantine/core';
import { IconClock } from '@tabler/icons-react';
import React from 'react';
import { useMantineTheme } from '@mantine/core';
import { useHudNuiHandlers, useHudStore } from '../../stores/hudStore';
import { debugData } from '../../utils/debugData';
import { IconMicrophone, IconMicrophoneOff, IconBurger, IconBottle, IconHeartFilled, IconShieldFilled, IconCar, IconUserCheck, IconUserX, IconGasStation, IconAlertTriangle, IconMoodSad, IconBone, IconDroplet, IconBan } from '@tabler/icons-react';
import { useHudScale } from '../../hooks/useHudScale';
import { isEnvBrowser } from '../../utils/misc';
import colorWithAlpha from '../../utils/colorWithAlpha';

function formatSpeed(kmh: number) {
  const speed = Math.round(kmh);
  const speedStr = speed.toString().padStart(3, '0');
  return { first: speedStr[0], rest: speedStr.slice(1), full: speedStr };
}

function glow(color: string): React.CSSProperties {
  return {
    filter: `drop-shadow(0 0 4px ${color}) drop-shadow(0 0 8px ${colorWithAlpha(color, 0.5)})`,
  } as React.CSSProperties;
}

function Compass() {
  const theme = useMantineTheme();
  const { heading, street, zone } = useHudStore((s) => s.compass);
  const cardinal = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  const idx = Math.round(heading / 45) % 8;
  const at = (o: number) => cardinal[(idx + o + 8) % 8];

  return (
    <Stack gap={6} align="center" style={{ pointerEvents: 'none' }}>
      <div style={{
        background: '#111114',
        padding: '8px 14px',
        borderRadius: 10,
        border: '2px solid #15171c',
        boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)',
        display: 'flex',
        alignItems: 'center',
        gap: 10,
        minWidth: 260,
        justifyContent: 'center'
      }}>
        <Text size="xs" c="gray.6">{at(-2)}</Text>
        <Text size="xs" c="gray.6">|</Text>
        <Text size="sm" c="gray.4">{at(-1)}</Text>
        <Text size="xs" c="gray.6">|</Text>
        <div style={{
          padding: '2px 10px',
          borderRadius: 8,
          background: theme.colors.blue[9],
          border: '2px solid #15171c',
          boxShadow: `0 0 6px ${theme.colors.blue[5]}`
        }}>
          <Text fw={700} size="sm" c={theme.colors.blue[2]}>{at(0)}</Text>
        </div>
        <Text size="xs" c="gray.6">|</Text>
        <Text size="sm" c="gray.4">{at(1)}</Text>
        <Text size="xs" c="gray.6">|</Text>
        <Text size="xs" c="gray.6">{at(2)}</Text>
      </div>
      <Text size="md" fw={800} c={theme.colors.gray[0]} style={{ letterSpacing: 0.5, textShadow: '0 1px 2px rgba(0,0,0,0.7)' }}>
        {street.toUpperCase()}
      </Text>
      <Text size="xs" c="gray.6" style={{ textShadow: '0 1px 2px rgba(0,0,0,0.7)' }}>
        {zone.toUpperCase()}
      </Text>
    </Stack>
  );
}

function Speedometer() {
  const theme = useMantineTheme();
  const vehicle = useHudStore((s) => s.vehicle);
  const status = useHudStore((s) => s.status);
  const speedUnit = useHudStore((s) => s.unit);
  
  const SPEED_FONT = 110; // Larger font size to match image
  const TOP_ICON_SIZE = 32; // Slightly smaller top icon
  const ICON_SIZE = 36;
  const ICON_GAP = 6;
  const BOTTOM_ICON_SIZE = 42;
  const BOTTOM_ICON_GAP = 8;
  
  // Convert speed based on unit
  const displaySpeed = speedUnit === 'mph' ? vehicle.speedKmh * 0.621371 : vehicle.speedKmh;
  const speedData = formatSpeed(displaySpeed);
  const speedColor = '#9eff00'; // Bright yellow-green color
  const fadedColor = '#999999'; // Lighter faded gray for placeholder
  
  // Right side stacked icons - fill values
  const rpmPercent = Math.max(0, Math.min(100, (vehicle.rpm ?? 0) * 100));
  const fuelPercent = Math.max(0, Math.min(100, vehicle.fuel ?? 100));
  const eng = Math.max(0, Math.min(100, vehicle.engineHealth ?? 100));
  const hasWarning = eng < 30;
  
  // Bottom row icons - fill values
  const voicePercent = Math.max(0, Math.min(100, status.voice ?? 100));
  const hungerPercent = Math.max(0, Math.min(100, status.hunger ?? 100));
  const healthPercent = Math.max(0, Math.min(100, status.health ?? 100));
  const armourPercent = Math.max(0, Math.min(100, status.armour ?? 100));
  const thirstPercent = Math.max(0, Math.min(100, status.thirst ?? 100));

  return (
    <div style={{ pointerEvents: 'none', position: 'relative' }}>
      {/* Main speed display */}
      <div style={{ display: 'flex', alignItems: 'baseline', gap: 6, marginBottom: 18 }}>
        <div style={{ display: 'flex', alignItems: 'baseline' }}>
          <span style={{ 
            fontSize: SPEED_FONT, 
            lineHeight: 1, 
            color: fadedColor, 
            textShadow: '0 2px 8px rgba(0,0,0,0.8)', 
            fontFamily: 'Segment7, monospace', 
            fontWeight: 400, 
            letterSpacing: 2,
            opacity: 0.5
          }}>
            {speedData.first}
          </span>
          <span style={{ 
            fontSize: SPEED_FONT, 
            lineHeight: 1, 
            color: speedColor, 
            textShadow: `0 0 12px ${speedColor}80, 0 0 20px ${speedColor}40, 0 2px 8px rgba(0,0,0,0.8)`, 
            fontFamily: 'Segment7, monospace', 
            fontWeight: 400, 
            letterSpacing: 2
          }}>
            {speedData.rest}
          </span>
        </div>
        <span style={{ 
          fontSize: 12,
          fontWeight: 500,
          color: theme.colors.gray[0],
          fontFamily: 'Nexa-Book, sans-serif',
          letterSpacing: 0.5,
          textShadow: '0 1px 3px rgba(0,0,0,0.8)',
          marginLeft: 6,
          alignSelf: 'flex-end',
          paddingBottom: 8
        }}>
          {speedUnit === 'mph' ? 'MPH' : 'KM/H'}
        </span>
      </div>

      {/* Right side stacked icons */}
      <div style={{ 
        position: 'absolute', 
        top: 8, 
        right: 0, 
        display: 'flex', 
        flexDirection: 'column', 
        gap: ICON_GAP 
      }}>
        {/* Top icon - RPM indicator with fill - slightly smaller */}
        <div style={{ 
          width: TOP_ICON_SIZE, 
          height: TOP_ICON_SIZE, 
          borderRadius: 4, 
          background: '#111114', 
          border: '2px solid #15171c', 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'center', 
          boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)',
          position: 'relative',
          overflow: 'hidden'
        }}>
          {/* Fill bar from bottom */}
          <div style={{ 
            position: 'absolute', 
            left: 0, 
            right: 0, 
            bottom: 0, 
            height: `${rpmPercent}%`, 
            background: '#545b63',
            borderBottomLeftRadius: 4,
            borderBottomRightRadius: 4,
            zIndex: 1
          }} />
        </div>
        
        {/* Middle icon - Fuel pump with fill bar */}
        <div style={{ 
          width: ICON_SIZE, 
          height: ICON_SIZE, 
          borderRadius: 4, 
          background: '#111114', 
          border: '2px solid #15171c', 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'center', 
          boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)',
          position: 'relative',
          overflow: 'hidden'
        }}>
          {/* Fill bar from bottom */}
          <div style={{ 
            position: 'absolute', 
            left: 0, 
            right: 0, 
            bottom: 0, 
            height: `${Math.max(0, Math.min(100, vehicle.fuel))}%`, 
            background: '#2e230c',
            borderBottomLeftRadius: 4,
            borderBottomRightRadius: 4,
            zIndex: 1
          }} />
          <IconGasStation size={18} color="#d3a30d" stroke={2.5} style={{ position: 'relative', zIndex: 2, ...glow('#d3a30d') }} />
        </div>
        
        {/* Bottom icon - Engine health warning with fill */}
        <div style={{ 
          width: ICON_SIZE, 
          height: ICON_SIZE, 
          borderRadius: 4, 
          background: '#111114', 
          border: '2px solid #15171c', 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'center', 
          boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)',
          position: 'relative',
          overflow: 'hidden',
          opacity: hasWarning ? 1 : 0.6
        }}>
          {/* Fill bar from bottom */}
          <div style={{ 
            position: 'absolute', 
            left: 0, 
            right: 0, 
            bottom: 0, 
            height: `${eng}%`, 
            background: hasWarning ? '#371c1e' : '#152d1a',
            borderBottomLeftRadius: 4,
            borderBottomRightRadius: 4,
            zIndex: 1
          }} />
          <IconAlertTriangle size={18} color={hasWarning ? '#cf5a59' : theme.colors.gray[5]} stroke={2.5} style={{ position: 'relative', zIndex: 2, ...glow(hasWarning ? '#cf5a59' : theme.colors.gray[5]) }} />
        </div>
      </div>

      {/* Bottom row of 5 icons */}
      <div style={{ display: 'flex', gap: BOTTOM_ICON_GAP, alignItems: 'center', marginTop: 22 }}>
        {/* Dark blue - No entry/mute (voice) */}
        <div style={{ 
          width: BOTTOM_ICON_SIZE, 
          height: BOTTOM_ICON_SIZE, 
          borderRadius: 6, 
          background: '#111114', 
          border: '2px solid #15171c', 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'center', 
          boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)',
          position: 'relative',
          overflow: 'hidden'
        }}>
          {/* Fill bar from bottom */}
          <div style={{ 
            position: 'absolute', 
            left: 0, 
            right: 0, 
            bottom: 0, 
            height: `${voicePercent}%`, 
            background: '#545b63',
            borderBottomLeftRadius: 6,
            borderBottomRightRadius: 6,
            zIndex: 1
          }} />
          {/* Pink overlay when talking */}
          {status.talking && (
            <div style={{ 
              position: 'absolute', 
              left: 0, 
              right: 0, 
              bottom: 0, 
              height: `${voicePercent}%`, 
              background: theme.colors.pink?.[9] || '#2a0f1c',
              borderBottomLeftRadius: 6,
              borderBottomRightRadius: 6,
              zIndex: 2
            }} />
          )}
          <IconBan size={20} color={status.talking ? (theme.colors.pink?.[4] || '#e64980') : theme.colors.gray[5]} stroke={2} style={{ position: 'relative', zIndex: 3, ...glow(status.talking ? (theme.colors.pink?.[4] || '#e64980') : theme.colors.gray[5]) }} />
        </div>
        
        {/* Orange - Sad face (hunger) */}
        <div style={{ 
          width: BOTTOM_ICON_SIZE, 
          height: BOTTOM_ICON_SIZE, 
          borderRadius: 6, 
          background: '#111114', 
          border: '2px solid #15171c', 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'center', 
          boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)',
          position: 'relative',
          overflow: 'hidden'
        }}>
          {/* Fill bar from bottom */}
          <div style={{ 
            position: 'absolute', 
            left: 0, 
            right: 0, 
            bottom: 0, 
            height: `${hungerPercent}%`, 
            background: '#302510',
            borderBottomLeftRadius: 6,
            borderBottomRightRadius: 6,
            zIndex: 1
          }} />
          <IconMoodSad size={20} color="#ca9b13" stroke={2} style={{ position: 'relative', zIndex: 2, ...glow('#ca9b13') }} />
        </div>
        
        {/* Red - Heart (health) */}
        <div style={{ 
          width: BOTTOM_ICON_SIZE, 
          height: BOTTOM_ICON_SIZE, 
          borderRadius: 6, 
          background: '#111114', 
          border: '2px solid #15171c', 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'center', 
          boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)',
          position: 'relative',
          overflow: 'hidden'
        }}>
          {/* Fill bar from bottom */}
          <div style={{ 
            position: 'absolute', 
            left: 0, 
            right: 0, 
            bottom: 0, 
            height: `${healthPercent}%`, 
            background: '#311919',
            borderBottomLeftRadius: 6,
            borderBottomRightRadius: 6,
            zIndex: 1
          }} />
          <IconHeartFilled size={20} color="#d25556" stroke={2} style={{ position: 'relative', zIndex: 2, ...glow('#d25556') }} />
        </div>
        
        {/* Light green - Bone (armor) */}
        <div style={{ 
          width: BOTTOM_ICON_SIZE, 
          height: BOTTOM_ICON_SIZE, 
          borderRadius: 6, 
          background: '#111114', 
          border: '2px solid #15171c', 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'center', 
          boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)',
          position: 'relative',
          overflow: 'hidden'
        }}>
          {/* Fill bar from bottom */}
          <div style={{ 
            position: 'absolute', 
            left: 0, 
            right: 0, 
            bottom: 0, 
            height: `${armourPercent}%`, 
            background: '#122232',
            borderBottomLeftRadius: 6,
            borderBottomRightRadius: 6,
            zIndex: 1
          }} />
          <IconBone size={20} color="#2c7cbe" stroke={2} style={{ position: 'relative', zIndex: 2, ...glow('#2c7cbe') }} />
        </div>
        
        {/* Light blue - Droplet (thirst) */}
        <div style={{ 
          width: BOTTOM_ICON_SIZE, 
          height: BOTTOM_ICON_SIZE, 
          borderRadius: 6, 
          background: '#111114', 
          border: '2px solid #15171c', 
          display: 'flex', 
          alignItems: 'center', 
          justifyContent: 'center', 
          boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)',
          position: 'relative',
          overflow: 'hidden'
        }}>
          {/* Fill bar from bottom */}
          <div style={{ 
            position: 'absolute', 
            left: 0, 
            right: 0, 
            bottom: 0, 
            height: `${thirstPercent}%`, 
            background: '#122232',
            borderBottomLeftRadius: 6,
            borderBottomRightRadius: 6,
            zIndex: 1
          }} />
          <IconDroplet size={20} color="#2c7cbe" stroke={2} style={{ position: 'relative', zIndex: 2, ...glow('#2c7cbe') }} />
        </div>
      </div>
    </div>
  );
}

export default function Hud() {
  useHudNuiHandlers();
  const visible = useHudStore((s) => s.visible);
  const { scale, px } = useHudScale();
  const setVehicle = useHudStore((s) => s.setVehicle);
  const vehicleHud = useHudStore((s) => s.vehicle);
  const compassConfig = useHudStore((s) => s.compass);
  const uiConfig = useHudStore((s) => s.uiConfig);
  const topRight = useHudStore((s) => s.topRight);

  debugData<any>([
    { action: 'HUD_SET_VISIBLE', data: true },
    { action: 'HUD_STATUS', data: { health: 100, armour: 50, hunger: 80, thirst: 60, voice: 70 } },
    { action: 'HUD_VEHICLE', data: { speedKmh: 11, fuel: 60, engineOn: true, lightsOn: true, rpm: 0.35 } },
    { action: 'HUD_COMPASS', data: { heading: 22, street: 'ALHAMBRA DR', zone: 'ZANCUDO AVE' } },
    { action: 'HUD_CONFIG', data: { showCompassOnFoot: true, topRight: { idShow: true, timeEnable: true, ingameTime: false, logoEnable: true, logo: 'https://r2.fivemanage.com/43z7Bt109UNYve2xRiuvK/reallogo.png' } } },
    { action: 'HUD_TOPRIGHT', data: { playerId: 12, timeStr: '14:32' } },
  ], 250);
  
  React.useEffect(() => {
    if (import.meta.env.MODE === 'development' && isEnvBrowser()) {
      let rpm = 0;
      let dir = 1;
      // Set initial vehicle data for dev mode
      setVehicle({ 
        inVehicle: true, 
        speedKmh: 0, 
        fuel: 100, 
        engineOn: false, 
        lightsOn: false, 
        seatbeltOn: false, 
        rpm: 0,
        engineHealth: 100
      });
      const id = setInterval(() => {
        rpm += dir * 0.05;
        if (rpm >= 1) { rpm = 1; dir = -1; }
        if (rpm <= 0) { rpm = 0; dir = 1; }
        setVehicle({ rpm, inVehicle: true });
      }, 60);
      return () => clearInterval(id);
    }
  }, [setVehicle]);

  const isDevMode = import.meta.env.MODE === 'development';
  
  if (!visible) return null;

  return (
    <Flex pos="fixed" w="100vw" h="100vh" style={{ pointerEvents: 'none', ['--hud-scale-base' as any]: String(scale) }}>
      {(compassConfig.showCompassOnFoot || vehicleHud.inVehicle || isDevMode) && (
        <div style={{ position: 'absolute', top: 20, left: '50%', transform: 'translateX(-50%)' }} data-hud-scale data-origin="tc">
          <Compass />
        </div>
      )}
      
      {(vehicleHud.inVehicle || isDevMode) && (
        <div style={{ position: 'absolute', right: 24, bottom: 28 }} data-hud-scale data-origin="br">
          <Speedometer />
        </div>
      )}
      
      {(uiConfig?.topRight?.idShow || uiConfig?.topRight?.timeEnable || uiConfig?.topRight?.logoEnable) && (
        <div style={{ position: 'absolute', right: 24, top: 20 }} data-hud-scale data-origin="tr">
          <Group gap={10} align="center">
            <Stack gap={8}>
              {uiConfig?.topRight?.idShow && (
                <div style={{ background: '#111114', border: '2px solid #15171c', borderRadius: 8, padding: '8px 12px', boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)', width: 92 }}>
                  <Text fw={700} size="sm" c="gray.2" style={{ whiteSpace: 'nowrap' }}>ID: {String(topRight.playerId ?? '')}</Text>
                </div>
              )}
              {uiConfig?.topRight?.timeEnable && (
                <div style={{ background: '#111114', border: '2px solid #15171c', borderRadius: 8, padding: '8px 12px', boxShadow: '0 1px 2px rgba(0,0,0,0.8) inset, 0 2px 8px rgba(0,0,0,0.45)', width: 92 }}>
                  <Group gap={8} align="center" wrap="nowrap">
                    <IconClock size={16} color="#adb5bd" />
                    <Text fw={700} size="sm" c="gray.2" style={{ whiteSpace: 'nowrap' }}>{topRight.timeStr ?? ''}</Text>
                  </Group>
                </div>
              )}
            </Stack>
            {uiConfig?.topRight?.logoEnable && uiConfig?.topRight?.logo && (
              <div style={{ width: 100, height: 100, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <Image src={uiConfig.topRight.logo} w={100} h={100} fit="contain" alt="logo"/>
              </div>
            )}
          </Group>
        </div>
      )}
    </Flex>
  );
}


