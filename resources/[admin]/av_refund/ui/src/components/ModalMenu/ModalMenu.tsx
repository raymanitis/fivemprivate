import { useState } from "react";
import {
  Box,
  Group,
  Text,
  Button,
  ActionIcon,
  NumberInput,
  TextInput,
  ScrollArea,
  Stack,
} from "@mantine/core";
import { IconTrash } from "@tabler/icons-react";
import { useClickOutside } from "@mantine/hooks";
import { Item, StashItem } from "../../types/types";
import classes from "./style.module.css";
import { getRandomString } from "../../hooks/getRandomString";

interface Properties {
  item: Item;
  setShow: (state: boolean) => void;
  addToStash: (data: StashItem) => void;
  lang: any;
}

export const ModalMenu = ({ item, setShow, addToStash, lang }: Properties) => {
  const [data, setData] = useState<StashItem>(item);
  const ref = useClickOutside(() => setShow(false));
  const handleAmount = (amount: string | number) => {
    const newAmount = Number(amount);
    const copy = { ...data, amount: newAmount };
    setData(copy);
  };
  const addField = () => {
    const length = data?.metadata?.length ? data?.metadata.length + 1 : 1;
    if (length > 10) return;
    const name = `Field${length}`;
    const value = "";
    const serial = getRandomString(data.name);
    if (!data.metadata) {
      data.metadata = [];
    }
    const updatedMetadata = [...data.metadata, { field: name, value, serial }];
    setData({ ...data, metadata: updatedMetadata });
  };

  const handleDelete = (serial: string) => {
    setData((prevData) => {
      if (prevData.metadata) {
        const updatedMetadata = prevData.metadata.filter(
          (item) => item.serial !== serial
        );
        return { ...prevData, metadata: updatedMetadata };
      }
      return prevData;
    });
  };
  const handleUpdate = (
    serial: string,
    type: "field" | "value",
    value: string
  ) => {
    setData((prevData) => {
      if (!prevData.metadata) return prevData;
      const updatedMetadata = prevData.metadata.map((item) =>
        item.serial === serial ? { ...item, [type]: value } : item
      );
      return { ...prevData, metadata: updatedMetadata };
    });
  };
  return (
    <Box className={classes.container}>
      <Box className={classes.modal} ref={ref}>
        <Text fz="xl" ta="center" c="white" fw={500} lts={1} truncate>
          {item.label}
        </Text>
        <NumberInput
          label={lang.amount}
          value={data?.amount ? data.amount : 0}
          min={1}
          allowDecimal={false}
          allowLeadingZeros={false}
          allowNegative={false}
          size="xs"
          onChange={(e) => {
            handleAmount(e);
          }}
          classNames={classes}
        />
        {data?.metadata && data?.metadata[0] ? (
          <>
            <ScrollArea
              className={classes.scroll}
              type="always"
              scrollbars="y"
              offsetScrollbars
              scrollbarSize={4}
              mt="xs"
            >
              <Stack gap="xs">
                {data?.metadata?.map((info) => (
                  <Group key={info.serial}>
                    <TextInput
                      classNames={classes}
                      value={info.field}
                      onChange={(e) => {
                        handleUpdate(info.serial, "field", e.target.value);
                      }}
                      size="xs"
                    />
                    <TextInput
                      classNames={classes}
                      value={info.value}
                      onChange={(e) => {
                        handleUpdate(info.serial, "value", e.target.value);
                      }}
                      size="xs"
                    />
                    <ActionIcon
                      maw={30}
                      variant="transparent"
                      color="#FF453A"
                      size="xs"
                      onClick={() => {
                        handleDelete(info.serial);
                      }}
                    >
                      <IconTrash />
                    </ActionIcon>
                  </Group>
                ))}
              </Stack>
            </ScrollArea>
          </>
        ) : null}
        <Group mt="sm">
          <Button
            size="xs"
            ml="auto"
            variant="light"
            color="gray"
            fw={500}
            onClick={() => {
              addField();
            }}
          >
            {lang.metadata_button}
          </Button>
          <Button
            size="xs"
            color="#0A84FF"
            onClick={() => {
              addToStash(data);
              setShow(false);
            }}
            disabled={!data.amount}
            fw={500}
          >
            {lang.save_item}
          </Button>
        </Group>
      </Box>
    </Box>
  );
};
