import React, { useMemo } from 'react';

const colorChannelMixer = (colorChannelA: number, colorChannelB: number, amountToMix: number) => {
  let channelA = colorChannelA * amountToMix;
  let channelB = colorChannelB * (1 - amountToMix);
  return channelA + channelB;
};

const colorMixer = (rgbA: number[], rgbB: number[], amountToMix: number) => {
  let r = colorChannelMixer(rgbA[0], rgbB[0], amountToMix);
  let g = colorChannelMixer(rgbA[1], rgbB[1], amountToMix);
  let b = colorChannelMixer(rgbA[2], rgbB[2], amountToMix);
  return `rgb(${r}, ${g}, ${b})`;
};

const COLORS = {
  // Mantine Teal Theme Colors
  tealPrimary: [18, 184, 134], // Mantine teal[6] (#12b886) - Main accent
  tealHover: [32, 201, 151], // Mantine teal[5] (#20c997) - Hover
  tealLight: [38, 198, 148], // Mantine teal[4] - Lighter teal
  tealDark: [15, 166, 117], // Mantine teal[7] - Darker teal
};

const WeightBar: React.FC<{ percent: number; durability?: boolean }> = ({ percent, durability }) => {
  const { color, shadowColor } = useMemo(
    () => {
      if (durability) {
        // Durability bar: teal gradient based on durability (Mantine teal[6])
        const durabilityColor = percent < 50
          ? colorMixer(COLORS.tealDark, COLORS.tealPrimary, percent / 100)
          : colorMixer(COLORS.tealPrimary, COLORS.tealHover, percent / 100);
        return { color: durabilityColor, shadowColor: 'rgba(18, 184, 134, 0.46)' };
      } else {
        // Weight bar: teal gradient based on weight percentage
        // Uses teal colors throughout - lighter teal for low weight, darker teal for high weight
        let weightColor: string;
        let shadow: string;
        
        if (percent <= 50) {
          // Light to medium weight: lighter teal
          const normalizedPercent = percent / 50; // 0-1 range for 0-50%
          weightColor = colorMixer(COLORS.tealLight, COLORS.tealPrimary, normalizedPercent);
          shadow = 'rgba(18, 184, 134, 0.3)';
        } else {
          // Medium to heavy weight: darker teal
          const normalizedPercent = (percent - 50) / 50; // 0-1 range for 50-100%
          weightColor = colorMixer(COLORS.tealPrimary, COLORS.tealDark, normalizedPercent);
          shadow = 'rgba(15, 166, 117, 0.4)';
        }
        
        return { color: weightColor, shadowColor: shadow };
      }
    },
    [durability, percent]
  );

  return (
    <div className={durability ? 'durability-bar' : 'weight-bar'}>
      <div
        style={{
          visibility: percent > 0 ? 'visible' : 'hidden',
          height: '100%',
          width: `${percent}%`,
          borderRadius: '10rem',
          backgroundColor: color,
          boxShadow: `0 0 1.2685vh 0 ${shadowColor}`,
          transition: `background-color ${0.3}s ease, width ${0.3}s ease, box-shadow ${0.3}s ease`,
        }}
      ></div>
    </div>
  );
};
export default WeightBar;
