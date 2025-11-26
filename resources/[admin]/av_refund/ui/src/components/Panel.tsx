import { useEffect, useState } from "react";
import { Box, Grid } from "@mantine/core";
import { ItemList } from "./ItemList/ItemList";
import { Navbar } from "./Navbar/Navbar";
import { AllItems, StashItem } from "../types/types";
import { StashList } from "./StashList/StashList";
import classes from "./styles.module.css";
import { fetchNui } from "../hooks/useNuiEvents";

interface Properties {
  invPath: string;
  itemList: AllItems;
  total: number;
  lang: any;
}

export const Panel = ({ invPath, itemList, total, lang }: Properties) => {
  const [filtered, setFiltered] = useState<AllItems>(itemList);
  const [stash, setStash] = useState<StashItem[]>([]);
  const [tab, setTab] = useState("items");

  const handleAdd = (data: StashItem) => {
    fetchNui("av_refund", "notification", {
      title: lang.title,
      message: lang.stash_updated,
      type: "inform",
    });
    setStash((prevStashes) => [...prevStashes, data]);
  };

  const handleSearch = (input: string) => {
    if (input === "") {
      setFiltered(itemList);
    } else {
      const res = Object.keys(itemList).reduce((acc: AllItems, key) => {
        const item = itemList[key];

        if (
          item &&
          (String(item.name).toLowerCase().includes(input.toLowerCase()) ||
            String(item.label).toLowerCase().includes(input.toLowerCase()))
        ) {
          acc[key] = item;
        }
        return acc;
      }, {} as AllItems);

      setFiltered(res);
    }
  };

  const onPressKey = (e: any) => {
    switch (e.code) {
      case "Escape":
        fetchNui("av_refund", "close");
        break;
      default:
        break;
    }
  };
  useEffect(() => {
    window.addEventListener("keydown", onPressKey);
    return () => {
      window.removeEventListener("keydown", onPressKey);
    };
  }, []);

  return (
    <Box className={classes.container}>
      <Grid className={classes.panel}>
        <Grid.Col maw={65}>
          <Navbar tab={tab} setTab={setTab} lang={lang} />
        </Grid.Col>
        <Grid.Col span={"auto"}>
          {tab == "items" ? (
            <ItemList
              handleSearch={handleSearch}
              items={filtered}
              invPath={invPath}
              addToStash={handleAdd}
              total={total}
              lang={lang}
            />
          ) : (
            <StashList
              stash={stash}
              invPath={invPath}
              setStash={setStash}
              lang={lang}
            />
          )}
        </Grid.Col>
      </Grid>
    </Box>
  );
};
