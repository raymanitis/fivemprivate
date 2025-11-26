import { useState } from "react";
import {
  Box,
  Group,
  Grid,
  Text,
  Card,
  Image,
  TextInput,
  ScrollArea,
  Button,
  Flex,
} from "@mantine/core";
import { IconSearch } from "@tabler/icons-react";
import { AllItems, Item, StashItem } from "../../types/types";
import { ModalMenu } from "../ModalMenu/ModalMenu";
import { getRandomString } from "../../hooks/getRandomString";
import classes from "./style.module.css";

interface Properties {
  invPath: string;
  items: AllItems;
  handleSearch: (input: string) => void;
  addToStash: (data: StashItem) => void;
  total: number;
  lang: any;
}

export const ItemList = ({
  invPath,
  items,
  handleSearch,
  addToStash,
  total,
  lang,
}: Properties) => {
  const [showModal, setShowModal] = useState(false);
  const [currentItem, setCurrentItem] = useState({
    name: "",
    label: "",
    serial: "",
  });

  const handleAdd = (item: Item) => {
    const serial = getRandomString(item.name);
    const copy = { ...item, serial };
    setCurrentItem(copy);
    setShowModal(true);
  };
  return (
    <Box style={{ overflow: "hidden" }}>
      {showModal && (
        <ModalMenu
          item={currentItem}
          setShow={setShowModal}
          addToStash={addToStash}
          lang={lang}
        />
      )}
      <Group p="md">
        <Flex direction="column">
          <Text fz="xl" fw={500} c="white">
            {lang.title}
          </Text>
          <Text fz="xs">{`${lang.you_have} ${total} ${lang.items}`}</Text>
        </Flex>

        <TextInput
          classNames={classes}
          ml="auto"
          placeholder={lang.search}
          leftSectionPointerEvents="none"
          leftSection={<IconSearch style={{ width: "16px", height: "16px" }} />}
          onChange={(e) => {
            handleSearch(e.target.value);
          }}
        />
      </Group>
      <ScrollArea
        className={classes.content}
        type="always"
        scrollbars="y"
        offsetScrollbars
        scrollbarSize={4}
        p="md"
        pt="unset"
      >
        <Grid gutter="sm" style={{ overflow: "hidden" }}>
          {Object.values(items)
            .slice(0, 99)
            .map((item) => (
              <Grid.Col key={item.name} span={3}>
                <Card
                  bg={"#2c2c2e"}
                  style={{
                    justifyContent: "center",
                    textAlign: "center",
                    justifyItems: "center",
                  }}
                >
                  <Card.Section p="xs">
                    <Image
                      src={`https://cfx-nui-${invPath}${item.name}.png`}
                      fallbackSrc="./noimage.png"
                      style={{ marginLeft: "auto", marginRight: "auto" }}
                      h={65}
                      w={65}
                    />
                  </Card.Section>
                  <Text fw={500} size="lg" c="white" truncate>
                    {item.label}
                  </Text>
                  <Text size="sm" c="dimmed">
                    {item.name}
                  </Text>
                  <Button
                    mt="sm"
                    size="xs"
                    color="#5E5CE6"
                    fw={500}
                    onClick={() => {
                      handleAdd(item);
                    }}
                  >
                    {lang.add_item}
                  </Button>
                </Card>
              </Grid.Col>
            ))}
        </Grid>
      </ScrollArea>
    </Box>
  );
};
