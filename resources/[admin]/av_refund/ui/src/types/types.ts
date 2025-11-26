export interface Item {
  name: string;
  label: string;
  serial: string;
}

export interface AllItems {
  [key: string]: Item;
}

export interface StashItem {
  name: string;
  label: string;
  amount?: number;
  metadata?: { field: string; value: string; serial: string }[];
  serial: string;
}
