import { debugData } from '../../../utils/debugData';
import type { InputProps } from '../../../typings';

export const debugInput = () => {
  debugData<InputProps>([
    {
      action: 'openDialog',
      data: {
        heading: 'Amount',
        rows: [
          {
            type: 'number',
            label: 'Amount',
            default: 1,
            min: 1,
          },
        ],
      },
    },
  ]);
};
