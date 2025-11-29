import { useGlobalState } from "../providers/StateProvider";
import NotFishing from "./components/notFishing";
import LineDistance from "./components/lineDistance";
import Fishing from "./components/fishing";

function Hud(props) {
    const globalState = useGlobalState();

    const getVariantToDraw = (variant) => {
        if (variant == "notFishing") return <NotFishing {...props}/>
        if (variant == "getLineDistance") return <LineDistance {...props}/>
        if (variant == "fishing") return <Fishing {...props}/>
    };

    return <>{getVariantToDraw(globalState.pageData.variant)}</>
}

export default Hud;