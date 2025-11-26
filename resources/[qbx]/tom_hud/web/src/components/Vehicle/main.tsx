import { Flex, Box, Progress, Text, useMantineTheme, Avatar, Divider, Transition } from "@mantine/core";
import { useNuiEvent } from "../../hooks/useNuiEvent";
import { FaGasPump } from "react-icons/fa";
import { FaFireFlameCurved } from "react-icons/fa6";
import { PiEngineFill, PiSeatbeltFill } from "react-icons/pi";
import { VehicleStore } from "../../typings/stats";
import { minimapStore, vehicleStore } from "../../stores/stats";
import Speedometer from "./Speedometer/Speedometer";
import { useTransitionedValue } from "../../utils/useTransitionedValue";

export default function VehicleHud() {
  const theme = useMantineTheme();
  const { open, speed, rpm, gears, currentGear, fuel, engineHealth, seatbelt, distance, nos } = vehicleStore();
  const { visibility, loaded, top, left, width, height } = minimapStore();

  useNuiEvent<Partial<VehicleStore>>("UPDATE_VEHICLE", (data) => {
    vehicleStore.setState(data);
  });

  const smoothSpeed = useTransitionedValue(speed, 250);
  const smoothEngineHealth = useTransitionedValue(engineHealth, 250);
  const smoothFuel = useTransitionedValue(fuel, 250);
  const smoothNos = useTransitionedValue(nos, 250);
  const smoothDistance = useTransitionedValue(distance, 250);
  const smoothSeatbelt = useTransitionedValue(seatbelt ? 100 : 50, 250);
  const smoothRpm = useTransitionedValue(rpm, 250);

  const getFuelColor = () => {
    if (fuel > 50) return "green";
    if (fuel > 20) return "yellow";
    return "red";
  };

  const getEngineColor = () => {
    if (engineHealth > 70) return "green";
    if (engineHealth > 30) return "yellow";
    return "red";
  };

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
      green: 'var(--mantine-color-green-light-hover)',
      yellow: 'var(--mantine-color-yellow-light-hover)',
      cyan: 'var(--mantine-color-cyan-light-hover)',
    };
  
    const progressColor = colorMap[color] || 'var(--mantine-color-blue-light-hover)';
  
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
  
  return (
    <Transition mounted={open} transition="slide-left" duration={300} timingFunction="ease">
      {(transStyles) => (
        <div style={{
          position: 'absolute',
          top: `${top}%`,
          left: `calc(100% - ${left}% - ${width}px)`,
          perspective: '1000px',
          transformStyle: 'preserve-3d',
          zIndex: 100,
          ...transStyles,
        }}>
          <div style={{
            transform: 'rotateY(-15deg)',
            backfaceVisibility: 'hidden',
            transformStyle: 'preserve-3d',
            willChange: 'transform',
          }}>
            <Box
              p="xs"
              style={{
                zIndex: 100,
                ...transStyles,
              }}
            >
              <Flex justify="center" align="center" direction="column" gap="0">
                <Speedometer
                  speed={smoothSpeed}
                  maxRpm={100}
                  rpm={rpm}
                  gears={gears}
                  currentGear={currentGear}
                  engineHealth={smoothEngineHealth}
                  distance={smoothDistance}
                  speedUnit={"KPH"} />
                <Flex p="0.3rem" align="center" justify="center" direction="row" gap="sm" mt="md" w="fit-content"
                style={{
                  backgroundColor: theme.colors.dark[8],
                  boxShadow: `0 0 10px ${theme.colors.dark[8]}`,
                  borderRadius: theme.radius.xs,
                }}>
                  <div style={{ 
                      position: 'relative',
                    }}>
                    <Box
                      bg={'var(--mantine-color-blue-light)'}
                      style={{
                        width: '100%',
                        height: '100%',
                        position: 'absolute',
                        borderRadius: theme.radius.xs,
                        zIndex: 0,
                      }}
                    />
                    <Avatar
                      size="2.5rem"
                      radius="xs"
                      variant="light"
                      color={'blue'}
                      style={{
                        borderRadius: theme.radius.xs,
                        boxShadow: `0 0 10px var(--mantine-color-blue-light-hover)`,
                        position: 'relative',
                        zIndex: 1,
                      }}
                    >
                      <Text size="xl" fw={700}>{currentGear}</Text>
                    </Avatar>
                  </div>
                  <StatBox 
                    value={smoothSeatbelt} 
                    color={seatbelt ? 'green' : 'red'} 
                    Icon={PiSeatbeltFill} 
                  />
                  <StatBox value={smoothFuel} color={getFuelColor()} Icon={FaGasPump} />
                  <StatBox value={smoothEngineHealth} color={getEngineColor()} Icon={PiEngineFill} />
                  {nos > 0 && (
                    <StatBox value={smoothNos} color={'violet'} Icon={FaFireFlameCurved} />
                  )}
                </Flex>
              </Flex>
            </Box>
          </div>
        </div>
      )}
    </Transition>
  );
}