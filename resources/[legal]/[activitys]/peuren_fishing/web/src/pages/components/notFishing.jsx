import { useGlobalState } from "@/src/providers/StateProvider";

function NotFishing({equippedBait}) {
    const globalState = useGlobalState();

    return (
        <div className="absolute bottom-4 right-4 flex flex-col gap-2 items-end">
            <div className="px-3 py-2.5 rounded bg-[#121a1cde] flex flex-col gap-2 w-fit">
                <div className="flex flex-col gap-1.5">
                    <div className="flex items-center gap-1">
                        <div className="bg-[#384f524f] border border-[#c2f4f967] w-9 h-9 rounded-[0.15rem] flex items-center justify-center text-base">
                            <span>G</span>
                        </div>
                        <span className="ml-2 text-sm">{globalState.settings.locale.throwLine}</span>
                    </div>
                    <div className="flex items-center gap-1">
                        <div className="bg-[#384f524f] border border-[#c2f4f967] w-9 h-9 rounded-[0.15rem] flex items-center justify-center text-base">
                            <span>H</span>
                        </div>
                        <span className="ml-2 text-sm">{globalState.settings.locale.changeBait}</span>
                    </div>
                    <div className="flex items-center gap-1">
                        <div className="bg-[#384f524f] border border-[#c2f4f967] w-9 h-9 rounded-[0.15rem] flex items-center justify-center text-base">
                            <span>J</span>
                        </div>
                        <span className="ml-2 text-sm">{globalState.settings.locale.unequipRod}</span>
                    </div>
                </div>
            </div>
            {equippedBait && (
                <div className="px-3 py-2.5 rounded bg-[#121a1cde] flex flex-col w-fit">
                    <div className="flex flex-col">
                        <span className="text-xs text-white/50">{globalState.settings.locale.equippedBait}</span>
                        <span className="text-xl">{equippedBait}</span>
                    </div>
                </div>
            )}
        </div>
    );
}

export default NotFishing;