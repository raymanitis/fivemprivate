import { Box, createStyles } from '@mantine/core';
import { useEffect, useState } from 'react';
import { IconProp } from '@fortawesome/fontawesome-svg-core';
import { useNuiEvent } from '../../../hooks/useNuiEvent';
import { fetchNui } from '../../../utils/fetchNui';
import { isIconUrl } from '../../../utils/isIconUrl';
import ScaleFade from '../../../transitions/ScaleFade';
import type { RadialMenuItem } from '../../../typings';
import { useLocales } from '../../../providers/LocaleProvider';
import LibIcon from '../../../components/LibIcon';

const useStyles = createStyles((theme) => ({
  wrapper: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
  },
  squareButton: {
    fill: "rgba(18, 26, 28, 0.89)",
    stroke: "rgba(194, 244, 249, 0.40)",
    strokeWidth: 1,
    transition: 'all 0.2s ease',
    cursor: 'pointer',
    rx: 4,
    '&:hover': {
      fill: "rgba(56, 79, 82, 0.85)",
      stroke: "rgba(194, 244, 249, 0.67)",
    },
  },
  centerSquare: {
    fill: "rgba(56, 79, 82, 0.31)",
    stroke: "rgba(194, 244, 249, 0.40)",
    strokeWidth: 1,
    transition: 'all 0.2s ease',
    cursor: 'pointer',
    rx: 4,
    '&:hover': {
      fill: "rgba(56, 79, 82, 0.60)",
      stroke: "rgba(194, 244, 249, 0.67)",
    },
  },
  iconText: {
    fill: '#ffffff',
    pointerEvents: 'none',
    textAnchor: 'middle',
    fontFamily: "Inter",
    fontSize: 10,
    fontWeight: 600,
  },
  centerIconContainer: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
    pointerEvents: 'none',
  },
  centerIcon: {
    color: '#E3FBFF',
  },
  centerText: {
    position: 'absolute',
    top: '50%',
    left: '50%',
    transform: 'translate(-50%, -50%)',
    pointerEvents: 'none',
    color: '#ffffff',
    fontFamily: "Inter",
    fontSize: '16px',
    fontWeight: 600,
    textAlign: 'center',
    whiteSpace: 'nowrap',
    transition: 'opacity 0.2s ease',
    padding: '8px 16px',
    borderRadius: '4px',
    background: 'rgba(18, 26, 28, 0.89)',
    border: '1px solid rgba(194, 244, 249, 0.40)',
    minWidth: 'fit-content',
  },
}));

const PAGE_ITEMS = 8;
const BUTTON_SIZE = 60;
const CENTER_SIZE = 80;
const RADIUS = 120; // Distance from center to button centers

const RadialMenu: React.FC = () => {
  const { classes } = useStyles();
  const { locale } = useLocales();
  const newDimension = 350 * 1.1025;
  const [visible, setVisible] = useState(false);
  const [menuItems, setMenuItems] = useState<RadialMenuItem[]>([]);
  const [hoveredLabel, setHoveredLabel] = useState<string | null>(null);
  const [menu, setMenu] = useState<{ items: RadialMenuItem[]; sub?: boolean; page: number }>({
    items: [],
    sub: false,
    page: 1,
  });

  const changePage = async (increment?: boolean) => {
    setVisible(false);
    const didTransition: boolean = await fetchNui('radialTransition');
    if (!didTransition) return;
    setVisible(true);
    setMenu({ ...menu, page: increment ? menu.page + 1 : menu.page - 1 });
  };

  useEffect(() => {
    if (menu.items.length <= PAGE_ITEMS) return setMenuItems(menu.items);
    const items = menu.items.slice(
      PAGE_ITEMS * (menu.page - 1),
      PAGE_ITEMS * menu.page
    );
    if (PAGE_ITEMS * menu.page < menu.items.length) {
      items[items.length - 1] = { icon: 'ellipsis-h', label: locale.ui.more || "More", isMore: true };
    }
    setMenuItems(items);
  }, [menu.items, menu.page]);

  useNuiEvent('openRadialMenu', async (data: { items: RadialMenuItem[]; sub?: boolean; option?: string } | false) => {
    if (!data) return setVisible(false);
    let initialPage = 1;
    if (data.option) {
      data.items.findIndex(
        (item, index) => item.menu == data.option && (initialPage = Math.floor(index / PAGE_ITEMS) + 1)
      );
    }
    setMenu({ ...data, page: initialPage });
    setVisible(true);
  });

  useNuiEvent('refreshItems', (data: RadialMenuItem[]) => {
    setMenu({ ...menu, items: data });
  });

  function truncateText(text: string, maxLength: number): string {
    if (typeof text !== 'string') return '';
    if (text.length <= maxLength) return text;
    return text.slice(0, Math.max(0, maxLength - 3)) + '...';
  }

  // Calculate circular positions for 8 buttons
  const centerX = 175;
  const centerY = 175;
  const positions = Array.from({ length: PAGE_ITEMS }, (_, i) => {
    const angle = (i * 2 * Math.PI) / PAGE_ITEMS - Math.PI / 2; // Start from top
    return {
      x: centerX + RADIUS * Math.cos(angle),
      y: centerY + RADIUS * Math.sin(angle),
    };
  });

  return (
    <Box
      className={classes.wrapper}
      onContextMenu={async () => {
        if (menu.page > 1) await changePage();
        else if (menu.sub) fetchNui('radialBack');
      }}
    >
      <ScaleFade visible={visible}>
        <svg
          style={{ overflow: 'visible' }}
          width={`${newDimension}px`}
          height={`${newDimension}px`}
          viewBox="0 0 350 350"
        >
          {/* Square buttons in circular layout */}
          {menuItems.slice(0, PAGE_ITEMS).map((item, index) => {
            const { x, y } = positions[index];
            const buttonX = x - BUTTON_SIZE / 2;
            const buttonY = y - BUTTON_SIZE / 2;
            return (
              <g
                key={index}
                onClick={async () => {
                  const clickIndex = menu.page === 1 ? index : PAGE_ITEMS * (menu.page - 1) + index;
                  if (!item.isMore) fetchNui('radialClick', clickIndex);
                  else await changePage(true);
                }}
                onMouseEnter={() => setHoveredLabel(item.label)}
                onMouseLeave={() => setHoveredLabel(null)}
              >
                <rect
                  x={buttonX}
                  y={buttonY}
                  width={BUTTON_SIZE}
                  height={BUTTON_SIZE}
                  className={classes.squareButton}
                />
                <g transform={`translate(${x}, ${y})`} pointerEvents="none">
                  {typeof item.icon === 'string' && isIconUrl(item.icon) ? (
                    <image href={item.icon} width={32} height={32} x={-16} y={-16} />
                  ) : (
                    <foreignObject x={-16} y={-16} width={32} height={32}>
                      <div style={{ 
                        display: 'flex', 
                        justifyContent: 'center', 
                        alignItems: 'center',
                        width: '100%',
                        height: '100%',
                        color: '#E3FBFF'
                      }}>
                        <LibIcon
                          icon={item.icon as IconProp}
                          fixedWidth
                          style={{ fontSize: '24px' }}
                        />
                      </div>
                    </foreignObject>
                  )}
                </g>
              </g>
            );
          })}

        </svg>

        {hoveredLabel && (
          <div className={classes.centerText}>
            {hoveredLabel}
          </div>
        )}
      </ScaleFade>
    </Box>
  );
};

export default RadialMenu;
