const resName = GetParentResourceName();

let isCreatingGlobalBlip = false;
let blipIdToDuplicate = null;

let isAdmin = false;

let currentGameBuild = null;

let spritesIDs = {};

const colors = {
    [0]: "rgb(254, 254, 254)",
    [1]: "rgb(224, 50, 50)",
    [2]: "rgb(113, 203, 113)",
    [3]: "rgb(93, 182, 229)",
    [4]: "rgb(254, 254, 254)",
    [5]: "rgb(238, 198, 78)",
    [6]: "rgb(194, 80, 80)",
    [7]: "rgb(156, 110, 175)",
    [8]: "rgb(254, 122, 195)",
    [9]: "rgb(245, 157, 121)",
    [10]: "rgb(177, 143, 131)",
    [11]: "rgb(141, 206, 167)",
    [12]: "rgb(112, 168, 174)",
    [13]: "rgb(211, 209, 231)",
    [14]: "rgb(143, 126, 152)",
    [15]: "rgb(106, 196, 191)",
    [16]: "rgb(213, 195, 152)",
    [17]: "rgb(234, 142, 80)",
    [18]: "rgb(151, 202, 233)",
    [19]: "rgb(178, 98, 135)",
    [20]: "rgb(143, 141, 121)",
    [21]: "rgb(166, 117, 94)",
    [22]: "rgb(175, 168, 168)",
    [23]: "rgb(231, 141, 154)",
    [24]: "rgb(187, 214, 91)",
    [25]: "rgb(12, 123, 86)",
    [26]: "rgb(122, 195, 254)",
    [27]: "rgb(171, 60, 230)",
    [28]: "rgb(205, 168, 12)",
    [29]: "rgb(69, 97, 171)",
    [30]: "rgb(41, 165, 184)",
    [31]: "rgb(184, 155, 123)",
    [32]: "rgb(200, 224, 254)",
    [33]: "rgb(240, 240, 150)",
    [34]: "rgb(237, 140, 161)",
    [35]: "rgb(249, 138, 138)",
    [36]: "rgb(251, 238, 165)",
    [37]: "rgb(254, 254, 254)",
    [38]: "rgb(44, 109, 184)",
    [39]: "rgb(154, 154, 154)",
    [40]: "rgb(76, 76, 76)",
    [41]: "rgb(242, 157, 157)",
    [42]: "rgb(108, 183, 214)",
    [43]: "rgb(175, 237, 174)",
    [44]: "rgb(255, 167, 95)",
    [45]: "rgb(241, 241, 241)",
    [46]: "rgb(236, 240, 41)",
    [47]: "rgb(255, 154, 24)",
    [48]: "rgb(246, 68, 165)",
    [49]: "rgb(224, 58, 58)",
    [50]: "rgb(138, 109, 227)",
    [51]: "rgb(255, 139, 92)",
    [52]: "rgb(65, 108, 65)",
    [53]: "rgb(179, 221, 243)",
    [54]: "rgb(58, 100, 121)",
    [55]: "rgb(160, 160, 160)",
    [56]: "rgb(132, 114, 50)",
    [57]: "rgb(101, 185, 231)",
    [58]: "rgb(75, 65, 117)",
    [59]: "rgb(225, 59, 59)",
    [60]: "rgb(240, 203, 88)",
    [61]: "rgb(205, 63, 152)",
    [62]: "rgb(207, 207, 207)",
    [63]: "rgb(39, 106, 159)",
    [64]: "rgb(216, 123, 27)",
    [65]: "rgb(142, 131, 147)",
    [66]: "rgb(240, 203, 87)",
    [67]: "rgb(101, 185, 231)",
    [68]: "rgb(101, 185, 231)",
    [69]: "rgb(121, 205, 121)",
    [70]: "rgb(239, 202, 87)",
    [71]: "rgb(239, 202, 87)",
    [72]: "rgb(61, 61, 61)",
    [73]: "rgb(239, 202, 87)",
    [74]: "rgb(101, 185, 231)",
    [75]: "rgb(224, 50, 50)",
    [76]: "rgb(120, 35, 35)",
    [77]: "rgb(101, 185, 231)",
    [78]: "rgb(58, 100, 121)",
    [79]: "rgb(224, 50, 50)",
    [80]: "rgb(101, 185, 231)",
    [81]: "rgb(242, 164, 12)",
    [82]: "rgb(164, 204, 170)",
    [83]: "rgb(168, 84, 242)",
    [84]: "rgb(101, 185, 231)",
    [85]: "rgb(61, 61, 61)",
}

function showNotification(message, duration=false) {
    var notification = $("#notification");
    
    if(duration) {
        notification.toast({
            autohide: true,
            delay: duration
        })
    } else {
        notification.toast({
            autohide: false,
        })
    }

    $("#notification-message").text(message)

    notification.toast("show")
}

function getPathForSprite(spriteId) {
    const spriteData = spritesIDs[spriteId]
    if(spriteData.position) {
        return `../_sprites/REPLACEABLE/${spriteData.image}`
    } else {
        return `../_sprites/NOT_REPLACEABLE/${spriteData.image}`
    }
}

function fillSprites(){
    var spritesDiv = $("#blip-sprites");
    
    for (const [id, spriteData] of Object.entries(spritesIDs)) {
        var currentSpritesCount = spritesDiv.children().last().children().length

        var sprite = $(`
            <div class="col-1">
                <img src="${getPathForSprite(id)}" class="blip-sprite img-fluid p-2">
            </div>
        `)

        sprite.val(id)

        if(currentSpritesCount < 12 && currentSpritesCount > 0) {
            var lastRow = spritesDiv.children().last();

            lastRow.append(sprite)
        } else {
            var newRow = $(`<div class="row"></div>`);

            newRow.append(sprite)

            spritesDiv.append(newRow)
        }

        sprite.click(function(){
            var blipSprite = $(this).val();
            var blipId = $("#edit-blip").val()
            
            $("#blip-sprites").hide();

            if(spritesIDs[blipSprite].gameBuild <= gameBuild) {
                $("#edit-blip-sprite").attr("src", getPathForSprite(blipSprite))
        
                $.post(`https://${resName}/edit-blip-sprite`, JSON.stringify({blipSprite: blipSprite, blipId: blipId}))
            } else {
                showNotification(`This sprite requires ${spritesIDs[blipSprite].gameBuild} server game build`, 3000)
            }

        })
    }
}

function fillColors(){
    var colorsDiv = $("#blip-colors")

    for (const [id, rgb] of Object.entries(colors)) {
        var currentColorsCount = colorsDiv.children().last().children().length

        var color = $(`<div class="blip-color m-1 col-1"></div>`);
        color.css({"background-color": rgb});
        color.data("color-id", id)

        if(currentColorsCount < 9 && currentColorsCount > 0) {
            var lastRow = colorsDiv.children().last();

            lastRow.append(color);
        } else {
            var newRow = $(`<div class="row"></div>`);

            newRow.append(color)

            colorsDiv.append(newRow) 
        }

        color.click(function(){
            var blipId = $("#edit-blip").val();
            var blipColor = $(this).data("color-id");

            $.post(`https://${resName}/edit-blip-color`, JSON.stringify({blipId: blipId, blipColor: blipColor}))
        })
    }
} fillColors();

function editBlip(blipId, blipData) {
    $("#edit-blip").val(blipId);

    setBlipType(blipData.type)

    $(`#edit-blip-type option[value="${blipData.type}"]`).prop("selected", true)

    $("#edit-blip-name").val(blipData.name)
    $("#edit-blip-scale").val(blipData.scale)
    $("#edit-blip-alpha").val(blipData.alpha)
    $("#edit-blip-sprite").attr("src", getPathForSprite(blipData.sprite))
    $("#edit-blip-tick").prop("checked", blipData.ticked)
    $("#edit-blip-outline").prop("checked", blipData.outline)
    
    // If is global hides share btn
    if(!blipData.identifier) {
        $("#edit-blip-share-btn").hide();
        $("#edit-blip").data("is-global", true);
        $("#edit-blip").data("global-id", blipData.id);
    } else {
        $("#edit-blip-share-btn").show();
        $("#edit-blip").data("is-global", false);
    }

    switch(blipData.display){
        case 2: {
            $("#edit-blip-display-both").prop("checked", true)
            $("#edit-blip-display-mainmap").prop("checked", false)
            $("#edit-blip-display-minimap").prop("checked", false)
            break;
        }

        case 3: {
            $("#edit-blip-display-both").prop("checked", false)
            $("#edit-blip-display-mainmap").prop("checked", true)
            $("#edit-blip-display-minimap").prop("checked", false)
            break;
        }

        case 5: {
            $("#edit-blip-display-both").prop("checked", false)
            $("#edit-blip-display-mainmap").prop("checked", false)
            $("#edit-blip-display-minimap").prop("checked", true)
            break;
        }
    }

    $("#map-utilities").hide();
    $("#edit-blip").fadeIn();
    $("#edit-blip").scrollTop(0)
}

function hideBlip(blipId) {
    $.post(`https://${resName}/hide-blip`, JSON.stringify({blipId: blipId}))
}

function showBlip(blipId) {
    $.post(`https://${resName}/show-blip`, JSON.stringify({blipId: blipId}))
}

function addBlip(blipId, blipData, canBeEdited){
    var container = $("#blips-container");
    var lastRow = container.children().last();

    var currentBlipsInRow = lastRow.children().length;

    var blipDiv = $(`
        <div class="blip col border rounded m-2">
            <nav class="col-12 float-end">
                <ul class="pagination float-end">
                    <li class="page-item">
                        <i class="blip-duplicate icon-hoverable bi bi-back float-end fs-3 mx-2"></i>
                    </li>     
                    <li class="page-item">
                        ${blipData.isHidden && '<i class="blip-toggle icon-hoverable bi bi-eye-slash float-end fs-3"></i>' || '<i class="blip-toggle icon-hoverable bi bi-eye float-end fs-3"></i>'}
                    </li>
                </ul>
            </nav>

            <p class="blip-name text-center fs-2 fw-bold mt-1">${blipData.name}</p>
            <p class="blip-street text-center fs-5 fw-light">${blipData.streetName}</p>
        </div>
    `);

    if(blipData.type == "coords") {
        blipDiv.append(`
            <img src="${getPathForSprite(blipData.sprite)}" class="blip-sprite rounded mx-auto d-block mb-3" alt="...">
        `)
    } else if(blipData.type == "area") {
        blipDiv.append(`<p class="text-center fs-4">Area</p>`)
    }else if(blipData.type == "radius") {
        blipDiv.append(`<p class="text-center fs-4">Radius</p>`)
    }

    if(!blipData.identifier) {
        blipDiv.addClass("border-warning");
    }

    if(currentBlipsInRow < 4 && currentBlipsInRow > 0) {
        lastRow.append(blipDiv);
    } else {
        var newRow = $(`<div class="row"></div>`);

        newRow.append(blipDiv);
        newRow.append(blipDiv);

        container.append(newRow);
    }

    if(canBeEdited) {
        blipDiv.click(function(){
            editBlip(blipId, blipData);
        })
    }

    blipDiv.find('.blip-toggle').click(function(e) {
        e.preventDefault();
        e.stopPropagation();

        let eyeDiv = $(this)

        if(eyeDiv.hasClass("bi-eye")) {
            eyeDiv.removeClass("bi-eye");
            eyeDiv.addClass("bi-eye-slash");

            hideBlip(blipId)
        } else {
            eyeDiv.removeClass("bi-eye-slash");
            eyeDiv.addClass("bi-eye");

            showBlip(blipId)
        }
    });

    blipDiv.find(".blip-duplicate").click(function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        blipIdToDuplicate = blipId;
        
        $("#map-utilities").hide();
        $("#create-blip-mode").modal("show");
    });
}

function addBlips(blips, isAdmin) {
    $("#blips-container").empty();

    if(Object.keys(blips).length > 0) {
        let globalBlips = {} // Separated so it can be added after local blips (sorting)

        for (const [blipId, blipData] of Object.entries(blips)) {
            if(blipData){
                if(blipData.identifier) {
                    addBlip(blipId, blipData, true)
                } else {
                    globalBlips[blipId] = blipData
                }
            }
        }

        for (const [blipId, blipData] of Object.entries(globalBlips)) {
            if(blipData){
                addBlip(blipId, blipData, isAdmin)
            }
        }
    } else {
        $("#blips-container").append(`<p class="mt-4 fs-1 text-center">No blips created</p>`);
    }
}

$("#edit-blip-sprite").click(function(){
    $("#blip-sprites").fadeIn();
})

$("#edit-blip-close-btn").click(function(){
    var editBlipDiv = $("#edit-blip");
    var blipId = parseInt(editBlipDiv.val());

    $.post(`https://${resName}/save-blip`, JSON.stringify({blipId: blipId}), function(isSuccessful){
        $("#edit-blip").hide();
        openBlipsMenu()
    })
})

$("#map-utilities-close-btn").click(function(){
    $("#map-utilities").fadeOut();
    $.post(`https://${resName}/close`)
})

$("#create-blip-btn").click(function(){
    $("#map-utilities").hide();

    $("#create-blip-mode").modal("show");
})

$("#edit-blip-name").change(function(){
    var blipId = $("#edit-blip").val()
    var blipName = $(this).val();
    
    $.post(`https://${resName}/edit-blip-name`, JSON.stringify({blipId: blipId, blipName: blipName}))
})

$("#edit-blip-scale").change(function(){
    var blipId = $("#edit-blip").val()
    var blipScale = $(this).val();

    $.post(`https://${resName}/edit-blip-scale`, JSON.stringify({blipId: blipId, blipScale: blipScale}))
})

$("#edit-blip-alpha").change(function(){
    var blipId = $("#edit-blip").val()
    var blipAlpha = $(this).val();

    $.post(`https://${resName}/edit-blip-alpha`, JSON.stringify({blipId: blipId, blipAlpha: blipAlpha}))
})

$("#edit-blip-tick").change(function(){
    var blipId = $("#edit-blip").val()
    var blipTick = $(this).prop("checked");

    $.post(`https://${resName}/edit-blip-tick`, JSON.stringify({blipId: blipId, blipTick: blipTick}))
})

$("#edit-blip-outline").change(function(){
    var blipId = $("#edit-blip").val()
    var blipOutline = $(this).prop("checked");

    $.post(`https://${resName}/edit-blip-outline`, JSON.stringify({blipId: blipId, blipOutline: blipOutline}))
})

$("#edit-blip-delete-btn").click(function(){
    $("#delete-blip-modal").modal("show");
})

$("#delete-blip-btn").click(function(){
    var editBlipDiv = $("#edit-blip");
    var blipId = $("#edit-blip").val()

    if(editBlipDiv.data("is-global")) {
        var globalId = parseInt(editBlipDiv.data("global-id"));

        $.post(`https://${resName}/delete-global-blip`, JSON.stringify({globalId: globalId, blipId: blipId}))
    } else {
        $.post(`https://${resName}/delete-blip`, JSON.stringify({blipId: blipId}))
    }

    $("#delete-blip-modal").modal("hide");
    
    $("#edit-blip").hide();
    
    openBlipsMenu()
})

$('input[type=range]').on('input', function () {
    $(this).trigger('change');
});

$('input[type=radio][name=edit-blip-display]').change(function() {
    var blipId = $("#edit-blip").val()
    var display = $(this).data("display");

    $.post(`https://${resName}/edit-blip-display`, JSON.stringify({blipId: blipId, blipDisplay: display}))
});

$("#create-blip-from-coords-btn").click(function(){
    $("#x-coord").val("");
    $("#y-coord").val("");
    $("#z-coord").val("");
    
    $("#x-coord").removeClass("is-invalid");
    $("#y-coord").removeClass("is-invalid");
    $("#z-coord").removeClass("is-invalid");

    $("#create-blip-mode").modal("hide")
    $("#create-from-coords-modal").modal("show")
})

$("#confirm-from-coords").click(function(){
    var isEverythingFilled = true;

    var xInput = $("#x-coord")
    var yInput = $("#y-coord")
    var zInput = $("#z-coord")

    var xCoord = xInput.val();
    var yCoord = yInput.val();
    var zCoord = zInput.val();

    if(!xCoord || xCoord != parseFloat(xCoord)) {
        xInput.addClass("is-invalid");
        isEverythingFilled = false
    } else {
        xInput.removeClass("is-invalid")
    }

    if(!yCoord || yCoord != parseFloat(yCoord)) {
        yInput.addClass("is-invalid");
        isEverythingFilled = false
    } else {
        yInput.removeClass("is-invalid")
    }

    if(!zCoord || zCoord != parseFloat(zCoord)) {
        zInput.addClass("is-invalid");
        isEverzthingFilled = false
    } else {
        zInput.removeClass("is-invalid")
    }

    if(isEverythingFilled) {
        $("#create-from-coords-modal").modal("hide")

        if(blipIdToDuplicate) {
            $.post(`https://${resName}/duplicate-blip-from-coords`, JSON.stringify({blipIdToDuplicate: blipIdToDuplicate, x: xCoord, y: yCoord, z: zCoord}), function(data){
                blipIdToDuplicate = null;

                $.post(`https://${resName}/focus`)
                
                openBlipsMenu()
            });
        } else {
            $.post(`https://${resName}/create-blip-from-coords`, JSON.stringify({isGlobal: isCreatingGlobalBlip, x: xCoord, y: yCoord, z: zCoord}), function(data){
                $.post(`https://${resName}/focus`)
                
                openBlipsMenu()
            });
        }
    }
})

$("#create-blip-place-blip-btn").click(function(){
    $("#create-blip-mode").modal("hide")

    showNotification("Where your blip should be?")
    
    if(blipIdToDuplicate) {
        $.post(`https://${resName}/duplicate-blip`, JSON.stringify({blipIdToDuplicate: blipIdToDuplicate}), function(data){
            hideNotification()
            
            blipIdToDuplicate = null;

            $.post(`https://${resName}/focus`)
            
            openBlipsMenu()
        });
    } else {
        $.post(`https://${resName}/create-blip`, JSON.stringify({isGlobal: isCreatingGlobalBlip}), function(data){
            hideNotification()
            $.post(`https://${resName}/focus`)
    
            openBlipsMenu()
        })
    }
})

$("#from-coords-close-btn").click(function(){
    $("#create-blip-mode").modal("show");
})

$("#blip-mode-close-btn").click(function(){
    openBlipsMenu()
})

$("#edit-blip-share-btn").click(function(){
    var editBlipDiv = $("#edit-blip");
    var blipId = parseInt(editBlipDiv.val());

    $.post(`https://${resName}/save-blip`, JSON.stringify({blipId: blipId}), function(isSuccessful){
        if(isSuccessful){
            var playerIdInput = $("#player-id")
            
            playerIdInput.val("");
            playerIdInput.removeClass("is-invalid");

            $("#share-choose-id").modal("show");
        }
    })
})

$("#share-btn").click(function(){
    var playerIdInput = $("#player-id")

    var playerId = playerIdInput.val();

    if(!playerId || playerId != parseInt(playerId)) {
        playerIdInput.addClass("is-invalid");
    } else {
        var blipId = $("#edit-blip").val()

        $.post(`https://${resName}/share-blip`, JSON.stringify({playerId: parseInt(playerId), blipId: blipId}));

        $("#share-choose-id").modal("hide");
    }
});

$("#refresh-blips-btn").click(function(){
    $("#map-utilities").hide();
    openBlipsMenu()
})

function mapActive(){
    showNotification("Press SPACEBAR to open the menu", 3000)
}

function hideNotification(){
    $("#notification").toast("hide");
}

function openBlipsMenu(){
    if(isCreatingGlobalBlip) {
        isCreatingGlobalBlip = false
    }

    $.post(`https://${resName}/get-saved-blips`, {}, function(blips){
        blips = JSON.parse(blips)

        addBlips(blips, isAdmin)

        $("#map-utilities").fadeIn();
    })
}

function activateAdmin(){
    isAdmin = true

    $("#create-global-blip-btn").unbind().click(function(){
        isCreatingGlobalBlip = true;
        
        $("#map-utilities").hide();
        $("#create-blip-mode").modal("show");
    });
}

// Click if the player is not admin
$("#create-global-blip-btn").click(function() {
    $("#map-utilities").hide();
    $.post(`https://${resName}/askForNotAllowedMenu`, {});
})

window.addEventListener('message', (event) => {
	let data = event.data
    let action = data.action;

	if(action == 'mapActive') {
		mapActive();
	} else if(action == 'mapClosed') {
        hideNotification();
    } else if(action == 'openBlipsMenu') {
        openBlipsMenu();
    } else if(action == "activateAdmin") {
        activateAdmin();
    } else if (action == "setGameBuild") {
        gameBuild = data.gameBuild;
	} else if (action == "loadSprites") {
        spritesIDs = data.spritesIDs;
        fillSprites()
    }
})

function setBlipType(type) {
    switch(type) {
        case 'coords': {
            $("#edit-blip-scale-container").show();
            $("#edit-blip-tick-container").show();
            $("#edit-blip-outline-container").show();
            $("#edit-blip-sprite-container").show();
            $("#edit-blip-height-width-container").hide();

            let blipScaleDiv = $("#edit-blip-scale");

            blipScaleDiv.attr("min", 0.5);
            blipScaleDiv.attr("max", 2.0);
            blipScaleDiv.attr("step", 0.01);
            break;
        }

        case 'area': {
            $("#edit-blip-scale-container").hide();
            $("#edit-blip-tick-container").hide();
            $("#edit-blip-outline-container").hide();
            $("#edit-blip-sprite-container").hide();
            $("#edit-blip-height-width-container").show();

            break;
        }

        case 'radius': {
            $("#edit-blip-scale-container").show();
            $("#edit-blip-tick-container").hide();
            $("#edit-blip-outline-container").hide();
            $("#edit-blip-sprite-container").hide();
            $("#edit-blip-height-width-container").hide();

            let blipScaleDiv = $("#edit-blip-scale");

            blipScaleDiv.attr("min", 1.0);
            blipScaleDiv.attr("max", 10000.0);
            blipScaleDiv.attr("step", 1.0);
            break;
        }
    }
}

$("#edit-blip-type").change(function() {
    let blipType = $(this).val()
    let blipId = $("#edit-blip").val()

    setBlipType(blipType)

    $.post(`https://${resName}/edit-blip-type`, JSON.stringify({blipId: blipId, blipType: blipType}))
})

$("#edit-blip-width").change(function() {
    let blipWidth = $(this).val()
    let blipId = $("#edit-blip").val()

    $.post(`https://${resName}/edit-blip-width`, JSON.stringify({blipId: blipId, blipWidth: blipWidth}))
})

$("#edit-blip-height").change(function() {
    let blipHeight = $(this).val()
    let blipId = $("#edit-blip").val()
    
    $.post(`https://${resName}/edit-blip-height`, JSON.stringify({blipId: blipId, blipHeight: blipHeight}))
})

async function getCurrentCoords() {
	return new Promise((resolve, reject) => {
		$.post(`https://${resName}/getCurrentCoords`, {}, function(coords) {
			resolve(coords);
		})
	});
}

$("#current-coords-btn").click(async function() {
    let coords = await getCurrentCoords();

    $("#x-coord").val(coords.x);
    $("#y-coord").val(coords.y);
    $("#z-coord").val(coords.z);
})