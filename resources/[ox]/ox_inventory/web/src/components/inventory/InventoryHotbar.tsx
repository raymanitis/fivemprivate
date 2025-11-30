import React, { useState } from 'react';
import { getItemUrl, isSlotWithItem } from '../../helpers';
import useNuiEvent from '../../hooks/useNuiEvent';
import { Items } from '../../store/items';
import WeightBar from '../utils/WeightBar';
import { useAppSelector } from '../../store';
import { selectLeftInventory } from '../../store/inventory';
import { SlotWithItem } from '../../typings';
import SlideUp from '../utils/transitions/SlideUp';
import { Rarity } from '../../store/rarity';

const InventoryHotbar: React.FC = () => {
  const [hotbarVisible, setHotbarVisible] = useState(false);
  const items = useAppSelector(selectLeftInventory).items.slice(0, 4);

  // stupid fix for timeout
  const [handle, setHandle] = useState<NodeJS.Timeout>();
  useNuiEvent('toggleHotbar', () => {
    if (hotbarVisible) {
      setHotbarVisible(false);
    } else {
      if (handle) clearTimeout(handle);
      setHotbarVisible(true);
      setHandle(setTimeout(() => setHotbarVisible(false), 3000));
    }
  });

  const rarityColors = Rarity;

  const withAlpha = (color: string, alpha: number) => {
    return color.replace(/rgba?\(([^)]+)\)/, (match, contents) => {
      if (!contents) return match;
      const parts = contents.split(',').map((p: string) => p.trim());
      if (parts.length === 3) {
        return `rgba(${parts.join(', ')}, ${alpha})`;
      } else if (parts.length === 4) {
        return `rgba(${parts[0]}, ${parts[1]}, ${parts[2]}, ${alpha})`;
      }
      return match;
    });
  };

  return (
    <SlideUp in={hotbarVisible}>
      <div className="hotbar-container">
        {items.map((item) => {
          // Default to "common" if rarity is not specified
          const itemRarity = item?.rarity || 'common';
          const rarityKey = itemRarity.toLowerCase();
          const rarityColor = rarityColors[rarityKey] || rarityColors['common'];

          return (
            <div
              key={`hotbar-${item.slot}`}
              className="hotbar-item-slot"
              style={{
                borderRadius: '4px',
                padding: '8px',
                border: rarityColor
                  ? '1px solid transparent'
                  : '1px dashed rgba(255,255,255,0.4)',
                background: rarityColor
                  ? `
              ${item?.name ? `url(${getItemUrl(item as SlotWithItem)}) center / 35% 35% no-repeat padding-box,` : ''}
              linear-gradient(45deg, #161616bb, #000000e0) padding-box,
              linear-gradient(-45deg, rgba(255,255,255,0.0), ${withAlpha(rarityColor, 1)}) border-box
            `
                  : `
              ${item?.name ? `url(${getItemUrl(item as SlotWithItem)}) center / 35% 35% no-repeat padding-box,` : ''}
              linear-gradient(45deg, #161616bb, #000000e0) padding-box,
              linear-gradient(135deg, rgba(255,255,255,0.336), rgba(0,0,0,0.589)) border-box
            `,
                boxShadow: rarityColor
                  ? `inset 0px 0px 40px -20px ${withAlpha(rarityColor, 0.5)}`
                  : 'inset 0px 0px 40px -10px rgba(0,0,0, 1)',
              }}
            >
              {isSlotWithItem(item) && (
                <div className="item-slot-wrapper">
                  <div className="hotbar-slot-header-wrapper">
                    <div
                      className="inventory-slot-number"
                    >{item.slot}</div>
                    <div className={`item-slot-info-wrapper with-slot-number slot-${item.slot}`}>
                      {item.count && item.count > 1 ? (
                        <>
                          <p>{item.count.toLocaleString('en-us') + `x`}</p>
                          {item.weight > 0 && (
                            <p className="item-weight-text">
                              {item.weight >= 1000
                                ? `${(item.weight / 1000).toLocaleString('en-us', {
                                    minimumFractionDigits: 2,
                                  })}kg`
                                : `${item.weight.toLocaleString('en-us', {
                                    minimumFractionDigits: 0,
                                  })}g`}
                            </p>
                          )}
                        </>
                      ) : (
                        item.weight > 0 && (
                          <p className="item-weight-text">
                            {item.weight >= 1000
                              ? `${(item.weight / 1000).toLocaleString('en-us', {
                                  minimumFractionDigits: 2,
                                })}kg`
                              : `${item.weight.toLocaleString('en-us', {
                                  minimumFractionDigits: 0,
                                })}g`}
                          </p>
                        )
                      )}
                    </div>
                  </div>
                  {/* Rarity badge positioned same as main inventory */}
                  <div 
                    className="inventory-slot-rarity"
                    style={{
                      color: rarityColor || Rarity['common'],
                    }}
                  >
                    {itemRarity}
                  </div>
                  <div>
                    {item?.durability !== undefined && (
                      <WeightBar percent={item.durability} durability />
                    )}
                    <div className="inventory-slot-label-box">
                      <div className="inventory-slot-label-text">
                        {item.metadata?.label
                          ? item.metadata.label
                          : Items[item.name]?.label || item.name}
                      </div>
                    </div>
                  </div>
                </div>
              )}
            </div>
          );
        })}
      </div>
    </SlideUp>
  );
};

export default InventoryHotbar;
