import React, { useState, useEffect } from 'react';
import useNuiEvent from '../../hooks/useNuiEvent';

const CharacterPreview: React.FC = () => {
  const [previewUrl, setPreviewUrl] = useState<string | null>(null);
  const [imageError, setImageError] = useState(false);

  useNuiEvent<{ url: string }>('setCharacterPreview', (data) => {
    if (data?.url) {
      setPreviewUrl(data.url);
      setImageError(false);
    } else {
      setPreviewUrl(null);
      setImageError(false);
    }
  });

  useNuiEvent('closeInventory', () => {
    setPreviewUrl(null);
    setImageError(false);
  });

  // Force refresh the image if it fails to load
  useEffect(() => {
    if (previewUrl && imageError) {
      const timer = setTimeout(() => {
        setImageError(false);
      }, 1000);
      return () => clearTimeout(timer);
    }
  }, [previewUrl, imageError]);

  return (
    <div className="character-preview-wrapper">
      {previewUrl && !imageError && (
        <img
          key={previewUrl}
          src={`${previewUrl}?t=${Date.now()}`}
          alt="Character Preview"
          className="character-preview-image"
          onError={() => setImageError(true)}
          style={{
            width: '100%',
            height: '100%',
            objectFit: 'contain',
            pointerEvents: 'none',
          }}
        />
      )}
    </div>
  );
};

export default CharacterPreview;

