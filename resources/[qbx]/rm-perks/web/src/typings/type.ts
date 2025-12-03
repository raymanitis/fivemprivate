export type SpecializationCategory = 'CRIME' | 'CIVILIAN';

export type SpecializationStatus = 'LOCKED' | 'UNLOCKED' | 'COMING_SOON' | 'CHOSEN';

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
  currentSpecialization?: string;
  canChange: boolean;
  timeRemaining: number;
  selectedCategory: SpecializationCategory;
  specializations: Specialization[];
}

