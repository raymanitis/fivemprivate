import { Progress } from "@/components/ui/progress";
import { Button } from "@/components/ui/button";
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

    return <div className="absolute bottom-12 w-96 flex flex-col gap-4 items-center justify-center">
        <div className="flex justify-start items-center gap-2">
            <p className="text-md font-medium leading-none">{globalState.settings.locale.hold} </p>
            <Button variant="outline" className="w-10 h-10">
                E
            </Button>
            <p className="text-md font-medium leading-none"> {globalState.settings.locale.toCastTheLine}</p>
        </div>
        <Progress value={progressState}/> 
    </div>
}

export default LineDistance;