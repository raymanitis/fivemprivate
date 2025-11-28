import React, { useCallback, useEffect, useMemo, useRef } from "react";
import { Flex, Text, useMantineTheme } from "@mantine/core";
import { PiEngineFill } from "react-icons/pi";
import { useTransitionedValue } from "../../../utils/useTransitionedValue";

interface SpeedometerProps {
  speed: number;
  maxRpm: number;
  rpm: number;
  gears: number;
  currentGear: string;
  engineHealth: number;
  distance: number;
  speedUnit: "MPH" | "KPH";
}

const Speedometer: React.FC<SpeedometerProps> = React.memo(function Speedometer({ 
  speed = 50, 
  maxRpm = 100, 
  rpm = 20, 
  gears = 8, 
  distance = 0,
  currentGear, 
}) {
  const activeArcRef = useRef<SVGPathElement>(null);
  const requestRef = useRef<number>();
  const previousTimeRef = useRef<number>();
  
  // Use a more performant animation approach
  const smoothRpm = useTransitionedValue(rpm, 250);
  
  // Memoize all calculations
  const { createArc, createGearLine, polarToCartesian } = useMemo(() => {
    const polarToCartesian = (
      centerX: number, 
      centerY: number, 
      radius: number, 
      angleInDegrees: number
    ) => {
      const angleInRadians = ((angleInDegrees - 90) * Math.PI) / 180.0;
      return {
        x: centerX + radius * Math.cos(angleInRadians),
        y: centerY + radius * Math.sin(angleInRadians),
      };
    };
    
    const createArc = (
      x: number, 
      y: number, 
      radius: number, 
      startAngle: number, 
      endAngle: number
    ) => {
      const start = polarToCartesian(x, y, radius, startAngle);
      const end = polarToCartesian(x, y, radius, endAngle);
      const largeArcFlag = endAngle - startAngle <= 180 ? "0" : "1";
      return ["M", start.x, start.y, "A", radius, radius, 0, largeArcFlag, 1, end.x, end.y].join(" ");
    };
    
    const createGearLine = (
      centerX: number, 
      centerY: number, 
      innerRadius: number, 
      outerRadius: number, 
      angle: number
    ) => {
      const inner = polarToCartesian(centerX, centerY, innerRadius, angle);
      const outer = polarToCartesian(centerX, centerY, outerRadius, angle);
      return `M ${inner.x} ${inner.y} L ${outer.x} ${outer.y}`;
    };
    
    return { createArc, createGearLine, polarToCartesian };
  }, []);

  const theme = useMantineTheme();
  
  // Pre-calculate the arc path
  const arcPath = useMemo(() => createArc(0, 0, 44, -120, 120), [createArc]);

  // Use requestAnimationFrame for smoother animations
  const animateArc = useCallback((time: number) => {
    if (previousTimeRef.current === undefined) {
      previousTimeRef.current = time;
    }
    
    const deltaTime = time - previousTimeRef.current;
    previousTimeRef.current = time;
    
    if (activeArcRef.current && deltaTime < 100) { // Throttle to prevent over-updating
      const length = activeArcRef.current.getTotalLength();
      const offset = length * (1 - smoothRpm / 100);
      activeArcRef.current.style.strokeDasharray = `${length}`;
      activeArcRef.current.style.strokeDashoffset = `${offset}`;
    }
    
    requestRef.current = requestAnimationFrame(animateArc);
  }, [smoothRpm]);

  useEffect(() => {
    requestRef.current = requestAnimationFrame(animateArc);
    return () => {
      if (requestRef.current) {
        cancelAnimationFrame(requestRef.current);
      }
    };
  }, [animateArc]);

  // Memoize gear lines to prevent recalculations
  const gearLines = useMemo(() => {
    return Array.from({ length: gears }).map((_, i) => {
      const angle = -120 + (i * 240) / Math.max((gears - 1), 1);
      return (
        <path
          key={`gear-${i}`}
          d={createGearLine(0, 0, 46, 40, angle)}
          stroke="#dee2e6"
          strokeWidth="0.1"
          opacity="100"
          strokeLinecap="round"
        />
      );
    });
  }, [gears, createGearLine]);

  // Memoize speed display
  const speedDisplay = useMemo(() => {
    const speedStr = String(Math.round(speed)).padStart(3, '0');
    return speedStr.split('').map((digit, index) => (
      <Text
        key={index}
        size="5.5rem"
        ta="center"
        style={{
          textShadow: digit !== '0' || speed >= Math.pow(10, 2 - index) || speedStr.length > (2 - index)
            ? `0 0 10px ${theme.colors.teal[6]}`
            : `0 0 10px ${theme.colors.gray[6]}`,
          display: 'inline-block',
        }}
        fw={500}
        ff="digital-7"
        c={(digit !== '0' || speed >= Math.pow(10, 2 - index) || speedStr.length > (2 - index))
            ? theme.colors.teal[6]
            : theme.colors.gray[6]}
      >
        {digit}
      </Text>
    ));
  }, [speed, theme]);

  // Memoize distance display
  const distanceDisplay = useMemo(() => {
    const distanceStr = String(Math.round(distance)).padStart(6, '0');
    return distanceStr.split('').map((digit, index) => (
      <Text
        key={index}
        size="1.5rem"
        ff="digital-7"
        style={{
          textShadow: digit !== '0' || distance >= Math.pow(10, 5 - index) 
            ? `0 0 5px ${theme.colors.teal[6]}` 
            : `0 0 5px ${theme.colors.gray[6]}`,
        }}
        c={(digit !== '0' || distance >= Math.pow(10, 5 - index)) 
          ? theme.colors.teal[6] 
          : theme.colors.gray[6]}
      >
        {digit}
      </Text>
    ));
  }, [distance, theme]);

  return (
    <div className="speedometer-container">
      <svg 
        viewBox="-50 -50 100 100" 
        preserveAspectRatio="xMidYMid meet" 
        className="speedometer-svg"
      >
        <defs>
          <filter id="glow">
            <feGaussianBlur stdDeviation="2.5" result="coloredBlur" />
            <feMerge>
              <feMergeNode in="coloredBlur" />
              <feMergeNode in="SourceGraphic" />
            </feMerge>
          </filter>
        </defs>
        <g>
          <path
            d={arcPath}
            fill="none" 
            stroke={theme.colors.dark[8]} 
            strokeWidth="5" 
          />
          <path 
            filter="url(#glow)"
            ref={activeArcRef}
            d={arcPath}
            fill="none"
            strokeWidth="5"
            className="speedometer-active-arc"
            style={{
              stroke: smoothRpm >= 90 ? theme.colors.red[4] : theme.colors.teal[6],
            }}
          />
        </g>
        {gearLines}
      </svg>
      <div className="speedometer-content">
        <div className="speedometer-text-container">
          <Flex gap="0.5vh" style={{ width: '180px', justifyContent: 'center' }}>
            {speedDisplay}
          </Flex>
          <Flex 
            ml="10px" 
            align="center" 
            justify="center" 
            direction="row" 
            h="fit-content" 
            w="120px" 
            style={{
              backgroundColor: theme.colors.dark[8],
              boxShadow: `0 0 10px ${theme.colors.dark[8]}`,
              borderRadius: theme.radius.xs,
            }}
          >
            {distanceDisplay}
          </Flex>
        </div>
      </div>
    </div>
  );
});

// CSS Styles
const styles = `
  .speedometer-container {
    width: 240px;
    height: 256px;
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-bottom: -80px;
    z-index: 0;
  }

  @media (min-width: 2560px) {
    .speedometer-container {
      width: 15dvw;
      height: 21dvh;
    }
  }

  @media (min-width: 3840px) {
    .speedometer-container {
      width: 10dvw;
      height: 20dvh;
    }
  }

  .speedometer-svg {
    width: 100%;
    height: 100%;
  }

  .speedometer-active-arc {
    transition: all 300ms ease-in-out;
  }

  .speedometer-content {
    position: absolute;
    inset: 0;
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .speedometer-text-container {
    text-align: center;
    justify-content: center;
    align-items: center;
    display: flex;
    flex-direction: column;
  }

  .speedometer-gear {
    position: absolute;
    margin-top: -20px;
    left: 50%;
    transform: translateX(-50%);
    font-size: 1vw;
    font-weight: 600;
    color: #9ca3af;
    font-variant-numeric: tabular-nums;
    margin-left: 4px;
  }

  .speedometer-speed {
    font-size: 2vw;
    font-weight: 700;
    color: white;
    font-variant-numeric: tabular-nums;
    margin-left: 8px;
  }

  .speedometer-unit {
    font-size: 1vw;
    margin-top: -4px;
    font-weight: 600;
    color: #9ca3af;
    text-shadow: 0 1.2px 1.2px rgba(0,0,0,1);
    margin-left: 16px;
    text-transform: uppercase;
  }

  .engine-warning {
    display: flex;
    align-items: center;
    justify-content: center;
    margin-top: 4px;
  }

  .engine-warning > * {
    text-shadow: 0 1.2px 1.2px rgba(0,0,0,1);
    width: 0.9vw;
    height: 0.9vw;
    color: #dc2626;
  }
`;

// Inject styles
const styleSheet = document.createElement("style");
styleSheet.type = "text/css";
styleSheet.innerText = styles;
document.head.appendChild(styleSheet);

export default Speedometer;
