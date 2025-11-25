import InventoryComponent from './components/inventory';
import useNuiEvent from './hooks/useNuiEvent';
import { Items } from './store/items';
import { Locale } from './store/locale';
import { setImagePath } from './store/imagepath';
import { setupInventory } from './store/inventory';
import { Inventory } from './typings';
import { useAppDispatch } from './store';
import { debugData } from './utils/debugData';
import DragPreview from './components/utils/DragPreview';
import { fetchNui } from './utils/fetchNui';
import { useDragDropManager } from 'react-dnd';
import KeyPress from './components/utils/KeyPress';

debugData([
  {
    action: 'setupInventory',
    data: {
      leftInventory: {
        id: 'test',
        weighttext: 'Weight',
        header: 'Inventory',
        description: 'Lorem ipsum dolor sit amet consectetur',
        type: 'player',
        slots: 50,
        label: 'Bob Smith',
        weight: 1600,
        maxWeight: 25000,
        items: [
          { slot: 6, name: 'burger', weight: 15500, count: 1, 
            metadata: {
              durability: 100
            }
          },
          { slot: 7, name: 'bandage', weight: 100, count: 1 , 
            metadata: {
              durability: 71
            }
          },
          { slot: 8, name: 'weapon_pistol', weight: 100, count: 1 , 
            metadata: {
              durability: 35
            }
          },
          { slot: 9, name: 'weapon_pistol', weight: 100, count: 1 , 
            metadata: {
              durability: 10
            }
          },
          // { slot: 10, name: 'water', weight: 100, count: 1 },
        ],
      },
      rightInventory: {
        id: 'drop',
        type: 'drop',
        description: 'Lorem ipsum dolor sit amet consectetur',
        slots: 5000,
        label: 'Backpack',
        weighttext: 'Weight',
        weight: 3000,
        maxWeight: 25000,
        items: [
          {
            slot: 1,
            name: 'burger',
            weight: 500,
            metadata: {
              description: 'Simple lockpick that breaks easily and can pick basic door locksSimple lockpick that breaks easily and can pick basic door locks',
            },
            count: 1
          },
        ],
      },
    },
  },
]);

const App: React.FC = () => {
  const dispatch = useAppDispatch();
  const manager = useDragDropManager();

  useNuiEvent<{
    locale: { [key: string]: string };
    items: typeof Items;
    leftInventory: Inventory;
    imagepath: string;
  }>('init', ({ locale, items, leftInventory, imagepath }) => {
    for (const name in locale) {
      Locale[name] = locale[name];
    } 
    for (const name in items) Items[name] = items[name];

    setImagePath(imagepath);
    dispatch(setupInventory({ leftInventory }));
  });

  fetchNui('uiLoaded', {});

  useNuiEvent('closeInventory', () => {
    manager.dispatch({ type: 'dnd-core/END_DRAG' });
  });

  return (
    <div className="app-wrapper">
      <InventoryComponent />
      <DragPreview />
      <KeyPress />
    </div>
  );
};

addEventListener("dragstart", function(event) {
  event.preventDefault()
})

export default App;
