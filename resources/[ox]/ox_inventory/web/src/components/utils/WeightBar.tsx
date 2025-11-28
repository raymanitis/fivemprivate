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
  // Cyan Gaming Theme Colors
  cyanPrimary: [194, 244, 249], // Main accent (#C2F4F9)
  cyanHover: [200, 247, 252], // Lighter cyan for hover
  cyanLight: [227, 251, 255], // Light cyan (#E3FBFF)
  cyanDark: [157, 212, 224], // Darker cyan (#9dd4e0)
};

const WeightBar: React.FC<{ percent: number; durability?: boolean }> = ({ percent, durability }) => {
  const { color, shadowColor } = useMemo(
    () => {
      if (durability) {
        // Durability bar: cyan gradient based on durability
        const durabilityColor = percent < 50
          ? colorMixer(COLORS.cyanDark, COLORS.cyanPrimary, percent / 100)
          : colorMixer(COLORS.cyanPrimary, COLORS.cyanHover, percent / 100);
        return { color: durabilityColor, shadowColor: 'rgba(194, 244, 249, 0.46)' };
      } else {
        // Weight bar: cyan gradient based on weight percentage
        // Uses cyan colors throughout - lighter cyan for low weight, darker cyan for high weight
        let weightColor: string;
        let shadow: string;
        
        if (percent <= 50) {
          // Light to medium weight: lighter cyan
          const normalizedPercent = percent / 50; // 0-1 range for 0-50%
          weightColor = colorMixer(COLORS.cyanLight, COLORS.cyanPrimary, normalizedPercent);
          shadow = 'rgba(194, 244, 249, 0.3)';
        } else {
          // Medium to heavy weight: darker cyan
          const normalizedPercent = (percent - 50) / 50; // 0-1 range for 50-100%
          weightColor = colorMixer(COLORS.cyanPrimary, COLORS.cyanDark, normalizedPercent);
          shadow = 'rgba(157, 212, 224, 0.4)';
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
