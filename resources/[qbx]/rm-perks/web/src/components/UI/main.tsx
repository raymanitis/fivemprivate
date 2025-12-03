import { 
  Text, 
  Transition, 
  Flex, 
  Stack, 
  Title, 
  Group, 
  useMantineTheme,
  Button,
  Box,
  ActionIcon,
  Badge
} from '@mantine/core';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import useAppVisibilityStore from '../../stores/appVisibilityStore';
import { useState, useEffect } from 'react';
import { ChevronLeft, ChevronRight, Eye } from 'lucide-react';
import { Specialization, SpecializationCategory, SpecializationData } from '../../typings/type';
import { fetchNui } from '../../utils/fetchNui';
import { getNuiImagePath } from '../../utils/misc';
import './SpecializationUI.css';

const mockSpecializations: Specialization[] = [
  // CRIME
  {
    id: 'hustler',
    title: 'Hustler',
    description: 'You know how to make a lot of money on the side from stolen goods.',
    image: 'web/images/hustler.png',
    status: 'LOCKED',
    category: 'CRIME',
    color: '#C2F4F9'
  },
  {
    id: 'hacker',
    title: 'Hacker',
    description: 'Master of burgling and bypassing security.',
    image: 'web/images/hacker.png',
    status: 'LOCKED',
    category: 'CRIME',
    color: '#8ed8e1'
  },
  {
    id: 'drug-lord',
    title: 'Drug Lord',
    description: 'Control the streets with your network and distribution.',
    image: 'web/images/drug_lord.png',
    status: 'LOCKED',
    category: 'CRIME',
    color: '#5abcc9'
  },
  // CIVILIAN
  {
    id: 'business-owner',
    title: 'Business Owner',
    description: 'Build and manage your own legitimate business empire.',
    image: 'https://i.imgur.com/placeholder4.jpg',
    status: 'LOCKED',
    category: 'CIVILIAN',
    color: '#C2F4F9'
  },
  {
    id: 'mechanic',
    title: 'Mechanic',
    description: 'Expert in vehicle repairs and custom modifications.',
    image: 'https://i.imgur.com/placeholder5.jpg',
    status: 'LOCKED',
    category: 'CIVILIAN',
    color: '#a8e6ed'
  },
  {
    id: 'paramedic',
    title: 'Paramedic',
    description: 'Save lives and provide medical assistance to those in need.',
    image: 'https://i.imgur.com/placeholder6.jpg',
    status: 'LOCKED',
    category: 'CIVILIAN',
    color: '#74cad5'
  }
];

export function UI() {
  const theme = useMantineTheme();
  const { showApp, setVisibility } = useAppVisibilityStore();
  const [selectedCategory, setSelectedCategory] = useState<SpecializationCategory>('CRIME');
  // Initialize all specializations as unlocked by default
  const [specializations, setSpecializations] = useState<Specialization[]>(
    mockSpecializations.map(spec => ({ ...spec, status: 'UNLOCKED' as const }))
  );
  const [currentSpecialization, setCurrentSpecialization] = useState<string | null>(null);
  const [canChange, setCanChange] = useState(true);
  const [timeRemaining, setTimeRemaining] = useState(0);

  useNuiEvent<boolean>('UPDATE_VISIBILITY', (data) => {
    setVisibility(data);
    if (data) {
      // Request specialization data - server will send it via SET_SPECIALIZATION_DATA
      fetchNui('getSpecializations');
    }
  });

  useNuiEvent<{currentSpecialization?: string, canChange: boolean, timeRemaining: number}>('SET_SPECIALIZATION_DATA', (specData) => {
    if (specData) {
      setCurrentSpecialization(specData.currentSpecialization || null);
      setCanChange(specData.canChange);
      setTimeRemaining(specData.timeRemaining || 0);
      
      // Update specialization statuses
      const updatedSpecs = mockSpecializations.map(spec => {
        // If player has a specialization
        if (specData.currentSpecialization) {
          if (spec.id === specData.currentSpecialization) {
            return { ...spec, status: 'CHOSEN' as const };
          } else {
            // Lock others in the same category
            const currentSpec = mockSpecializations.find(s => s.id === specData.currentSpecialization);
            if (currentSpec && spec.category === currentSpec.category) {
              return { ...spec, status: 'LOCKED' as const };
            }
          }
        }
        // Default: all unlocked (when no specialization selected)
        return { ...spec, status: 'UNLOCKED' as const };
      });
      setSpecializations(updatedSpecs);
    } else {
      // If no data returned, default to all unlocked
      const defaultSpecs = mockSpecializations.map(spec => ({ ...spec, status: 'UNLOCKED' as const }));
      setSpecializations(defaultSpecs);
      setCurrentSpecialization(null);
      setCanChange(true);
      setTimeRemaining(0);
    }
  });

  useNuiEvent<{success: boolean, error?: string}>('SELECTION_RESULT', (result) => {
    if (result?.success) {
      // Request updated data
      fetchNui('getSpecializations');
    } else if (result?.error) {
      console.error('Error selecting specialization:', result.error);
    }
  });

  // Timer countdown
  useEffect(() => {
    if (!canChange && timeRemaining > 0) {
      const interval = setInterval(() => {
        setTimeRemaining(prev => {
          if (prev <= 1) {
            setCanChange(true);
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
      return () => clearInterval(interval);
    }
  }, [canChange, timeRemaining]);

  const formatTime = (seconds: number): string => {
    const days = Math.floor(seconds / (24 * 60 * 60));
    const hours = Math.floor((seconds % (24 * 60 * 60)) / (60 * 60));
    const minutes = Math.floor((seconds % (60 * 60)) / 60);
    const secs = seconds % 60;
    
    if (days > 0) {
      return `${days}d ${hours}h ${minutes}m`;
    } else if (hours > 0) {
      return `${hours}h ${minutes}m ${secs}s`;
    } else if (minutes > 0) {
      return `${minutes}m ${secs}s`;
    } else {
      return `${secs}s`;
    }
  };

  const filteredSpecializations = specializations.filter(
    spec => spec.category === selectedCategory
  );

  const scrollLeft = () => {
    const container = document.getElementById('specialization-scroll');
    if (container) {
      container.scrollBy({ left: -400, behavior: 'smooth' });
    }
  };

  const scrollRight = () => {
    const container = document.getElementById('specialization-scroll');
    if (container) {
      container.scrollBy({ left: 400, behavior: 'smooth' });
    }
  };

  const handleSelect = (spec: Specialization) => {
    if (spec.status === 'LOCKED' || spec.status === 'COMING_SOON' || spec.status === 'CHOSEN') return;
    
    // Send selection request - server will respond via SELECTION_RESULT event
    fetchNui('selectSpecialization', { specializationId: spec.id });
  };

  const handleClose = () => {
    setVisibility(false);
    fetchNui('hideApp');
  };
  
  return (
    <Transition mounted={showApp} transition="fade" duration={400} timingFunction="ease">
      {(transStyles) => (
        <Flex
          pos="fixed"
          w="100vw"
          h="100vh"
          style={{
            ...transStyles,
            pointerEvents: showApp ? 'auto' : 'none',
            justifyContent: 'center',
            alignItems: 'center',
            zIndex: 1000,
          }}
        >
          {/* Blurred Background Overlay */}
          <Box
            component="div"
            style={{
              position: 'fixed',
              top: 0,
              left: 0,
              width: '100vw',
              height: '100vh',
              backgroundColor: 'rgba(0, 0, 0, 0.1)',
              backdropFilter: 'blur(20px)',
              WebkitBackdropFilter: 'blur(20px)',
              zIndex: 0,
              pointerEvents: 'none',
              willChange: 'backdrop-filter',
            }}
          />
          <Box
            className="specialization-container"
            style={{
              width: '90%',
              maxWidth: '1400px',
              maxHeight: '90vh',
              position: 'relative',
              display: 'flex',
              flexDirection: 'column',
              overflow: 'visible',
              zIndex: 1,
              pointerEvents: 'auto',
            }}
          >
            <Stack gap="xl" style={{ display: 'flex', flexDirection: 'column', height: '100%', overflow: 'visible', position: 'relative' }}>
              {/* Header */}
              <Stack gap={8} align="center" style={{ flexShrink: 0, position: 'relative', zIndex: 100 }}>
                <Title order={1} c="#C2F4F9" size="2.5rem" fw={600} style={{ letterSpacing: '1px', margin: 0 }}>
                  Choose specialization
                </Title>
                <Text c="rgba(255, 255, 255, 0.7)" size="sm" ta="center" style={{ maxWidth: '600px', margin: 0 }}>
                  Be careful choosing your specialization. You can change it only once a week.
                </Text>
              </Stack>

              {/* Category Buttons and Timer - Same Row */}
              <Box style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', width: '100%', marginTop: '0.5rem', marginBottom: '1rem', flexShrink: 0, position: 'relative', zIndex: 100 }}>
                {/* Category Buttons - Left */}
                <Group gap="md" style={{ flexShrink: 0 }}>
                  <Button
                    variant="subtle"
                    onClick={() => setSelectedCategory('CRIME')}
                    className="category-tab"
                    data-active={selectedCategory === 'CRIME'}
                  >
                    CRIME
                  </Button>
                  <Button
                    variant="subtle"
                    onClick={() => setSelectedCategory('CIVILIAN')}
                    className="category-tab"
                    data-active={selectedCategory === 'CIVILIAN'}
                  >
                    CIVILIAN
                  </Button>
                </Group>

                {/* Timer - Right */}
                {!canChange && timeRemaining > 0 && (
                  <Box
                    style={{
                      backgroundColor: '#384f524f',
                      border: '0.0625rem solid #c2f4f967',
                      borderRadius: '0.15rem',
                      padding: '0.5rem 1rem',
                      color: '#C2F4F9',
                      fontSize: '0.875rem',
                      fontWeight: 500,
                      letterSpacing: '0.5px',
                      flexShrink: 0,
                    }}
                  >
                    Can change in: {formatTime(timeRemaining)}
                  </Box>
                )}
              </Box>

              {/* Specialization Cards */}
              <Box style={{ flex: '1 1 auto', position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '80px 60px', minHeight: 0, maxHeight: 'calc(90vh - 400px)', overflow: 'visible', zIndex: 10 }}>
                {filteredSpecializations.length > 3 && (
                  <ActionIcon
                    variant="subtle"
                    size="xl"
                    radius="md"
                    onClick={scrollLeft}
                    className="nav-arrow"
                    style={{ position: 'absolute', left: 0, zIndex: 10 }}
                  >
                    <ChevronLeft size={20} />
                  </ActionIcon>
                )}

                <Box
                  id="specialization-scroll"
                  style={{
                    width: '100%',
                    maxWidth: '1008px',
                    height: '100%',
                    display: 'flex',
                    justifyContent: 'center',
                    overflowX: filteredSpecializations.length > 3 ? 'auto' : 'visible',
                    overflowY: 'visible',
                    scrollbarWidth: 'none',
                    msOverflowStyle: 'none',
                  }}
                  className="specialization-scroll"
                >
                  <Group gap={24} align="stretch" wrap="nowrap" style={{ height: '100%', justifyContent: 'center', overflow: 'visible' }}>
                    {filteredSpecializations.map((spec) => (
                      <SpecializationCard
                        key={spec.id}
                        specialization={spec}
                        onSelect={() => handleSelect(spec)}
                      />
                    ))}
                  </Group>
                </Box>

                {filteredSpecializations.length > 3 && (
                  <ActionIcon
                    variant="subtle"
                    size="xl"
                    radius="md"
                    onClick={scrollRight}
                    className="nav-arrow"
                    style={{ position: 'absolute', right: 0, zIndex: 10 }}
                  >
                    <ChevronRight size={20} />
                  </ActionIcon>
                )}
              </Box>

              {/* Close Button */}
              <Group justify="center" style={{ paddingTop: '1.5rem', paddingBottom: '1rem', flexShrink: 0, marginTop: 'auto' }}>
                <Button
                  variant="subtle"
                  size="md"
                  onClick={handleClose}
                  className="go-back-button"
                  style={{ marginBottom: '1rem' }}
                >
                  CLOSE
                </Button>
              </Group>
            </Stack>
          </Box>
        </Flex>
      )}
    </Transition>
  );
}

interface SpecializationCardProps {
  specialization: Specialization;
  onSelect: () => void;
}

function SpecializationCard({ specialization, onSelect }: SpecializationCardProps) {
  const isComingSoon = specialization.status === 'COMING_SOON';
  const isLocked = specialization.status === 'LOCKED';

  return (
    <Box
      className="specialization-card"
      style={{
        width: '320px',
        flexShrink: 0,
        height: '480px',
        backgroundColor: '#121a1cde',
        border: `1.5px solid rgba(194, 244, 249, 0.4)`,
        borderRadius: '12px',
        overflow: 'hidden',
        position: 'relative',
        filter: isComingSoon ? 'grayscale(100%)' : 'none',
        opacity: isComingSoon ? 0.6 : 1,
        display: 'flex',
        flexDirection: 'column',
      }}
    >
      {/* Status Badge */}
      {specialization.status !== 'UNLOCKED' && (
        <Badge
          pos="absolute"
          top={12}
          right={12}
          variant="filled"
          size="sm"
          style={{
            backgroundColor: specialization.status === 'CHOSEN' ? 'rgba(76, 175, 80, 0.95)' : 'rgba(18, 26, 28, 0.95)',
            color: '#C2F4F9',
            zIndex: 2,
            padding: '6px 12px',
            fontSize: '11px',
            fontWeight: 600,
            textTransform: 'uppercase',
            letterSpacing: '1px',
            border: specialization.status === 'CHOSEN' ? '1.5px solid rgba(76, 175, 80, 0.8)' : '1.5px solid rgba(194, 244, 249, 0.5)',
            borderRadius: '4px',
            boxShadow: '0 2px 8px rgba(0, 0, 0, 0.4)',
          }}
        >
          {specialization.status === 'CHOSEN' ? 'CHOSEN' : isComingSoon ? 'COMING SOON' : 'LOCKED'}
        </Badge>
      )}

      {/* Image */}
      <Box
          style={{
            width: '100%',
            height: '60%',
            position: 'relative',
            overflow: 'hidden',
            backgroundColor: '#121a1c',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
      >
        <Box
          component="img"
          src={getNuiImagePath(specialization.image)}
          alt={specialization.title}
          style={{
            width: '100%',
            height: '100%',
            objectFit: 'cover',
            objectPosition: 'center',
            display: 'block',
            filter: isComingSoon ? 'grayscale(100%)' : 'none',
          }}
          onError={(e) => {
            const target = e.target as HTMLImageElement;
            target.style.display = 'none';
          }}
        />
        {/* Eye Icon */}
        <Box
          style={{
            position: 'absolute',
            top: 12,
            right: 12,
            zIndex: 1,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
          }}
        >
          <Eye size={18} color="rgba(194, 244, 249, 0.8)" />
        </Box>
        <Box
          style={{
            position: 'absolute',
            bottom: 0,
            left: 0,
            right: 0,
            height: '50%',
            background: 'linear-gradient(to top, rgba(0,0,0,0.85), transparent)',
          }}
        />
      </Box>

      {/* Content */}
      <Stack gap={14} p={24} style={{ flex: 1, justifyContent: 'space-between', backgroundColor: '#121a1cde', minHeight: 0, overflow: 'hidden' }}>
        <Stack gap={10} style={{ flex: 1, minHeight: 0 }}>
          <Title
            order={2}
            c={specialization.color || '#C2F4F9'}
            size="1.875rem"
            fw={700}
            style={{ lineHeight: 1.2, margin: 0, letterSpacing: '0.5px' }}
          >
            {specialization.title}
          </Title>
          {isComingSoon && (
            <Text c="rgba(194, 244, 249, 0.7)" size="sm" fw={500} style={{ margin: 0, letterSpacing: '0.5px' }}>
              Coming soon
            </Text>
          )}
          <Text
            c="rgba(255, 255, 255, 0.75)"
            size="sm"
            fw={400}
            style={{
              lineHeight: 1.6,
              margin: 0,
            }}
          >
            {specialization.description}
          </Text>
        </Stack>

        {!isComingSoon && (
          <Button
            fullWidth
            size="md"
            onClick={onSelect}
            disabled={isLocked || specialization.status === 'CHOSEN'}
            className="select-button"
            style={{
              backgroundColor: '#121a1cde',
              color: (isLocked || specialization.status === 'CHOSEN') ? 'rgba(255, 255, 255, 0.6)' : 'rgba(255, 255, 255, 0.9)',
              border: '0.0625rem solid #c2f4f967',
              marginTop: 'auto',
              fontWeight: 500,
              letterSpacing: '0.5px',
              flexShrink: 0,
            }}
          >
            {specialization.status === 'CHOSEN' ? 'SELECTED' : 'SELECT'}
          </Button>
        )}
      </Stack>
    </Box>
  );
}