import { Flex, Text, Transition, useMantineTheme, Box, Avatar, Progress } from "@mantine/core";
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
    red: 'rgba(255, 68, 68, 0.3)',
    blue: 'rgba(68, 136, 255, 0.3)',
    teal: 'rgba(194, 244, 249, 0.3)',
    green: 'rgba(68, 255, 136, 0.3)',
    yellow: 'rgba(255, 221, 68, 0.3)',
    cyan: 'rgba(194, 244, 249, 0.3)',
    orange: 'rgba(255, 136, 68, 0.3)',
  };

  const progressColor = colorMap[color] || 'rgba(194, 244, 249, 0.3)';

  return (
    <div style={{ 
      position: 'relative',
    }}>
      <Box
        style={{
          width: '100%',
          height: '100%',
          position: 'absolute',
          borderRadius: theme.radius.xs,
          backgroundColor: progressColor,
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
          bg="var(--bg-primary)" 
          direction="column"
          w={`calc(${width}px + 5px)`}
          h="fit-content"
          gap={0}
          style={{
            ...transStyles,
            zIndex: 100,
            borderRadius: theme.radius.xs,
            boxShadow: `0 0 10px var(--bg-primary)`,
            left: `calc(${left}% - 3px)`,
            top: `calc(${top}% + ${height}px + 5px)`,
          }}
        >
            <Flex align="center" justify="center" direction="row" gap="sm">
            <StatBox 
              value={getVoiceProgress(smoothVoice)} 
              color={'cyan'} 
              Icon={() => <VoiceIcon voiceLevel={voice} talking={talking} />}
            />
            <StatBox value={smoothHealth} color={'red'} Icon={health > 0 ? FaHeartbeat : FaSkull} />
            <StatBox value={smoothArmor} color={'blue'} Icon={FaShieldAlt} />
            <StatBox value={smoothHunger} color={'orange'} Icon={IoRestaurant} />
            <StatBox value={smoothThirst} color={'blue'} Icon={RiDrinks2Fill} />
            <StatBox value={smoothStress} color={'yellow'} Icon={PiBrainFill} />
            </Flex>

          <Box
            mt={10}
          >
            <Progress
              value={smoothStamina}
              color="cyan"
              size="sm"
              transitionDuration={200}
              radius={0}
              styles={{
                root: {
                  backgroundColor: 'var(--bg-button)',
                  boxShadow: `0 0 10px var(--bg-button)`,
                },
                section: {
                  backgroundColor: 'var(--main-accent)',
                  boxShadow: `0 0 10px var(--main-accent)`,
                }
              }}
            />
          </Box>
        </Flex>
      )}
    </Transition>
  );
}