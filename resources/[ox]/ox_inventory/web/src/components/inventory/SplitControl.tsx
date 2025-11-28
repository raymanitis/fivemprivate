import React, { useState, useRef, useCallback } from "react";
import { AnimatePresence, motion } from "framer-motion";
import { useAppDispatch, useAppSelector } from "../../store";
import { moveSlots, selectLeftInventory } from "../../store/inventory";
import { fetchNui } from "../../utils/fetchNui";
import { InventoryType } from "../../typings";

interface SplitControlProps {
  item: any;
  amount: number;
  infoVisible: boolean;
  setInfoVisible: (visible: boolean) => void;
  setSplitItem?: (item: { item: any; amount: number } | null) => void;
}

const SplitControl: React.FC<SplitControlProps> = ({ item, amount, infoVisible, setInfoVisible, setSplitItem }) => {
  // Use item.count if available, otherwise use amount
  const maxSplit = item?.count ? item.count - 1 : amount - 1;
  const minSplit = 1;
  
  // Start with minimum split amount (1)
  const [splitAmount, setSplitAmount] = useState(minSplit);
  const [isDragging, setIsDragging] = useState(false);
  const sliderRef = useRef<HTMLDivElement>(null);
  const dispatch = useAppDispatch();

  const updateSplitAmount = useCallback((clientX: number) => {
    if (!sliderRef.current) return;
    const rect = sliderRef.current.getBoundingClientRect();
    const x = clientX - rect.left;
    const percentage = Math.max(0, Math.min(100, (x / rect.width) * 100));
    // Calculate split amount: 0% = minSplit, 100% = maxSplit
    // Map percentage to range [minSplit, maxSplit]
    const range = maxSplit - minSplit;
    // Use Math.round for better precision
    const newAmount = range > 0 
      ? Math.max(minSplit, Math.min(maxSplit, Math.round(minSplit + (percentage / 100) * range)))
      : minSplit;
    setSplitAmount(newAmount);
  }, [maxSplit, minSplit]);

  const handleSliderMouseDown = useCallback((e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    setIsDragging(true);
    updateSplitAmount(e.clientX);
  }, [updateSplitAmount]);

  React.useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      if (!isDragging) return;
      e.preventDefault();
      updateSplitAmount(e.clientX);
    };

    const handleMouseUp = () => {
      setIsDragging(false);
    };

    if (isDragging) {
      document.addEventListener('mousemove', handleMouseMove, { passive: false });
      document.addEventListener('mouseup', handleMouseUp);
      document.body.style.userSelect = 'none'; // Prevent text selection while dragging
      return () => {
        document.removeEventListener('mousemove', handleMouseMove);
        document.removeEventListener('mouseup', handleMouseUp);
        document.body.style.userSelect = '';
      };
    }
  }, [isDragging, updateSplitAmount]);

  const leftInventory = useAppSelector(selectLeftInventory);

  const handleSplit = useCallback(() => {
    // Validate split amount
    const validAmount = Math.max(minSplit, Math.min(maxSplit, Math.floor(splitAmount)));
    if (validAmount < minSplit || validAmount > maxSplit) {
      console.log('Invalid split amount:', validAmount, 'for total:', item?.count || amount);
      return;
    }
    
    const sourceSlot = item.slot;
    
    // Find an available slot
    let targetSlot = -1;
    for (let i = 1; i <= leftInventory.slots; i++) {
      const slotItem = leftInventory.items[i - 1];
      if (!slotItem || !slotItem.name) {
        targetSlot = i;
        break;
      }
    }
    
    if (targetSlot === -1) {
      console.log('No available slot found');
      return;
    }
    
    // Use swapItems with count parameter for splitting
    fetchNui('swapItems', {
      fromType: 'player',
      fromSlot: sourceSlot,
      toType: 'player',
      toSlot: targetSlot,
      count: validAmount,
    }).then((success) => {
      if (success && setSplitItem) {
        setSplitItem(null);
      }
    });
  }, [splitAmount, minSplit, maxSplit, item, setSplitItem, leftInventory, amount]);

  const handleCancel = useCallback(() => {
    if (setSplitItem) {
      setSplitItem(null);
    }
  }, [setSplitItem]);

  return (
    <AnimatePresence>
      <motion.div
        initial={{ y: 0, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        exit={{ y: 0, opacity: 0 }}
        transition={{ duration: 0.4, ease: 'easeOut' }}>
        <div 
        className="inventory-grid-wrapper"
        style={{
          display: "flex",
          alignItems: "center",
          padding: "20px",
          position: "relative",
          width: "20vh",
        }}
        >
          <h2 style={{ marginBottom: "15px", textAlign: 'center', fontSize: "1.5vh" }}>Split Item</h2>
            <input
              type="number"
              min={minSplit}
              max={maxSplit}
              value={splitAmount}
              onChange={(e) => {
                const inputValue = e.target.value;
                // Allow empty input while typing
                if (inputValue === '') {
                  setSplitAmount(0);
                  return;
                }
                const val = parseInt(inputValue, 10);
                if (!isNaN(val)) {
                  if (val < minSplit) {
                    setSplitAmount(minSplit);
                  } else if (val > maxSplit) {
                    setSplitAmount(maxSplit);
                  } else {
                    setSplitAmount(val);
                  }
                }
              }}
              onBlur={(e) => {
                const val = parseInt(e.target.value, 10);
                if (isNaN(val) || val < minSplit) {
                  setSplitAmount(minSplit);
                } else if (val > maxSplit) {
                  setSplitAmount(maxSplit);
                } else {
                  setSplitAmount(val);
                }
              }}
              style={{
                width: "75%",
                textAlign: "center",
                fontSize: "1.25vh",
                fontWeight: "600",
                fontFamily: 'Geist, sans-serif',
              }}
            />

          {/* Interactive slider */}
          <div
            ref={sliderRef}
            style={{
              width: "100%",
              height: "16px",
              background: "rgba(0, 0, 0, 0.8)",
              borderRadius: "8px",
              position: "relative",
              marginTop: "20px",
              marginBottom: "20px",
              cursor: isDragging ? 'grabbing' : 'grab',
              touchAction: 'none',
            }}
            onMouseDown={handleSliderMouseDown}
          >
            <div
              style={{
                height: "100%",
                width: maxSplit > minSplit ? `${((splitAmount - minSplit) / (maxSplit - minSplit)) * 100}%` : '0%',
                background: "#C2F4F9", // Cyan accent
                borderRadius: "8px",
                boxShadow: "0 0 1.2685vh 0 rgba(194, 244, 249, 0.46)",
                transition: isDragging ? 'none' : 'width 0.1s ease',
                pointerEvents: 'none',
              }}
            />
            {/* Draggable Thumb */}
            <div
              style={{
                position: "absolute",
                left: maxSplit > minSplit ? `${((splitAmount - minSplit) / (maxSplit - minSplit)) * 100}%` : '0%',
                top: "50%",
                transform: "translate(-50%, -50%)",
                width: "24px",
                height: "24px",
                background: "#9dd4e0", // Darker cyan
                borderRadius: "50%",
                border: "3px solid #C2F4F9",
                boxShadow: "0 0 10px rgba(194, 244, 249, 0.8)",
                cursor: isDragging ? 'grabbing' : 'grab',
                pointerEvents: 'auto',
                zIndex: 10,
                touchAction: 'none',
              }}
              onMouseDown={(e) => {
                e.preventDefault();
                e.stopPropagation();
                setIsDragging(true);
                updateSplitAmount(e.clientX);
              }}
            />
          </div>

          {/* Fraction buttons */}
          {/* <div style={{ gap: '10px', display: "flex", justifyContent: "space-between", marginBottom: "20px" }}>
            {[1 / 2, 1 / 3, 1 / 4].map((fraction) => (
              <button
              className="split-button"
                key={fraction}
                style={{
                  flex: 1,
                  margin: "0 5px",
                  padding: "8px 12px",
                  cursor: "pointer",
                }}
                onClick={() => setSplitAmount(Math.floor(amount * fraction))}
              >
                1/{1 / fraction}
              </button>
            ))}
          </div> */}

          {/* Action buttons */}
          <div style={{ width: '100%', gap: '10px', display: "flex", justifyContent: "space-between" }}>
            <button 
              className="split-button cancel"
              onClick={handleCancel}
              style={{ flex: 1 }}
            >
              Cancel
            </button>
            <button 
              className="split-button"
              onClick={handleSplit}
              style={{ flex: 1 }}
            >
              Split
            </button>
          </div>
        </div>

      </motion.div>
    </AnimatePresence>
  );
};

export default SplitControl;
