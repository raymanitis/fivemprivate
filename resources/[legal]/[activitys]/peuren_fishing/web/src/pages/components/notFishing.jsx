import { Button } from "@/components/ui/button";
import { useGlobalState } from "@/src/providers/StateProvider";

function NotFishing({equippedBait}) {
    const globalState = useGlobalState();

    return <div className="bg-slate-800 shadow-lg bg-opacity-70 absolute bottom-12 p-4 rounded-lg flex flex-row gap-4 justify-center">
        <div className="flex justify-start items-center gap-2">
            <Button variant="outline" className="w-10 h-10">
                G
            </Button>
            <p className="text-md font-medium leading-none">{globalState.settings.locale.throwLine}</p>
        </div>
        <div className="flex justify-start items-center gap-2">
            <Button variant="outline" className="w-10 h-10">
                H
            </Button>
            <p className="text-md font-medium leading-none">{globalState.settings.locale.changeBait}</p>
        </div>
        <div className="flex justify-start items-center gap-2">
            <Button variant="outline" className="w-10 h-10">
                J
            </Button>
            <p className="text-md font-medium leading-none">{globalState.settings.locale.unequipRod}</p>
        </div>
        <div className="flex justify-start items-center gap-2 self-center">
            <p className="text-md font-bold leading-none">{globalState.settings.locale.equippedBait}</p>
            <p className="text-md font-medium leading-none">{equippedBait ? equippedBait : "None"}</p>
        </div>
    </div>
}

export default NotFishing;