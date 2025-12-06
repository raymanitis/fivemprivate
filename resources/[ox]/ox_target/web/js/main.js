import { createOptions } from "./createOptions.js";

const $optionsWrapper = $("#options-wrapper");
const $body = $("body");
const $eye = $("#eyeSvg");

window.addEventListener("message", (event) => {
    const clearOptions = (animate = true) => {
        if (animate) {
            $optionsWrapper.children().stop().animate({ 
                opacity: 0,
                transform: 'scale(0.9) translateY(10px)'
            }, {
                duration: 200,
                easing: 'ease-in',
                complete: function() {
                    $(this).remove();
                }
            });
        } else {
            // Immediately remove without animation
            $optionsWrapper.children().stop(true, true).remove();
        }
    };

    switch(event.data.event){
        case "visible":{
            $body.css("visibility", event.data.state ? "visible" : "hidden");
            if (!event.data.state) {
                clearOptions(false);
            }
            return $eye.removeClass("eye-hover");
        }

        case "leftTarget":{
            clearOptions(false);
            return $eye.removeClass("eye-hover");
        }

        case "setTarget":{
            // Immediately clear old options before adding new ones
            clearOptions(false);
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
