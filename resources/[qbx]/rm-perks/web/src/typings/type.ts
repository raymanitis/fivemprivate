export type SpecializationCategory = 'CRIME' | 'CIVILIAN';

export type SpecializationStatus = 'LOCKED' | 'UNLOCKED' | 'COMING_SOON';

export interface Specialization {
  id: string;
  title: string;
  description: string;
  image: string;
  status: SpecializationStatus;
  category: SpecializationCategory;
  color?: string;
}

export interface SpecializationData {
  dailyReputation: number;
  maxDailyReputation: number;
  selectedCategory: SpecializationCategory;
  specializations: Specialization[];
}

