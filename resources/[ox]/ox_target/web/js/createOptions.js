import { fetchNui } from "./fetchNui.js";

const $optionsWrapper = $("#options-wrapper");

function onClick(){
    const $this = $(this);
    $this.css("pointer-events", "none");
    fetchNui("select", [$this.data("type"), $this.data("id"), $this.data("zone")]);
    setTimeout(() => $this.css("pointer-events", "auto"), 100);
}

export function createOptions(type, data, id, zoneId){
    if (data.hide) return;

    const iconColor = data.iconColor ? `style="color:${data.iconColor} !important"` : "";
    const $option = $("<div>", {
        html: `
            <i class="fa-fw ${data.icon} option-icon" ${iconColor}></i>
            <p class="option-label">${data.label}</p>
        `,
        class: "option-container mantine-Button-root mantine-Button-filled",
        css: { opacity: 0 }
    })
        .data({
            type: type,
            id: id,
            zone: zoneId
        })
        .on("click", onClick)
        .appendTo($optionsWrapper)
        .animate({ opacity: 1 }, {
            duration: 90,
            queue: false
        });
}
