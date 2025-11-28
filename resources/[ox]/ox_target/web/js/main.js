import { createOptions } from "./createOptions.js";

const $optionsWrapper = $("#options-wrapper");
const $body = $("body");
const $eye = $("#eyeSvg");

window.addEventListener("message", (event) => {
    const clearOptions = () => {
        $optionsWrapper.children().stop().animate({ opacity: 0 }, {
            duration: 90,
            complete: function() {
                $(this).remove();
            }
        });
    };

    clearOptions();

    switch(event.data.event){
        case "visible":{
            $body.css("visibility", event.data.state ? "visible" : "hidden");
            return $eye.removeClass("eye-hover");
        }

        case "leftTarget":{
            return $eye.removeClass("eye-hover");
        }

        case "setTarget":{
            $eye.addClass("eye-hover");
            
            if (event.data.options){
                for (const type in event.data.options){
                    event.data.options[type].forEach((data, id) => {
                        createOptions(type, data, id + 1);
                    });
                }
            }

            if (event.data.zones){
                for (let i = 0; i < event.data.zones.length; i++){
                    event.data.zones[i].forEach((data, id) => {
                        createOptions("zones", data, id + 1, i + 1);
                    });
                }
            }
        }
    }
});
