import { useEffect, useState } from "react";
import { MantineProvider, Transition } from "@mantine/core";
import { isEnvBrowser, useNuiEvent } from "./hooks/useNuiEvents";
import { Panel } from "./components/Panel";
import { getLang } from "./hooks/getLang";
import { AllItems } from "./types/types";
import { testList } from "./api/items";
import "./App.css";
import "@mantine/core/styles.css";

interface Parameters {
  state: boolean;
  items: AllItems;
  path: string;
}

const App = () => {
  const [lang, setLang] = useState<any>({});
  const [loaded, setLoaded] = useState(isEnvBrowser());
  const [invPath, setInvPath] = useState("");
  const [total, setTotal] = useState(0);
  const [itemList, setItemList] = useState<AllItems>(
    isEnvBrowser() ? testList : {}
  );

  useNuiEvent("show", (data: Parameters) => {
    if (data?.items) {
      setItemList(data.items);
      setTotal(Object.keys(data.items).length);
    }
    if (data?.path) {
      setInvPath(data.path);
    }
    setLoaded(data.state);
  });
  useEffect(() => {
    const fetchLang = async () => {
      const resp = await getLang();
      setLang(resp);
    };
    fetchLang();
  }, []);

  return (
    <>
      {loaded && (
        <MantineProvider defaultColorScheme="dark">
          <Transition
            mounted={loaded}
            transition="fade"
            duration={400}
            timingFunction="ease"
          >
            {(styles) => (
              <div style={styles}>
                <Panel
                  itemList={itemList}
                  invPath={invPath}
                  total={total}
                  lang={lang}
                />
              </div>
            )}
          </Transition>
        </MantineProvider>
      )}
    </>
  );
};

export default App;
