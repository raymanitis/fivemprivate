import InventoryGrid from './InventoryGrid';
import InventorySlot from './InventorySlot';
import { useAppSelector } from '../../store';
import { selectLeftInventory } from '../../store/inventory';
import { getTotalWeight } from '../../helpers';
import { useMemo } from 'react';
import { Locale } from '../../store/locale';
import { useConfig } from '../..//hooks/useConfig'

const LeftInventory: React.FC = () => {
  const { config, loading } = useConfig()
  const theme = config.themes?.[config.theme || 'yellow'];
  const leftInventory = useAppSelector(selectLeftInventory);
  
  const isPlayerInventory = leftInventory.type === 'player';
  
  const firstFiveSlots = isPlayerInventory ? leftInventory.items.slice(0, 5) : [];
  const remainingSlots = isPlayerInventory ? leftInventory.items.slice(5) : leftInventory.items;
  
  const combinedWeight = useMemo(
    () => getTotalWeight(firstFiveSlots) + getTotalWeight(remainingSlots),
    [firstFiveSlots, remainingSlots]
  );

  return (
    <>
      <InventoryGrid inventory={leftInventory} slots={remainingSlots} combinedWeight={combinedWeight} />
      {isPlayerInventory && (
        <>
          <div className="fast-slot-wrapper">
            <div className="leftFrame" style={{
              background: `radial-gradient(87.5% 87.5% at 50% 50%, ${theme?.rgbColor1} 0%, ${theme?.rgbColor2} 100%)`
            }}>
              <svg className="frame" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 18 18" fill="none">
                <path d="M8.69522 0.07684C8.88549 -0.0256133 9.11451 -0.0256133 9.30478 0.07684L17.6619 4.57684C17.8701 4.68896 18 4.90636 18 5.14286C18 5.37936 17.8701 5.59675 17.6619 5.70888L9.30478 10.2089C9.11451 10.3113 8.88549 10.3113 8.69522 10.2089L0.338079 5.70888C0.129851 5.59675 0 5.37936 0 5.14286C0 4.90636 0.129851 4.68896 0.338079 4.57684L8.69522 0.07684Z" fill={theme?.mainColor}/>
                <path d="M1.51258 7.80155L8.08566 11.3409C8.65648 11.6483 9.34352 11.6483 9.91433 11.3409L16.4874 7.80155L17.6619 8.43398C17.8701 8.5461 18 8.7635 18 9C18 9.23649 17.8701 9.45389 17.6619 9.56601L9.30478 14.066C9.11451 14.1685 8.88549 14.1685 8.69522 14.066L0.338079 9.56601C0.129851 9.45389 0 9.23649 0 9C0 8.7635 0.129851 8.5461 0.338079 8.43398L1.51258 7.80155Z" fill={theme?.mainColor}/>
                <path d="M8.08566 15.198L1.51258 11.6587L0.338079 12.2911C0.129851 12.4032 0 12.6206 0 12.8571C0 13.0936 0.129851 13.311 0.338079 13.4232L8.69522 17.9232C8.88549 18.0256 9.11451 18.0256 9.30478 17.9232L17.6619 13.4232C17.8701 13.311 18 13.0936 18 12.8571C18 12.6206 17.8701 12.4032 17.6619 12.2911L16.4874 11.6587L9.91433 15.1981C9.34352 15.5054 8.65648 15.5054 8.08566 15.198Z" fill={theme?.mainColor}/>
              </svg>
            </div>

            <div className="header">{config.ui_fastSlots}</div>
            <div className="desc">{config.ui_fastSlotsDescription}</div>
          </div>

          <div className="first-five-slots-container">
            {firstFiveSlots.map((item, index) => (
              <InventorySlot
                key={`${leftInventory.type}-${leftInventory.id}-${item.slot}`}
                item={item}
                inventoryType={leftInventory.type}
                inventoryGroups={leftInventory.groups}
                inventoryId={leftInventory.id}
              />
            ))}
          </div>
        </>
      )}
    </>
  );
};

export default LeftInventory;
