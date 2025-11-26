import { Stack, ActionIcon, Tooltip } from "@mantine/core";
import { IconPackage, IconList, IconPower } from "@tabler/icons-react";
import classes from "./styles.module.css";
import { fetchNui } from "../../hooks/useNuiEvents";

interface Properties {
  setTab: (option: string) => void;
  tab: string;
  lang: any;
}

export const Navbar = ({ tab, setTab, lang }: Properties) => {
  return (
    <Stack className={classes.content} gap="lg">
      <Tooltip
        label={lang.items_tab}
        position="right-start"
        color="dark.4"
        openDelay={150}
        withArrow
      >
        <ActionIcon
          size="sm"
          variant="transparent"
          color={tab == "items" ? `#64D2FF` : `white`}
          onClick={() => {
            setTab("items");
          }}
        >
          <IconList />
        </ActionIcon>
      </Tooltip>
      <Tooltip
        label={lang.stash_tab}
        position="right-start"
        color="dark.4"
        openDelay={150}
        withArrow
      >
        <ActionIcon
          size="sm"
          variant="transparent"
          color={tab == "stash" ? `#64D2FF` : `white`}
          onClick={() => {
            setTab("stash");
          }}
        >
          <IconPackage />
        </ActionIcon>
      </Tooltip>
      <Tooltip
        label={lang.close}
        position="right-start"
        color="dark.4"
        openDelay={150}
        withArrow
      >
        <ActionIcon
          size="sm"
          variant="transparent"
          color="#FF453A"
          style={{ position: "absolute", bottom: 0, marginBottom: "20px" }}
          onClick={() => {
            fetchNui("av_refund", "close");
          }}
        >
          <IconPower />
        </ActionIcon>
      </Tooltip>
    </Stack>
  );
};
