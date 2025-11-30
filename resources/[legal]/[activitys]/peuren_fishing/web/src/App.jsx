import Hud from "./pages/hud";
import { useGlobalState } from "./providers/StateProvider";

function App() {
  const globalState = useGlobalState();

  function getTheCurrentPage() {
    if (globalState.currentPage == "hud") {
      return <Hud {...globalState.pageData}/>;
    }
    return <></>
  }

  return (
    <div className="h-screen w-screen relative">
        {getTheCurrentPage()}
    </div>
  );
}

export default App;
