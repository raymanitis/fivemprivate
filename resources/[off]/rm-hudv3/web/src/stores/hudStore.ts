import { create } from 'zustand';
import { useNuiEvent } from '../hooks/useNuiEvent';

export type VehicleHudData = {
  speedKmh: number;
  fuel: number;
  engineOn: boolean;
  seatbeltOn: boolean;
  lightsOn: boolean;
  gear?: number;
  rpm?: number;
  engineHealth?: number;
  inVehicle?: boolean;
};

export type StatusHudData = {
  health: number;
  armour: number;
  hunger?: number;
  thirst?: number;
  voice?: number;
  talking?: boolean;
};

export type CompassHudData = {
  heading: number;
  street: string;
  zone: string;
  showCompassOnFoot?: boolean;
};

export type HudState = {
  visible: boolean;
  unit: 'kph' | 'mph';
  vehicle: VehicleHudData;
  status: StatusHudData;
  compass: CompassHudData;
  uiConfig: {
    showCompassOnFoot?: boolean;
    topRight?: {
      idShow?: boolean;
      timeEnable?: boolean;
      ingameTime?: boolean;
      logoEnable?: boolean;
      logo?: string;
    }
  };
  topRight: { playerId?: string | number; timeStr?: string };
  setVisible: (v: boolean) => void;
  setUnit: (u: 'kph' | 'mph') => void;
  setVehicle: (v: Partial<VehicleHudData>) => void;
  setStatus: (v: Partial<StatusHudData>) => void;
  setCompass: (v: Partial<CompassHudData>) => void;
  setUiConfig: (v: Partial<HudState['uiConfig']>) => void;
  setTopRight: (v: Partial<{ playerId?: string | number; timeStr?: string }>) => void;
};

export const useHudStore = create<HudState>((set) => ({
  visible: true,
  unit: 'kph',
  vehicle: { speedKmh: 0, fuel: 100, engineOn: false, seatbeltOn: false, lightsOn: false, gear: 0, rpm: 0, inVehicle: false },
  status: { health: 100, armour: 0, hunger: 100, thirst: 100, voice: 100 },
  compass: { heading: 0, street: '', zone: '', showCompassOnFoot: false },
  uiConfig: { showCompassOnFoot: false, topRight: { idShow: true, timeEnable: true, ingameTime: false, logoEnable: true, logo: '' } },
  topRight: { playerId: undefined, timeStr: undefined },
  setVisible: (v) => set({ visible: v }),
  setUnit: (u) => set({ unit: u }),
  setVehicle: (v) => set((s) => ({ vehicle: { ...s.vehicle, ...v } })),
  setStatus: (v) => set((s) => ({ status: { ...s.status, ...v } })),
  setCompass: (v) => set((s) => ({ compass: { ...s.compass, ...v } })),
  setUiConfig: (v) => set((s) => ({ uiConfig: { ...s.uiConfig, ...v, topRight: { ...s.uiConfig.topRight, ...(v.topRight || {}) } } })),
  setTopRight: (v) => set((s) => ({ topRight: { ...s.topRight, ...v } })),
}));

export function useHudNuiHandlers() {
  const setVisible = useHudStore((s) => s.setVisible);
  const setVehicle = useHudStore((s) => s.setVehicle);
  const setStatus = useHudStore((s) => s.setStatus);
  const setCompass = useHudStore((s) => s.setCompass);
  const setUiConfig = useHudStore((s) => s.setUiConfig);
  const setTopRight = useHudStore((s) => s.setTopRight);
  const setUnit = useHudStore((s) => s.setUnit);

  useNuiEvent<boolean>('HUD_SET_VISIBLE', (v) => setVisible(v));
  useNuiEvent<Partial<VehicleHudData>>('HUD_VEHICLE', (data) => setVehicle(data));
  useNuiEvent<Partial<StatusHudData>>('HUD_STATUS', (data) => setStatus(data));
  useNuiEvent<Partial<CompassHudData>>('HUD_COMPASS', (data) => setCompass(data));
  useNuiEvent<Partial<HudState['uiConfig']>>('HUD_CONFIG', (data) => setUiConfig(data));
  useNuiEvent<Partial<{ playerId?: string | number; timeStr?: string }>>('HUD_TOPRIGHT', (data) => setTopRight(data));
  useNuiEvent<'kph' | 'mph'>('HUD_UNIT', (data) => setUnit(data));
}


