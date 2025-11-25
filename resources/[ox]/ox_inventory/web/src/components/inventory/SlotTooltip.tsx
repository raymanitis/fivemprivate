import { Inventory, SlotWithItem } from '../../typings';
import React, { Fragment, useMemo } from 'react';
import { Items } from '../../store/items';
import { Locale } from '../../store/locale';
import ReactMarkdown from 'react-markdown';
import { useAppSelector } from '../../store';
import ClockIcon from '../utils/icons/ClockIcon';
import { getItemUrl } from '../../helpers';
import Divider from '../utils/Divider';

const SlotTooltip: React.ForwardRefRenderFunction<
  HTMLDivElement,
  { item: SlotWithItem; inventoryType: Inventory['type']; style: React.CSSProperties }
> = ({ item, inventoryType, style }, ref) => {
  const additionalMetadata = useAppSelector((state) => state.inventory.additionalMetadata);
  const itemData = useMemo(() => Items[item.name], [item]);
  const ingredients = useMemo(() => {
    if (!item.ingredients) return null;
    return Object.entries(item.ingredients).sort((a, b) => a[1] - b[1]);
  }, [item]);
  const description = item.metadata?.description || itemData?.description;
  const ammoName = itemData?.ammoName && Items[itemData?.ammoName]?.label;



  return (
    <>
      {!itemData ? (
        <div className="tooltip-wrapper" ref={ref} style={style}>
            <svg className='poly2' xmlns="http://www.w3.org/2000/svg" width="20" height="12" viewBox="0 0 20 12" fill="none">
              <path d="M10.0028 1L19 11.2137H1L10.0028 1Z" fill="#2A2C2B" stroke-opacity="0.1" stroke-width="0.5"/>
            </svg>
          <div className="tooltip-header-wrapper">
            <p>{item.name}</p>
          </div>
        </div>
      ) : (
        <div style={{ ...style }} className="tooltip-wrapper" ref={ref}>
            <svg className='poly2' xmlns="http://www.w3.org/2000/svg" width="20" height="12" viewBox="0 0 20 12" fill="none">
              <path d="M10.0028 1L19 11.2137H1L10.0028 1Z" fill="#2A2C2B" stroke-opacity="0.1" stroke-width="0.5"/>
            </svg>
          <div className="tooltip-header-wrapper">
            <div className='iName'>{item.metadata?.label || itemData.label || item.name}</div>
            {inventoryType === 'crafting' ? (
              <div className="tooltip-crafting-duration">
                <ClockIcon />
                <p>{(item.duration !== undefined ? item.duration : 3000) / 1000}s</p>
              </div>
            ) : (
              <p>{item.metadata?.type}</p>
            )}
          </div>
          <Divider />
          {description && (
            <div className="tooltip-description">
              <ReactMarkdown className="tooltip-markdown">{description}</ReactMarkdown>
            </div>
          )}
          {inventoryType !== 'crafting' ? (
            <div className='tooltipinside'>
              {item.durability !== undefined && (
                <div className="sa">
                  <span>{Locale.ui_durability}:</span> <p>{Math.trunc(item.durability)}</p>
                </div>
              )}
              {item.metadata?.ammo !== undefined && (
                <div className="sa">
                  <span>{Locale.ui_ammo}:</span> <p>{item.metadata.ammo}</p>
                </div>
              )}
              {ammoName && (
                <div className="sa">
                  <span>{Locale.ammo_type}:</span> <p>{ammoName}</p>
                </div>
              )}
              {item.metadata?.serial && (
                <div className="sa">
                  <span>{Locale.ui_serial}:</span> <p>{item.metadata.serial}</p>
                </div>
              )}
              {item.metadata?.components && item.metadata?.components[0] && (
                
                <div className="sa">
                  <span>{Locale.ui_components}:</span> <p>{(item.metadata?.components).map((component: string, index: number, array: []) =>
                    index + 1 === array.length ? Items[component]?.label : Items[component]?.label + ', '
                  )}</p>
                </div>
              )}
              {item.metadata?.weapontint && (
                <div className="sa">
                  <span>{Locale.ui_tint}:</span> <p>{item.metadata.weapontint}</p>
                </div>
              )}
              {additionalMetadata.map((data: { metadata: string; value: string }, index: number) => (
                <Fragment key={`metadata-${index}`}>
                  {item.metadata && item.metadata[data.metadata] && (
                    <div className="sa">
                      <span>{data.value}:</span> <p>{item.metadata[data.metadata]}</p>
                    </div>
                  )}
                </Fragment>
              ))}
            </div>
          ) : (
            <div className="tooltip-ingredients">
              {ingredients &&
                ingredients.map((ingredient) => {
                  const [item, count] = [ingredient[0], ingredient[1]];
                  return (
                    <div className="tooltip-ingredient" key={`ingredient-${item}`}>
                      <img src={item ? getItemUrl(item) : 'none'} alt="item-image" />
                      <p>
                        {count >= 1
                          ? `${count}x ${Items[item]?.label || item}`
                          : count === 0
                          ? `${Items[item]?.label || item}`
                          : count < 1 && `${count * 100}% ${Items[item]?.label || item}`}
                      </p>
                    </div>
                  );
                })}
            </div>
          )}
        </div>
      )}
    </>
  );
};

export default React.forwardRef(SlotTooltip);
