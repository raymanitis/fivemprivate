import { Text, Transition, Flex, Card, Stack, Title, Divider, Group, useMantineTheme } from '@mantine/core';
import { useNuiEvent } from '../../hooks/useNuiEvent';
import useAppVisibilityStore from '../../stores/appVisibilityStore';
import { BetweenHorizontalEnd, Type, Box, Rocket } from 'lucide-react';

export function UI() {
  const theme = useMantineTheme();
  const { showApp, setVisibility } = useAppVisibilityStore();

  useNuiEvent<boolean>('UPDATE_VISIBILITY', (data) => {
    setVisibility(data);
  });
  
  return (
    <Transition mounted={showApp} transition="fade" duration={400} timingFunction="ease">
      {(transStyles) => (
        <Flex
          pos="fixed"
          w="100vw"
          h="100vh"
          style={{
            pointerEvents: 'none',
            justifyContent: 'center',
            alignItems: 'center',
          }}
        >
          <Card
            p="xl"
            style={{
              ...transStyles,
              backgroundColor: theme.colors.dark[8],
              borderRadius: theme.radius.md,
              maxWidth: '500px',
              width: '100%',
            }}
          >
            <Stack align="center" gap="xs">
              <Group gap="xs">
                <Rocket size={28} color={theme.colors.blue[5]} />
                <Title order={4} c="white">
                  Welcome to Tom's Mantine Boilerplate
                </Title>
              </Group>
              
              <Divider w="100%" my="sm" color={theme.colors.dark[5]} />
              
              <Text c="dimmed" ta="center">
                A modern UI foundation built with:
              </Text>
              
              <Group justify="center" mt="sm" gap="xl">
                <Stack gap={4} align="center">
                  <BetweenHorizontalEnd size={32} color={theme.colors.blue[4]} />
                  <Text size="sm">React</Text>
                </Stack>
                
                <Stack gap={4} align="center">
                  <Type size={32} color={theme.colors.blue[7]} />
                  <Text size="sm">TypeScript</Text>
                </Stack>
                
                <Stack gap={4} align="center">
                  <Box size={32} color={theme.colors.indigo[5]} />
                  <Text size="sm">Mantine v7</Text>
                </Stack>
              </Group>
              
              <Text size="xs" c="dimmed" mt="xl">
                Ready to build something amazing?
              </Text>
            </Stack>
          </Card>
        </Flex>
      )}
    </Transition>
  );
}