import React, { useState } from 'react';
import { DragSource, Inventory, InventoryType, Slot, SlotWithItem } from '../../typings';
import { getItemUrl, isSlotWithItem } from '../../helpers';
import useNuiEvent from '../../hooks/useNuiEvent';
import { Items } from '../../store/items';
import WeightBar from '../utils/WeightBar';
import { useAppSelector } from '../../store';
import { selectLeftInventory } from '../../store/inventory';
import SlideUp from '../utils/transitions/SlideUp';

const InventoryHotbar: React.FC = () => {
  const [hotbarVisible, setHotbarVisible] = useState(false);
  const items = useAppSelector(selectLeftInventory).items.slice(0, 5);

  //stupid fix for timeout
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

    const getDurabilityGradient = (item: Slot) => {
    if (item?.durability === undefined) return 'linear-gradient(to bottom, rgba(255,215,0, 0), rgba(255,215,0, 0))';

      let durability = item?.durability
      
      if (durability >= 75) {
        return 'linear-gradient(-180deg, rgba(46, 204, 113, 0.00) 0%, rgba(46, 204, 113, 0.24) 100%), radial-gradient(188.13% 188.13% at 50% 50%, rgba(153, 153, 153, 0.0) 0%, rgba(255, 255, 255, 0.0) 100%)';
      } else if (durability >= 50) {
        return 'linear-gradient(-180deg, rgba(48, 144, 182, 0.00) 0%, rgba(48, 144, 182, 0.30) 100%), radial-gradient(188.13% 188.13% at 50% 50%, rgba(153, 153, 153, 0.0) 0%, rgba(255, 255, 255, 0.0) 100%)';
      } else if (durability >= 15) {
        return 'linear-gradient(-180deg, rgba(192, 224, 15, 0.00) 0%, rgba(192, 224, 15, 0.24) 100%), radial-gradient(188.13% 188.13% at 50% 50%, rgba(153, 153, 153, 0.0) 0%, rgba(255, 255, 255, 0.0) 100%)';
      } else if (durability == -1) {
        return 'linear-gradient(-180deg, rgba(182, 48, 48, 0.00) 0%, rgba(182, 48, 48, 0.0) 100%), radial-gradient(188.13% 188.13% at 50% 50%, rgba(153, 153, 153, 0.0) 0%, rgba(255, 255, 255, 0.0) 100%)';
      } else if (durability == 0) {
        return 'linear-gradient(-180deg, rgba(182, 48, 48, 0.00) 0%, rgba(182, 48, 48, 0.30) 100%), radial-gradient(188.13% 188.13% at 50% 50%, rgba(153, 153, 153, 0.0) 0%, rgba(255, 255, 255, 0.0) 100%)';
      } else {
        return 'linear-gradient(-180deg, rgba(182, 48, 48, 0.00) 0%, rgba(182, 48, 48, 0.30) 100%), radial-gradient(188.13% 188.13% at 50% 50%, rgba(153, 153, 153, 0.0) 0%, rgba(255, 255, 255, 0.0) 100%)';
      }
    }; 

  return (
    <SlideUp in={hotbarVisible}>
      <div className="hotbar-container">
        {items.map((item) => (
          <div
            className="hotbar-item-slot"
            
            style={{
              backgroundImage: item?.name
              ? `url(${getItemUrl(item as SlotWithItem)}), ${getDurabilityGradient(item)}`
              : 'none',
              backgroundSize: '5vh auto, cover',
              backgroundPosition: 'center, center',
              backgroundRepeat: 'no-repeat, no-repeat',
            }}
            key={`hotbar-${item.slot}`}
          >
            {<div className="inventory-slot-number">{item.slot}</div>}
            {isSlotWithItem(item) && (
              <div className="item-slot-wrapper">
                <div className="hotbar-slot-header-wrapper">
                  <div className="item-slot-info-wrapper2">
                    <p>
                      {item.weight > 0
                        ? item.weight >= 1000
                          ? `${(item.weight / 1000).toLocaleString('en-us', {
                              minimumFractionDigits: 2,
                            })}kg `
                          : `${item.weight.toLocaleString('en-us', {
                              minimumFractionDigits: 0,
                            })}g `
                        : ''}
                    </p>
                    <p>{item.count ? item.count.toLocaleString('en-us') + `x` : ''}</p>
                  </div>
                </div>
              </div>
            )}
          </div>
        ))}
      </div>
    </SlideUp>
  );
};

export default InventoryHotbar;
