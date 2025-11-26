let shouldShowAFKQuestion = false;
let timePaused = false;
let timeLeft = 0;
let doAfkChecks = false;

const sendNui = (callbackName, data) => {
    fetch(`https://${GetParentResourceName()}/${callbackName}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8'
        },
        body: JSON.stringify(data)
    })
        .catch(err => console.error(err));
};

const getRandomColor = () => {
    let letters = "0123456789ABCDEF";
    let color = "#";
    for (let i = 0; i < 6; i++){
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}

const getContrastingTextColor = (hexColor) => {
    const hex = hexColor.replace('#', '');
    const r = parseInt(hex.substr(0, 2), 16);
    const g = parseInt(hex.substr(2, 2), 16);
    const b = parseInt(hex.substr(4, 2), 16);
    const luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    return luminance > 0.5 ? '#000000' : '#FFFFFF';
};

const afkCheck = () => {
    if (!doAfkChecks) return;
    if (!shouldShowAFKQuestion){
        shouldShowAFKQuestion = true;
        sendNui('toggleNui', { toggle: true })

        const $button = $('<button id="random-button">Press Me</button>');
        $('body')
            .append($button);
        $('body')
            .css({
                "background-color": "rgba(0,0,0,0.45)"
            });
        $('.text-container')
            .css({
                display: 'flex',
                opacity: 0
            })
            .animate({ opacity: 1 }, 150);
        $("#seconds_left")
            .text(`${timeLeft} minutes`);

        const winWidth = $(window)
            .width();
        const winHeight = $(window)
            .height();
        const btnWidth = $button.outerWidth();
        const btnHeight = $button.outerHeight();
        const randLeft = Math.floor(Math.random() * (winWidth - btnWidth));
        const randTop = Math.floor(Math.random() * (winHeight - btnHeight));

        const bgColor = getRandomColor();
        const textColor = getContrastingTextColor(bgColor);

        $button.css({
            left: randLeft + 'px',
            top: randTop + 'px',
            backgroundColor: bgColor,
            color: textColor
        });
        $button.fadeIn(150);
        $button.on('click', function(){
            $(this)
                .remove();
            $('.text-container')
                .fadeOut(150);
            $('#time_left_text')
                .html(`
                <a id="seconds_left" class="default_text">${timeLeft} ${timeLeft.toString()
                    .endsWith('1') ? 'minute' : 'minutes'}</a> left until sentence ends!
            `)
            $('body')
                .css({
                    "background-color": "transparent"
                });
            shouldShowAFKQuestion = false;
            if (timePaused){
                sendNui("toggleTime", { pause: false })
                timePaused = false
            }
            sendNui('toggleNui', { toggle: false })
            doAfkChecks = false;
            setTimeout(() => {
                if (timeLeft > 0){
                    doAfkChecks = true;
                }
            }, 5000);
        });
    } else {
        if (!timePaused){
            sendNui("toggleTime", { pause: true })
            timePaused = true;

            $("#time_left_text")
                .html(`
                TIME IS <a class="default_text" style="color: red; font-weight: 900;">PAUSED</a>!
                <br />
                <a id="seconds_left" class="default_text">${timeLeft} ${timeLeft.toString()
                    .endsWith('1') ? 'minute' : 'minutes'}</a> left until sentence ends!
            `)
        }
    }
};

window.addEventListener('message', (event) => {
    const data = event.data
    switch(data.action){
        case "updateTime":
            timeLeft = data.time;
            $("#time")
                .text(`${timeLeft} ${timeLeft.toString()
                    .endsWith('1') ? 'minute' : 'minutes'}`)
            if (timePaused || $(".text-container")
                .is(":visible")){
                $("#seconds_left")
                    .text(`${timeLeft} ${timeLeft.toString()
                        .endsWith('1') ? 'minute' : 'minutes'}`);
            }
            if (timeLeft <= 0){
                shouldShowAFKQuestion = false;
                timeLeft = 0;
                $('.text-container')
                    .fadeOut(150);
                $('.time-counter-container')
                    .fadeOut(150);
                $('#time_left_text')
                    .html(`
                    <a id="seconds_left" class="default_text">${timeLeft} ${timeLeft.toString()
                        .endsWith('1') ? 'minute' : 'minutes'}</a> left until sentence ends!
                `)
                $('body')
                    .css({
                        "background-color": "transparent"
                    });
                shouldShowAFKQuestion = false;
                if (timePaused){
                    sendNui("toggleTime", { pause: false })
                    timePaused = false
                }
                doAfkChecks = false;
                sendNui('unjail', {
                    ok: "true",
                    type: "timeout",
                    player: GetParentResourceName()
                });
                window.dispatchEvent(new MessageEvent('message', {
                    data: { action: 'unjailed' }
                }));
            }
            break;
        case "jailed":
            shouldShowAFKQuestion = false;
            timeLeft = data.time;
            $(".time-counter-container")
                .fadeIn(150);
            $("#time")
                .text(`${timeLeft} ${timeLeft.toString()
                    .endsWith('1') ? 'minute' : 'minutes'}`);
            $("#reason")
                .text(data.reason);
            $("#admin")
                .text(data.admin);
            if (timeLeft >= 15){
                doAfkChecks = true;
            }
            break;
        case "unjailed":
            shouldShowAFKQuestion = false;
            timeLeft = 0;
            $('.text-container')
                .fadeOut(150);
            $('.time-counter-container')
                .fadeOut(150);
            $('#time_left_text')
                .html(`
                <a id="seconds_left" class="default_text">${timeLeft} ${timeLeft.toString()
                    .endsWith('1') ? 'minute' : 'minutes'}</a> left until sentence ends!
            `)
            $('body')
                .css({
                    "background-color": "transparent"
                });
            shouldShowAFKQuestion = false;
            if (timePaused){
                sendNui("toggleTime", { pause: false })
                timePaused = false
            }
            doAfkChecks = false;
            break;
    }
});

do {
    setInterval(() => {
        afkCheck()
    }, 5 * (60 * 1000)) // 5min
    //}, 5000) // testesanai
} while(doAfkChecks)