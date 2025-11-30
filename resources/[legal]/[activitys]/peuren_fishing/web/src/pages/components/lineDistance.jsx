import { Progress } from "@/components/ui/progress";
import { useEffect, useRef, useState } from "react";
import { fetchNui } from "@/src/utils/fetchNui";
import { useGlobalState } from "@/src/providers/StateProvider";

function LineDistance() {
    const globalState = useGlobalState();
    const [progressState, setProgressState] = useState(0);
    const spacePressed = useRef(false);

    useEffect(() => {
        function handleKeyDown(e) {
            if (spacePressed.current) return;
            if (e.key == "e") {
                spacePressed.current = true;
            }
        }

        function handleKeyUp(e) {
            if (!spacePressed.current) return;
            if (e.key == "e") {
                clearInterval(interval);
                fetchNui("sendLineDistance", progressState);
            }
        }

        const interval = setInterval(() => {
            if (spacePressed.current) {
                if (progressState + 1.25 <= 100) {
                    setProgressState(prev => prev + 1.25)
                } else {
                    clearInterval(interval);
                }
            }
        }, 25);
    
        document.addEventListener('keydown', handleKeyDown);
        document.addEventListener('keyup', handleKeyUp);
    
        return function cleanup() {
          document.removeEventListener('keydown', handleKeyDown);
          document.removeEventListener('keyup', handleKeyUp);
          clearInterval(interval);
        }
    }, [progressState]);

    return <div className="absolute bottom-12 left-1/2 -translate-x-1/2 w-96 flex flex-col gap-4 items-center justify-center">
        <div className="flex justify-start items-center gap-2">
            <p className="text-md font-medium leading-none">{globalState.settings.locale.hold} </p>
            <div className="bg-[#384f524f] border border-[#c2f4f967] w-9 h-9 rounded-[0.15rem] flex items-center justify-center text-base">
                <span>E</span>
            </div>
            <p className="text-md font-medium leading-none"> {globalState.settings.locale.toCastTheLine}</p>
        </div>
        <Progress value={progressState} className="bg-[#121a1c] [&>div]:bg-[#C2F4F9]"/> 
    </div>
}

export default LineDistance;