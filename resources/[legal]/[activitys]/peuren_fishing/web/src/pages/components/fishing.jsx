import { useGlobalState } from "@/src/providers/StateProvider";
import { useEffect, useRef, useState } from "react";
import { fetchNui } from "@/src/utils/fetchNui";

function Fishing({breakLine}) {
    const globalState = useGlobalState();
    const [progressState, setProgressState] = useState(0);
    const spacePressed = useRef(false);
    const timeSinceLastCheck = useRef(new Date());

    useEffect(() => {
        function handleKeyDown(e) {
            if (spacePressed.current) return;;
            if (e.key == "e" || e.key == "E") {
                spacePressed.current = true;
                fetchNui("windFishingRod");
            }
        }

        function handleKeyUp(e) {
            if (!spacePressed.current) return;
            if (e.key == "e" || e.key == "E") {
                spacePressed.current = false;
                fetchNui("unwindFishingRod");
            }
        }

        const interval = setInterval(() => {
            if (spacePressed.current) {
                if (progressState >= breakLine) {
                    if (new Date() - timeSinceLastCheck.current > 1000) {
                        timeSinceLastCheck.current = new Date();

                        const breakChance = ((progressState - breakLine) / (100 - breakLine)) * 100;
                        const chance = Math.floor(Math.random() * (100 + 1));
                        if (chance < breakChance) {
                            fetchNui("breakRod");
                            document.removeEventListener('keydown', handleKeyDown);
                            document.removeEventListener('keyup', handleKeyUp);
                            clearInterval(interval);
                        }
                    }
                }

                if (progressState + 1.25 <= 100) {
                    setProgressState(prev => prev + 1.25);
                }
            } else {
                if (progressState - 1.25 >= 0) {
                    setProgressState(prev => prev - 1.25);
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
    }, [progressState, breakLine]);

    return <div className="absolute bottom-12 left-1/2 -translate-x-1/2 p-4 rounded-lg flex flex-col gap-4 justify-center items-center">
        <div className="flex justify-start items-center gap-2">
            <div className="bg-[#384f524f] border border-[#c2f4f967] w-9 h-9 rounded-[0.15rem] flex items-center justify-center text-base">
                <span>E</span>
            </div>
            <p className="text-md font-medium leading-none">{globalState.settings.locale.pullTheLine}</p>
        </div>
        <div className={`w-80 h-5 rounded-md shadow-xl relative bg-gradient-to-r from-green-500 via-${100 - breakLine}% to-red-900`}>
            <div className="h-full w-2 rounded-md bg-[#C2F4F9] absolute" style={{"left": `${progressState}%`}}></div>
        </div>
    </div>
}

export default Fishing;