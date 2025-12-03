import React, { useState } from "react"
import { Paper, Button, Text, Divider } from '@mantine/core'
import { isEnvBrowser } from "../utils/misc"

const DevMode: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false)

  // Only show in development mode and browser environment
  const isDevMode = import.meta.env.MODE === "development" && isEnvBrowser()
  
  if (!isDevMode) {
    return null
  }

  const dispatchNuiEvent = (action: string, data: any) => {
    window.dispatchEvent(
      new MessageEvent("message", {
        data: {
          action,
          data,
        },
      })
    )
  }

  const testDialogue = () => {
    dispatchNuiEvent("setVisibleDialogue", true)
    dispatchNuiEvent("dialogue", {
      label: "John Doe",
      speech: "Hello! This is a test dialogue. Choose an option below to interact with me.",
      options: [
        {
          id: 1,
          label: "Tell me more",
          icon: "info-circle",
          canInteract: true,
          close: false,
        },
        {
          id: 2,
          label: "Ask about quests",
          icon: "list-check",
          canInteract: true,
          close: false,
        },
        {
          id: 3,
          label: "Goodbye",
          icon: "hand-wave",
          canInteract: true,
          close: true,
        },
      ],
    })
  }

  const testMissionStatus = () => {
    dispatchNuiEvent("setVisibleMissionStatus", true)
    dispatchNuiEvent("missionStatus", {
      title: "Mission: Test Quest",
      text: "<p>This is a <strong>test mission status</strong> display.</p><p>You can use <em>HTML formatting</em> here.</p><ul><li>Objective 1: Complete</li><li>Objective 2: In progress</li><li>Objective 3: Not started</li></ul>",
    })
  }

  const testTimer = () => {
    dispatchNuiEvent("setVisibleTimer", true)
    dispatchNuiEvent("timer", {
      label: "Time remaining",
      time: 30,
      position: "bottom",
    })
  }

  const testTimerTop = () => {
    dispatchNuiEvent("setVisibleTimer", true)
    dispatchNuiEvent("timer", {
      label: "Cooldown",
      time: 15,
      position: "top",
    })
  }

  const testTextUI = () => {
    dispatchNuiEvent("setVisibleTextUI", true)
    dispatchNuiEvent("textUI", {
      key: "E",
      label: "Press to interact",
      position: "bottom",
    })
  }

  const testTextUITop = () => {
    dispatchNuiEvent("setVisibleTextUI", true)
    dispatchNuiEvent("textUI", {
      key: "F",
      label: "Press to open menu",
      position: "top",
    })
  }

  const testTextUIRight = () => {
    dispatchNuiEvent("setVisibleTextUI", true)
    dispatchNuiEvent("textUI", {
      key: "G",
      label: "Press to grab item",
      position: "right",
    })
  }

  const testTextUILeft = () => {
    dispatchNuiEvent("setVisibleTextUI", true)
    dispatchNuiEvent("textUI", {
      key: "H",
      label: "Press to examine",
      position: "left",
    })
  }

  const hideAll = () => {
    dispatchNuiEvent("setVisibleDialogue", false)
    dispatchNuiEvent("setVisibleMissionStatus", false)
    dispatchNuiEvent("setVisibleTimer", false)
    dispatchNuiEvent("setVisibleTextUI", false)
  }

  if (!isOpen) {
    return (
      <div
        style={{
          position: "fixed",
          top: 10,
          right: 10,
          zIndex: 9999,
        }}
      >
        <Button
          onClick={() => setIsOpen(true)}
          variant="filled"
          color="orange"
          size="sm"
        >
          🛠️ Dev Mode
        </Button>
      </div>
    )
  }

  return (
    <Paper
      shadow="xl"
      p="md"
      style={{
        position: "fixed",
        top: 10,
        right: 10,
        zIndex: 9999,
        maxWidth: 350,
        backgroundColor: "rgba(30, 30, 30, 0.95)",
        border: "1px solid rgba(255, 255, 255, 0.1)",
      }}
    >
      <div style={{ display: 'flex', flexDirection: 'column', gap: '0.5rem' }}>
        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
          <Text fw={700} size="lg" c="white">
            🛠️ Dev Mode
          </Text>
          <Button
            onClick={() => setIsOpen(false)}
            variant="subtle"
            color="gray"
            size="xs"
            compact
          >
            ✕
          </Button>
        </div>
        <Divider />
        
        <div>
          <Text fw={600} size="sm" c="white" style={{ marginBottom: '0.5rem' }}>
            Dialogue UI
          </Text>
          <Button
            onClick={testDialogue}
            variant="light"
            color="blue"
            fullWidth
            size="sm"
            style={{ marginBottom: '0.5rem' }}
          >
            Test Dialogue
          </Button>
        </div>

        <div>
          <Text fw={600} size="sm" c="white" style={{ marginBottom: '0.5rem' }}>
            Mission Status UI
          </Text>
          <Button
            onClick={testMissionStatus}
            variant="light"
            color="green"
            fullWidth
            size="sm"
            style={{ marginBottom: '0.5rem' }}
          >
            Test Mission Status
          </Button>
        </div>

        <div>
          <Text fw={600} size="sm" c="white" style={{ marginBottom: '0.5rem' }}>
            Timer UI
          </Text>
          <div style={{ display: 'flex', gap: '0.5rem' }}>
            <Button
              onClick={testTimer}
              variant="light"
              color="orange"
              size="sm"
              style={{ flex: 1 }}
            >
              Bottom Timer
            </Button>
            <Button
              onClick={testTimerTop}
              variant="light"
              color="orange"
              size="sm"
              style={{ flex: 1 }}
            >
              Top Timer
            </Button>
          </div>
        </div>

        <div>
          <Text fw={600} size="sm" c="white" style={{ marginBottom: '0.5rem' }}>
            Text UI
          </Text>
          <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '0.5rem' }}>
            <Button
              onClick={testTextUI}
              variant="light"
              color="violet"
              size="xs"
              style={{ flex: 1 }}
            >
              Bottom
            </Button>
            <Button
              onClick={testTextUITop}
              variant="light"
              color="violet"
              size="xs"
              style={{ flex: 1 }}
            >
              Top
            </Button>
          </div>
          <div style={{ display: 'flex', gap: '0.5rem' }}>
            <Button
              onClick={testTextUIRight}
              variant="light"
              color="violet"
              size="xs"
              style={{ flex: 1 }}
            >
              Right
            </Button>
            <Button
              onClick={testTextUILeft}
              variant="light"
              color="violet"
              size="xs"
              style={{ flex: 1 }}
            >
              Left
            </Button>
          </div>
        </div>

        <Divider />
        
        <Button
          onClick={hideAll}
          variant="filled"
          color="red"
          fullWidth
          size="sm"
        >
          Hide All UIs
        </Button>
      </div>
    </Paper>
  )
}

export default DevMode

