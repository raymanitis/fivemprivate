import { useState } from "react";
import {
  Box,
  Group,
  Grid,
  Text,
  Card,
  Image,
  ScrollArea,
  Button,
  Flex,
} from "@mantine/core";
import { ModalMenu } from "../ModalMenu/ModalMenu";
import { StashItem } from "../../types/types";
import classes from "./style.module.css";
import { fetchNui } from "../../hooks/useNuiEvents";

interface Properties {
  stash: StashItem[];
  invPath: string;
  setStash: (data: StashItem[]) => void;
  lang: any;
}

export const StashList = ({ stash, invPath, setStash, lang }: Properties) => {
  const [showModal, setShowModal] = useState(false);
  const [currentItem, setCurrentItem] = useState({
    name: "",
    label: "",
    serial: "",
  });
  const handleEdit = (item: StashItem) => {
    setCurrentItem(item);
    setShowModal(true);
  };
  const handleRemove = (serial: string) => {
    const updatedStash = stash.filter((item) => item.serial !== serial);
    setStash(updatedStash);
  };
  const handleModify = (data: StashItem) => {
    const updatedStash = stash.map((item) =>
      item.serial === data.serial ? { ...item, ...data } : item
    );
    setStash(updatedStash);
  };

  return (
    <Box style={{ overflow: "hidden" }}>
      {showModal && (
        <ModalMenu
          item={currentItem}
          setShow={setShowModal}
          addToStash={handleModify}
          lang={lang}
        />
      )}
      <Group p="md">
        <Flex direction="column">
          <Text fz="xl" fw={500} c="white">
            {lang.refund_stash}
          </Text>
          <Text fz="xs">{`${Object.values(stash).length} ${
            lang.items_refund
          }`}</Text>
        </Flex>
        <Button
          ml="auto"
          size="sm"
          color="#0A84FF"
          fw={500}
          disabled={stash.length == 0}
          onClick={() => {
            fetchNui("av_refund", "newStash", stash);
            setStash([]);
          }}
        >
          {lang.generate_code}
        </Button>
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
          {Object.values(stash).map((item) => (
            <Grid.Col key={item.serial} span={3}>
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
                <Text size="sm" c="gray.5">
                  <b>{`${lang.amount}:`}</b>
                  {` ${item.amount}`}
                </Text>
                <Text size="sm" c="gray.5">
                  <b>{lang.metadata}:</b>
                  {` ${
                    item?.metadata && item.metadata[0] ? lang.yes : lang.no
                  }`}
                </Text>
                <Group mt="sm" justify="center">
                  <Button
                    size="xs"
                    variant="transparent"
                    color="#FF453A"
                    fw={500}
                    onClick={() => {
                      handleRemove(item.serial);
                    }}
                  >
                    {lang.remove}
                  </Button>
                  <Button
                    size="xs"
                    color="#5E5CE6"
                    fw={500}
                    onClick={() => {
                      handleEdit(item);
                    }}
                  >
                    {lang.edit_item}
                  </Button>
                </Group>
              </Card>
            </Grid.Col>
          ))}
        </Grid>
      </ScrollArea>
    </Box>
  );
};
