import { 
  Text, 
  Transition, 
  Flex, 
  Stack, 
  Title, 
  Group, 
  Box,
  Button
} from '@mantine/core';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import useAppVisibilityStore from '../../stores/appVisibilityStore';
import { useState } from 'react';
import { fetchNui } from '../../utils/fetchNui';
import './SkillTree.css';

interface SkillNode {
  id: string;
  name: string;
  description: string;
  requiredLevel: number;
  icon: string;
  locked: boolean;
  unlocked: boolean;
  active: boolean;
}

interface SkillTreeData {
  level: number;
  experience: number;
  experienceToNext: number;
  tree: 'criminal' | 'civilian';
  skills: SkillNode[];
}

export function UI() {
  const { showApp, setVisibility } = useAppVisibilityStore();
  const [selectedCategory, setSelectedCategory] = useState<'CRIME' | 'CIVILIAN'>('CRIME');
  const [skillData, setSkillData] = useState<SkillTreeData>({
    level: 5,
    experience: 1250,
    experienceToNext: 2000,
    tree: 'criminal',
    skills: [
      { id: 'c1', name: 'Backdoor Access', description: 'Unlocks basic hacking routes into low security doors and terminals.', requiredLevel: 1, icon: '🔓', locked: false, unlocked: true, active: false },
      { id: 'c2', name: 'Silent Bypass', description: 'Reduces alarm chance when attempting hacks by 15%.', requiredLevel: 2, icon: '📡', locked: false, unlocked: true, active: true },
      { id: 'c3', name: 'Camera Loop', description: 'Allows you to temporarily loop simple CCTV cameras.', requiredLevel: 5, icon: '📹', locked: false, unlocked: false, active: false },
      { id: 'c4', name: 'Deep Scan', description: 'Highlights vulnerable systems nearby when using hacking tools.', requiredLevel: 7, icon: '🔍', locked: true, unlocked: false, active: false },
      { id: 'c5', name: 'Encrypted Keychain', description: 'Stores more access codes and shortens cool-downs between hacks.', requiredLevel: 10, icon: '🔑', locked: true, unlocked: false, active: false },
      { id: 'c6', name: 'System Overload', description: 'Chance to temporarily disable security systems after a successful hack.', requiredLevel: 12, icon: '⚡', locked: true, unlocked: false, active: false },
    ]
  });
  const [tooltip, setTooltip] = useState<{ show: boolean; x: number; y: number; node: SkillNode | null }>({
    show: false,
    x: 0,
    y: 0,
    node: null
  });

  useNuiEvent<boolean>('UPDATE_VISIBILITY', (data) => {
    setVisibility(data);
  });

  useNuiEvent<SkillTreeData>('UPDATE_SKILL_TREE', (data) => {
    setSkillData(data);
    if (data.tree === 'criminal') {
      setSelectedCategory('CRIME');
    } else {
      setSelectedCategory('CIVILIAN');
    }
  });

  const handleNodeHover = (e: React.MouseEvent, node: SkillNode) => {
    setTooltip({
      show: true,
      x: e.clientX,
      y: e.clientY - 10,
      node
    });
  };

  const handleNodeLeave = () => {
    setTooltip({ show: false, x: 0, y: 0, node: null });
  };

  const handleNodeClick = async (node: SkillNode) => {
    if (node.locked) return;
    
    try {
      await fetchNui('claimSkill', { id: node.id, tree: skillData.tree });
    } catch (error) {
      console.error('Failed to claim skill:', error);
    }
  };

  const handleClose = async () => {
    await fetchNui('hideApp');
  };

  const handleCategoryChange = (category: 'CRIME' | 'CIVILIAN') => {
    setSelectedCategory(category);
    setSkillData(prev => ({
      ...prev,
      tree: category === 'CRIME' ? 'criminal' : 'civilian'
    }));
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
            style={{
              position: 'fixed',
              top: 0,
              left: 0,
              width: '100vw',
              height: '100vh',
              backgroundColor: 'rgba(0, 0, 0, 0.7)',
              backdropFilter: 'blur(10px) saturate(180%)',
              WebkitBackdropFilter: 'blur(20px) saturate(180%)',
              zIndex: 0,
              pointerEvents: 'none',
            }}
          />
          
          <Box
            className="skilltree-container"
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
                  Skill Tree
                </Title>
                <Text c="rgba(255, 255, 255, 0.7)" size="sm" ta="center" style={{ maxWidth: '600px', margin: 0 }}>
                  Grind abilities to level up and unlock powerful skills and perks.
                </Text>
              </Stack>

              {/* Category Buttons and Level Progress - Same Row */}
              <Box style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', width: '100%', marginTop: '0.5rem', marginBottom: '1rem', flexShrink: 0, position: 'relative', zIndex: 100 }}>
                {/* Category Buttons - Left */}
                <Group gap="md" style={{ flexShrink: 0 }}>
                  <Button
                    variant="subtle"
                    onClick={() => handleCategoryChange('CRIME')}
                    className="category-tab"
                    data-active={selectedCategory === 'CRIME'}
                  >
                    CRIME
                  </Button>
                  <Button
                    variant="subtle"
                    onClick={() => handleCategoryChange('CIVILIAN')}
                    className="category-tab"
                    data-active={selectedCategory === 'CIVILIAN'}
                  >
                    CIVILIAN
                  </Button>
                </Group>

                {/* Level Progress - Right */}
                <Box
                  style={{
                    backgroundColor: '#384f524f',
                    border: '0.0625rem solid #c2f4f967',
                    borderRadius: '0.15rem',
                    padding: '0.75rem 1.25rem',
                    color: '#C2F4F9',
                    fontSize: '0.875rem',
                    fontWeight: 500,
                    letterSpacing: '0.5px',
                    flexShrink: 0,
                    minWidth: '280px',
                  }}
                >
                  <Box style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '0.5rem' }}>
                    <Text style={{ fontSize: '0.875rem', fontWeight: 500 }}>
                      Level <span style={{ fontWeight: 600, fontSize: '1rem' }}>{skillData.level}</span>
                    </Text>
                    <Text style={{ fontSize: '0.75rem', color: 'rgba(194, 244, 249, 0.7)' }}>
                      {skillData.experience} / {skillData.experienceToNext} XP
                    </Text>
                  </Box>
                  <Box
                    style={{
                      width: '100%',
                      height: '6px',
                      backgroundColor: 'rgba(194, 244, 249, 0.1)',
                      borderRadius: '3px',
                      overflow: 'hidden',
                    }}
                  >
                    <Box
                      style={{
                        width: `${(skillData.experience / skillData.experienceToNext) * 100}%`,
                        height: '100%',
                        backgroundColor: '#C2F4F9',
                        borderRadius: '3px',
                        transition: 'width 0.3s ease',
                      }}
                    />
                  </Box>
                </Box>
              </Box>

              {/* Skill Tree Content */}
              <Box style={{ flex: '1 1 auto', position: 'relative', display: 'flex', alignItems: 'center', justifyContent: 'center', padding: '40px 60px', minHeight: 0, maxHeight: 'calc(90vh - 300px)', overflow: 'auto', zIndex: 10 }}>
                <div className="skilltree-content">
                  <div className="skilltree-row">
                    <div className="skilltree-row-label">
                      <span>Tier I – Basic</span>
                      <span>Required level: 5</span>
                    </div>
                    <div className="skilltree-line">
                      {skillData.skills.slice(0, 3).map((skill, idx) => (
                        <div key={skill.id} style={{ display: 'flex', alignItems: 'center' }}>
                          <div
                            className={`skill-node ${skill.locked ? 'locked' : ''} ${skill.active ? 'active' : ''} ${skill.unlocked ? 'unlocked' : ''}`}
                            onMouseEnter={(e) => handleNodeHover(e, skill)}
                            onMouseMove={(e) => handleNodeHover(e, skill)}
                            onMouseLeave={handleNodeLeave}
                            onClick={() => handleNodeClick(skill)}
                          >
                            <div className="skill-node-inner">{skill.icon}</div>
                          </div>
                          {idx < 2 && <div className="skill-connector"></div>}
                        </div>
                      ))}
                    </div>
                  </div>

                  <div className="skilltree-row">
                    <div className="skilltree-row-label">
                      <span>Tier II – Advanced</span>
                      <span>Required level: 15</span>
                    </div>
                    <div className="skilltree-line">
                      {skillData.skills.slice(3, 6).map((skill, idx) => (
                        <div key={skill.id} style={{ display: 'flex', alignItems: 'center' }}>
                          <div
                            className={`skill-node ${skill.locked ? 'locked' : ''} ${skill.active ? 'active' : ''} ${skill.unlocked ? 'unlocked' : ''}`}
                            onMouseEnter={(e) => handleNodeHover(e, skill)}
                            onMouseMove={(e) => handleNodeHover(e, skill)}
                            onMouseLeave={handleNodeLeave}
                            onClick={() => handleNodeClick(skill)}
                          >
                            <div className="skill-node-inner">{skill.icon}</div>
                          </div>
                          {idx < 2 && <div className="skill-connector"></div>}
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
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

          {tooltip.show && tooltip.node && (
            <div
              className="skill-tooltip"
              style={{
                left: `${tooltip.x}px`,
                top: `${tooltip.y - 10}px`,
                opacity: 1,
                transform: 'translate(-50%, -100%)'
              }}
            >
              <div className="skill-tooltip-title">
                {tooltip.node.name} {tooltip.node.locked ? '(Locked)' : ''}
              </div>
              <div className="skill-tooltip-desc">{tooltip.node.description}</div>
              <div className="skill-tooltip-meta">Required Level: {tooltip.node.requiredLevel}</div>
            </div>
          )}
        </Flex>
      )}
    </Transition>
  );
}
