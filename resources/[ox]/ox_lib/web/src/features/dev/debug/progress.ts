import { debugData } from '../../../utils/debugData';
import { ProgressbarProps } from '../../../typings';

export const debugProgressbar = () => {
  debugData<ProgressbarProps>([
    {
      action: 'progress',
      data: {
        label: 'Drinking Water',
        duration: 5000,
      },
    },
  ]);
};

export const debugCircleProgressbar = () => {
  debugData([
    {
      action: 'circleProgress',
      data: {
        label: 'Using Lockpick',
        duration: 5000
      },
    },
  ]);
};
