import { Flex, Text, Transition, useMantineTheme, Box, Avatar, Progress } from "@mantine/core";
import { useEffect } from "react";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { FaMicrophone, FaMicrophoneSlash, FaShieldAlt, FaSkull } from "react-icons/fa";
import { FaWalkieTalkie } from "react-icons/fa6";
import { PiBrainFill } from "react-icons/pi";
import { IoRestaurant } from "react-icons/io5";
import { RiDrinks2Fill } from "react-icons/ri";
import { FaHeartbeat } from "react-icons/fa";
import { StatsStore } from "../../typings/stats";
import { minimapStore, statsStore } from "../../stores/stats";
import { vehicleStore } from "../../stores/stats";
import { useTransitionedValue } from "../../utils/useTransitionedValue";

const StatIndicator = ({ 
  value, 
  color, 
  Icon 
}: { 
  value: number; 
  color: string; 
  Icon: React.ElementType 
}) => {
  const theme = useMantineTheme();
  
  const colorMap: Record<string, string> = {
    red: 'var(--mantine-color-red-light-hover)',
    blue: 'var(--mantine-color-blue-light-hover)',
    teal: 'var(--mantine-color-teal-light-hover)',
    green: 'var(--mantine-color-green-light-hover)',
    yellow: 'var(--mantine-color-yellow-light-hover)',
    cyan: 'var(--mantine-color-cyan-light-hover)',
    orange: 'var(--mantine-color-orange-light-hover)',
  };

  const progressColor = colorMap[color] || 'var(--mantine-color-teal-light-hover)';

  return (
    <div style={{ 
      position: 'relative',
    }}>
      <Box
        bg={progressColor}
        style={{
          width: '100%',
          height: '100%',
          position: 'absolute',
          borderRadius: theme.radius.xs,
          transform: `scaleY(${value / 100})`,
          transformOrigin: 'bottom',
          transition: 'transform 0.5s ease-in-out',
          zIndex: 0,
        }}
      />
      <Avatar
        size="2.5rem"
        radius="xs"
        variant="light"
        color={color}
        style={{
          borderRadius: theme.radius.xs,
          boxShadow: `0 0 10px ${progressColor}`,
          position: 'relative',
          zIndex: 1,
        }}
      >
        <Icon size={27} />
      </Avatar>
    </div>
  );
};

export default function PlayerHud() {
  const theme = useMantineTheme();
  const { open, health, armor, hunger, thirst, stress, stamina, voice, talking } = statsStore();
  const { left, top, height, width } = minimapStore();
  const { open: inVehicle } = vehicleStore();

  useNuiEvent<Partial<StatsStore>>('UPDATE_STATS', (data) => {
    statsStore.setState(data);
  });

  const VoiceIcon = ({ voiceLevel, talking }: { voiceLevel: number, talking: string | boolean }) => {
    if (!talking) return <FaMicrophoneSlash size={27} />;
    if (talking == 'voice') return <FaMicrophone size={27} />;
    return <FaWalkieTalkie size={27} />;
  };

  const getVoiceProgress = (voiceLevel: number) => {
    if (voiceLevel === 1.5) return 25;
    if (voiceLevel === 3.0) return 50;
    return 100;
  };

  const StatBox = ({ 
    value, 
    color, 
    Icon, 
  }: { 
    value: number; 
    color: string; 
    Icon: React.ElementType;
  }) => (
    <Flex direction="column" align="center">
      <StatIndicator value={value} color={color} Icon={Icon} />
    </Flex>
  );

  const smoothStamina = useTransitionedValue(stamina, 250);
  const smoothHealth = useTransitionedValue(health, 250);
  const smoothArmor = useTransitionedValue(armor, 250);
  const smoothHunger = useTransitionedValue(hunger, 250);
  const smoothThirst = useTransitionedValue(thirst, 250);
  const smoothStress = useTransitionedValue(stress, 250);
  const smoothVoice = useTransitionedValue(voice, 250);


  return (
    <Transition mounted={open} transition="slide-right" duration={300} timingFunction="ease">
      {(transStyles) => (
        <Flex
          pos="absolute"
          p="0.46rem"
          bg={theme.colors.dark[8]} 
          direction="column"
          w={`calc(${width}px + 5px)`}
          h="fit-content"
          gap={0}
          style={{
            ...transStyles,
            zIndex: 100,
            borderRadius: theme.radius.xs,
            boxShadow: `0 0 10px ${theme.colors.dark[8]}`,
            left: `calc(${left}% - 3px)`,
            top: `calc(${top}% + ${height}px + 5px)`,
          }}
        >
            <Flex align="center" justify="center" direction="row" gap="sm">
            <StatBox 
              value={getVoiceProgress(smoothVoice)} 
              color={'teal'} 
              Icon={() => <VoiceIcon voiceLevel={voice} talking={talking} />}
            />
            <StatBox value={smoothHealth} color={'red'} Icon={health > 0 ? FaHeartbeat : FaSkull} />
            <StatBox value={smoothArmor} color={'blue'} Icon={FaShieldAlt} />
            <StatBox value={smoothHunger} color={'orange'} Icon={IoRestaurant} />
            <StatBox value={smoothThirst} color={'cyan'} Icon={RiDrinks2Fill} />
            <StatBox value={smoothStress} color={'yellow'} Icon={PiBrainFill} />
            </Flex>

          <Box
            mt={10}
          >
            <Progress
              value={smoothStamina}
              color="teal"
              size="sm"
              transitionDuration={200}
              radius={0}
              styles={{
                root: {
                  backgroundColor: theme.colors.dark[6],
                  boxShadow: `0 0 10px ${theme.colors.dark[6]}`,
                },
                section: {
                  backgroundColor: theme.colors.teal[6],
                  boxShadow: `0 0 10px ${theme.colors.teal[6]}`,
                }
              }}
            />
          </Box>
        </Flex>
      )}
    </Transition>
  );
}