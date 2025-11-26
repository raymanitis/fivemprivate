import { useEffect, useMemo, useState } from 'react';

export function useHudScale() {
  const [scale, setScale] = useState<number>(() => getScale());

  useEffect(() => {
    const handler = () => setScale(getScale());
    window.addEventListener('resize', handler);
    return () => window.removeEventListener('resize', handler);
  }, []);

  const px = useMemo(() => (n: number) => Math.round(n * scale), [scale]);

  return { scale, px };
}

function getScale() {
  if (typeof window === 'undefined') return 1;
  const w = window.innerWidth || 1920;
  const h = window.innerHeight || 1080;
  return Math.min(w / 1920, h / 1080);
}


