let isOpenByAdmin = false;

let priceMultiplierWithoutTheJob;

let IsUpgradesOnlyForWhitelistJobPoints;
let detailCardMenuPosition; // 0 right, 1 left
let cashPosition; // 0 right, 1 left

let currentJobName = null;
let currentCash = null;

let canDetailCardToggle = true;
let userDetailCardToggle = true;

let menuLastPos = [];
let menuLastPosIndex = '';

let cardFadeOutTimeOut = null;

let menuLoading = false;

let currentVehicleCard = {
    vehicleName: '',
    power: 0.0,
    acceleration: 0.0,
    maxSpeed: 0.0,
    breaks: 0.0
};

let grid = null;
let isCustom = null;
let colorIndex = 0;
let colorPriceMult = null;

let colorData = [
    [[13, 17, 22], [28, 29, 33], [50, 56, 61], [69, 75, 79], [153, 157, 160], [194, 196, 198], [151, 154, 151], [99, 115, 128], [99, 98, 92], [60, 63, 71], [68, 78, 84], [29, 33, 41], [19, 24, 31], [38, 40, 42], [81, 85, 84], [21, 25, 33]],
    [[30, 36, 41], [51, 58, 60], [140, 144, 149], [57, 67, 77], [80, 98, 114], [30, 35, 47], [54, 58, 63], [160, 161, 153], [211, 211, 211], [183, 191, 202], [119, 135, 148], [192, 14, 26], [218, 25, 24], [182, 17, 27], [165, 30, 35], [123, 26, 34]],
    [[142, 27, 31], [111, 24, 24], [73, 17, 29], [182, 15, 37], [212, 74, 23], [194, 148, 79], [247, 134, 22], [207, 31, 33], [115, 32, 33], [242, 125, 32], [255, 201, 31], [156, 16, 22], [222, 15, 24], [143, 30, 23], [169, 71, 68], [177, 108, 81]],
    [[55, 28, 37], [19, 36, 40], [18, 46, 43], [18, 56, 60], [49, 66, 63], [21, 92, 45], [27, 103, 112], [102, 184, 31], [34, 56, 62], [29, 90, 63], [45, 66, 63], [69, 89, 75], [101, 134, 127], [34, 46, 70], [35, 49, 85], [48, 76, 126]],
    [[71, 87, 143], [99, 123, 167], [57, 71, 98], [214, 231, 241], [118, 175, 190], [52, 94, 114], [11, 156, 241], [47, 45, 82], [40, 44, 77], [35, 84, 161], [110, 163, 198], [17, 37, 82], [27, 32, 62], [39, 81, 144], [96, 133, 146], [36, 70, 168]],
    [[66, 113, 225], [59, 57, 224], [31, 40, 82], [37, 58, 167], [28, 53, 81], [76, 95, 129], [88, 104, 142], [116, 181, 216], [255, 207, 32], [251, 226, 18], [145, 101, 50], [224, 225, 61], [152, 210, 35], [155, 140, 120], [80, 50, 24], [71, 63, 43]],
    [[34, 27, 25], [101, 63, 35], [119, 92, 62], [172, 153, 117], [108, 107, 75], [64, 46, 43], [164, 150, 95], [70, 35, 26], [117, 43, 25], [191, 174, 123], [223, 213, 178], [247, 237, 213], [58, 42, 27], [120, 95, 51], [181, 160, 121], [255, 255, 246]],
    [[234, 234, 234], [176, 171, 148], [69, 56, 49], [42, 40, 43], [114, 108, 87], [106, 116, 124], [53, 65, 88], [155, 160, 168], [88, 112, 161], [234, 230, 222], [223, 221, 208], [242, 173, 46], [249, 164, 88], [131, 197, 102], [241, 204, 64], [76, 195, 218]],
    [[78, 100, 67], [188, 172, 143], [248, 182, 88], [252, 249, 241], [255, 255, 251], [129, 132, 76], [255, 255, 255], [242, 31, 153], [253, 214, 205], [223, 88, 145], [246, 174, 32], [176, 238, 110], [8, 233, 250], [10, 12, 23], [12, 13, 24], [14, 13, 20]],
    [[159, 158, 138], [98, 18, 118], [11, 20, 33], [17, 20, 26], [107, 31, 123], [30, 29, 34], [188, 25, 23], [45, 54, 42], [105, 103, 72], [122, 108, 85], [195, 180, 146], [90, 99, 82], [129, 130, 127], [175, 214, 228], [122, 100, 64], [127, 106, 72]]
];

$(window).ready(function() {
    resetUI();
    listener();

    $.post(`https://${GetParentResourceName()}/uiReady`, {});
});

function listener() {
    window.addEventListener('message', (event) => {
        let tempData = event.data;

        if (tempData.type === 'open') {
            isOpenByAdmin = tempData.isOpenByAdmin;

            IsUpgradesOnlyForWhitelistJobPoints = tempData.IsUpgradesOnlyForWhitelistJobPoints;
            priceMultiplierWithoutTheJob = tempData.priceMultiplierWithoutTheJob;
            detailCardMenuPosition = tempData.detailCardMenuPosition;
            cashPosition = tempData.cashPosition;
            
            if (cashPosition == 0) {
                $('#cash').removeClass('left');
            } else {
                $('#cash').addClass('left');
            }

            $('html').show();
            $('#buttonHelpers').show(500);
            
            fadeInDetailCard();
            userDetailCardToggle = false;
            cardFadeOutTimeOut = setTimeout(function() {
                fadeOutDetailCard();
            }, 5000);

            if (tempData.what === 'menu') {
                createMenu(tempData.menuId, tempData.options, tempData.menuTitle, tempData.defaultOption, tempData.whitelistJobName);
            } else if (tempData.what === 'colorPicker') {
                isCustom = tempData.isCustom;
                colorPriceMult = tempData.priceMult;
                fadeInColorPicker(tempData.title, isOpenByAdmin ? 0 : tempData.price, tempData.defaultValue, tempData.whitelistJobName);
            }
        } else if (tempData.type === 'close') {
            resetUI();
        } else if (tempData.type === 'update') {
            if (tempData.what === 'card') {
                updateDetailCardData(tempData);
            } else if (tempData.what === 'cash') {
                if (currentCash != tempData.cash) {
                    currentCash = tempData.cash;
                    $('#cash').html('$' + GetNumberWithCommas(currentCash));

                    $('.options_container_option_price').each(function(index) {
                        let tempPrice = parseInt($(this).html().replace(/[^0-9]/g, ''));
                        if (tempPrice) {
                            if (tempPrice > currentCash) {
                                $(this).addClass('cash_not');
                            } else {
                                $(this).removeClass('cash_not');
                            }
                        }
                    });

                    if ($('#colorPicker-holder').css("opacity") >= 0.1) {
                        let tempPrice = parseInt($('#colorPicker-price').html().replace(/[^0-9]/g, ''));
                        if (tempPrice > currentCash) {
                            $('#colorPicker-price').addClass('cash_not');
                        } else {
                            $('#colorPicker-price').removeClass('cash_not');
                        }
                    }
                }
            } else if (tempData.what === 'job') {
                currentJobName = tempData.jobName;
            } else if (tempData.what === 'menu') {
                createMenu(tempData.menuId, tempData.options, tempData.menuTitle, tempData.defaultOption, tempData.whitelistJobName);
            } else if (tempData.what === 'colorPicker') {
                fadeOutColorPicker();
            }
        } else if (tempData.type === 'playSound') {
            playSound(tempData.soundName, tempData.volume);
        }
    });
}

document.onkeydown = function(event) {
    if (event.which == 9) {
        return false;
    } else if (event.which == 39 || event.which == 68) { // left (prev)
        event.preventDefault();

        if (!menuLoading) {
            if ($('#colorPicker-holder').css("opacity") < 0.5) {
                menuGoto(1);
            } else {
                menuColorPickerGoto(1, 0)
            }
        }
    } else if (event.which == 37 || event.which == 65) { // right (next)
        event.preventDefault();

        if (!menuLoading) {
            if ($('#colorPicker-holder').css("opacity") < 0.5) {
                menuGoto(-1);
            } else {
                menuColorPickerGoto(-1, 0)
            }
        }
    } else if (event.which == 71) { // g
        event.preventDefault();

        userDetailCardToggle = !userDetailCardToggle;
        fadeInDetailCard();
        fadeOutDetailCard();
    } else if (event.which == 38 || event.which == 87) { // up (next)
        event.preventDefault();

        if ($('#colorPicker-holder').css("opacity") >= 0.5) {
            menuColorPickerGoto(0, -1)
        }
    } else if (event.which == 40 || event.which == 83) { // down (next)
        event.preventDefault();

        if ($('#colorPicker-holder').css("opacity") >= 0.5) {
            menuColorPickerGoto(0, 1)
        }
    } else if (event.which == 8) { // backspace
        event.preventDefault();

        $.post(`https://${GetParentResourceName()}/handle`, JSON.stringify({
            type: 'update',
            what: 'menu',
            user: 'backspace',
            menuId: menuLastPosIndex,
            menuIndex: menuLastPos[menuLastPosIndex]
        }));

        menuLastPos[menuLastPosIndex] = null;

        if ($('#colorPicker-holder').css("opacity") > 0.05) {
            fadeOutColorPicker();
        }
    } else if (event.which == 13) { // enter
        event.preventDefault();

        let tempColor = null;
        if ($('#colorPicker-holder').css("opacity") >= 0.5) {
            tempColor = colorIndex;
            if (isCustom) {
                let temp = getRGBFromString($('.colorPicker-columnSelected').css('background-color'));
                tempColor = [temp.red, temp.green, temp.blue];
            }
        }

        $.post(`https://${GetParentResourceName()}/handle`, JSON.stringify({
            type: 'update',
            what: 'menu',
            user: 'enter',
            menuId: menuLastPosIndex,
            menuIndex: menuLastPos[menuLastPosIndex],
            color: tempColor,
            isCustom: isCustom,
            priceMult: colorPriceMult,
        }));
    } else if (event.which == 27) { // esc
        event.preventDefault();
        
        $('#options_container').stop(true, true).animate({height: '0px'}, 300);

        let styles
        if (detailCardMenuPosition == 0) {
            styles = {
                'opacity': 0,
                'right': '-140px',
                'left': ''
            }
        } else {
            styles = {
                'opacity': 0,
                'left': '-140px'
            }
        }
        $('#detailCard').stop(true, true).animate(styles, 500, function() {
            resetUI();
    
            $.post(`https://${GetParentResourceName()}/handle`, JSON.stringify({
                type: "close"
            }));
        });
    }
}

function resetUI() {
    $('html').hide();
    $('#buttonHelpers').hide();

    canDetailCardToggle = true;
    userDetailCardToggle = true;

    menuLastPos = [];
    menuLastPosIndex = '';

    cardFadeOutTimeOut = null;
    clearTimeout(cardFadeOutTimeOut);
    
    menuLoading = false;

    currentCash = null;
    $('#cash').html('');

    $('#options_title').html('');
    $('#options_container').html('');
    $('#options_subTitle').html('');

    $('#detailCard').hide();

    let styles
    if (detailCardMenuPosition == 0) {
        styles = {
            'opacity': 0,
            'right': '-140px'
        }
    } else {
        styles = {
            'opacity': 0,
            'left': '-140px'
        }
    }
    $('#detailCard').css(styles);

    $('#detailCard_name').html('');

    isCustom = null;
    grid = null;
    colorIndex = 0;
    $('#colorPicker-title').html('');
    $('#colorPicker-price').html('');
    $('#colorPicker-holder').css({opacity: "0", left: '-140px'});

    $('#card_power_percent').css({width: "0%"});
    $('#card_power_number').html('0.0');
    
    $('#card_acceleration_percent').css({width: "0%"});
    $('#card_acceleration_number').html('0.0');
    
    $('#card_maxspeed_percent').css({width: "0%"});
    $('#card_maxspeed_number').html('0.0');
    
    $('#card_breaks_percent').css({width: "0%"});
    $('#card_breaks_number').html('0.0');
}

function createMenu(menuId, data, title, defaultOption, whitelistJobName) {
    menuLastPosIndex = menuId;

    menuLoading = true;
    
    $('#options_container').stop(true, true).animate({height: '0px'}, 300, function() {
        $('#options_container').html('');
    
        for (let i = 0; i < data.length; i++) {
            let price = '';

            if (data[i].price >= 0) {
                let tempPrice = Math.floor(data[i].price * priceMultiplierWithoutTheJob);
                if (whitelistJobName && currentJobName == whitelistJobName) {
                    tempPrice = data[i].price;
                }

                let tempClass = '';
                if ((!isOpenByAdmin) && tempPrice > currentCash) tempClass = 'cash_not';
                
                price = `<div class="options_container_option_price ${tempClass}">$${isOpenByAdmin ? 0 : GetNumberWithCommas(tempPrice)}</div>`;
            } else if (data[i].price == -1) {
                price = '<div class="options_container_option_price"><img src="img/check.png" style="width:20px;height:20px;"></div>';
            }
            
            $('#options_container').append(`
                <div class="options_option">
                    ${price}
                    <div class="options_option_img"><img src="${data[i].img}" onerror="this.style.display='none'"></div>
                    <div class="options_option_text">${data[i].label ? data[i].label : ''}</div>
                </div>
            `);
        }
    
        $('#options_title').html(title);
        
        defaultOption = defaultOption ? defaultOption : 0;
        menuLastPos[menuLastPosIndex] = menuLastPos[menuLastPosIndex] != null ? menuLastPos[menuLastPosIndex] : defaultOption;
        
        menuGoto(0);
        
        $('#options_container').stop(true, true).animate({height: '170px'}, 300, function() {
            menuLoading = false;
        });
    });
}

function menuGoto(valueHor) {
    let total = $('#options_container > div').length;
    if (total < 1) {
        $('#options_subTitle').html('');
        return;
    }

    $('#options_container > div').eq(menuLastPos[menuLastPosIndex]).removeClass('options_container_optionSelected');
    
    menuLastPos[menuLastPosIndex] = menuLastPos[menuLastPosIndex] + valueHor;
    if (menuLastPos[menuLastPosIndex] > (total - 1)) {
        menuLastPos[menuLastPosIndex] = 0
    }
    if (menuLastPos[menuLastPosIndex] < 0) {
        menuLastPos[menuLastPosIndex] = total - 1
    }
    
    $('#options_container > div').eq(menuLastPos[menuLastPosIndex]).addClass('options_container_optionSelected');
    $('#options_subTitle').html((menuLastPos[menuLastPosIndex] + 1) + '/' + total);

    let tempOffset = $('#options_container > div').eq(menuLastPos[menuLastPosIndex]).offset();
    if (tempOffset) {
        $('#options_container').stop(true, true).animate({
            scrollLeft: tempOffset.left - $('#options_container > div').eq(0).offset().left - 10
        }, 200);
    }

    $.post(`https://${GetParentResourceName()}/handle`, JSON.stringify({
        type: 'update',
        what: 'menu',
        user: 'hover',
        menuId: menuLastPosIndex,
        menuIndex: menuLastPos[menuLastPosIndex]
    }));
}

function menuColorPickerGoto(hor, vert) {
    $('.colorPicker-column').eq(colorIndex).removeClass('colorPicker-columnSelected');

    if (hor != 0) {
        colorIndex += hor;

        if (hor > 0 && colorIndex % grid.x == 0) {
            colorIndex -= grid.x;
        }
        if (hor < 0 && (colorIndex % grid.x == (grid.x - 1) || colorIndex % grid.x < 0)) {
            colorIndex += grid.x;
        }
    }
    if (vert != 0) {
        colorIndex += (vert * grid.x);
        
        if (colorIndex == -grid.x) {
            colorIndex = $('.colorPicker-column').length - grid.x;
        }
        if (colorIndex < 0) {
            colorIndex = $('.colorPicker-column').length + (colorIndex % grid.x);
        }
        if (colorIndex >= $('.colorPicker-column').length) {
            colorIndex = colorIndex % grid.x;
        }
    }

    $('.colorPicker-column').eq(colorIndex).addClass('colorPicker-columnSelected');

    let tempColor = null;
    if ($('#colorPicker-holder').css("opacity") >= 0.5) {
        tempColor = colorIndex;
        if (isCustom) {
            let temp = getRGBFromString($('.colorPicker-columnSelected').css( "background-color" ));
            tempColor = [temp.red, temp.green, temp.blue];
        }
    }

    $.post(`https://${GetParentResourceName()}/handle`, JSON.stringify({
        type: 'update',
        what: 'menu',
        user: 'hover',
        menuId: menuLastPosIndex,
        menuIndex: menuLastPos[menuLastPosIndex],
        color: tempColor,
        isCustom: isCustom
    }));
}

function updateDetailCardData(data) {
    currentVehicleCard.vehicleName = data.vehicleName ? data.vehicleName : currentVehicleCard.vehicleName
    currentVehicleCard.power = data.power ? data.power : currentVehicleCard.power;
    currentVehicleCard.acceleration = data.acceleration ? data.acceleration : currentVehicleCard.acceleration;
    currentVehicleCard.maxSpeed = data.maxSpeed ? data.maxSpeed : currentVehicleCard.maxSpeed;
    currentVehicleCard.breaks = data.breaks ? data.breaks : currentVehicleCard.breaks;

    $('#detailCard_name').html(currentVehicleCard.vehicleName);
}

function fadeInDetailCard() {
    if (!userDetailCardToggle || !canDetailCardToggle || !$('#detailCard').is(':hidden')) {
        return;
    }
    
    canDetailCardToggle = false;

    $('#card_power_percent').stop(true, true).animate({width: (currentVehicleCard.power * 10) + '%'}, 3000);
    $('#card_power_number').html(currentVehicleCard.power.toFixed(1));

    $('#card_acceleration_percent').stop(true, true).animate({width: (currentVehicleCard.acceleration * 10) + '%'}, 3000);
    $('#card_acceleration_number').html(currentVehicleCard.acceleration.toFixed(1));

    $('#card_maxspeed_percent').stop(true, true).animate({width: (currentVehicleCard.maxSpeed * 10) + '%'}, 3000);
    $('#card_maxspeed_number').html(currentVehicleCard.maxSpeed.toFixed(1));

    $('#card_breaks_percent').stop(true, true).animate({width: (currentVehicleCard.breaks * 10) + '%'}, 3000, function(){
        canDetailCardToggle = true;
    });
    $('#card_breaks_number').html(currentVehicleCard.breaks.toFixed(1));


    let styles
    $('#detailCard').removeAttr('style');
    if (detailCardMenuPosition == 0) {
        styles = {
            'opacity': 1,
            'right': '40px'
        }
    } else {
        $('#detailCard').css({left: "-140px"});
        styles = {
            'opacity': 1,
            'left': '40px'
        }
    }
    $('#detailCard').stop(true, true).animate(styles, 1000);

    $('#detailCard').show();
}

function fadeOutDetailCard() {
    if (userDetailCardToggle || !canDetailCardToggle || !$('#detailCard').is(':visible')) {
        return;
    }

    canDetailCardToggle = false;

    let styles
    if (detailCardMenuPosition == 0) {
        styles = {
            'opacity': 0,
            'right': '-140px'
        }
    } else {
        styles = {
            'opacity': 0,
            'left': '-140px'
        }
    }
    $('#detailCard').stop(true, true).animate(styles, 1000, function() {
        $('#detailCard').hide();

        $('#card_power_percent').css({width: "0%"});
        $('#card_power_number').html('0.0');
        
        $('#card_acceleration_percent').css({width: "0%"});
        $('#card_acceleration_number').html('0.0');
        
        $('#card_maxspeed_percent').css({width: "0%"});
        $('#card_maxspeed_number').html('0.0');
        
        $('#card_breaks_percent').css({width: "0%"});
        $('#card_breaks_number').html('0.0');

        setTimeout(function(){
            canDetailCardToggle = true;
        }, 1000);
    })
}

function fadeInColorPicker(title, price, defaultValue, whitelistJobName) {
    initColorPicker(title, isOpenByAdmin ? 0 : price, defaultValue, whitelistJobName);
    $('#colorPicker-holder').stop(true, true).animate({
        opacity: 1,
        left: '40px'
    }, 1000)
}

function fadeOutColorPicker() {
    $('#colorPicker-holder').stop(true, true).animate({
        opacity: 0,
        left: '-140px'
    }, 1000)
}

function GetNumberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

function initColorPicker(title, price, defaultValue, whitelistJobName) {
    let srting = '';
    let scale = 15

    let tempPrice = Math.floor(price * priceMultiplierWithoutTheJob);
    if (whitelistJobName && currentJobName == whitelistJobName) {
        tempPrice = price;
    }

    if (isOpenByAdmin)
        tempPrice = 0

    $('#colorPicker-title').html(title);
    $('#colorPicker-price').html('$' + GetNumberWithCommas(tempPrice));
    if (tempPrice > currentCash) {
        $('#colorPicker-price').addClass('cash_not');
    }else{
        $('#colorPicker-price').removeClass('cash_not');
    }

    $('#colorPicker-container').html('');

    let colorDiffs = [];
    
    if (isCustom != null && !isCustom) {
        grid = {x: colorData[0].length, y: colorData.length};

        let tempCount = 0;
        for (let y = 0; y < colorData.length; y++) {
            srting += `<div class='colorPicker-row'>`;
            for (let x = 0; x < colorData[y].length; x++) {
                let tempClass = '';
                if (tempCount == defaultValue) {
                    tempClass = 'colorPicker-columnDefault colorPicker-columnSelected';
                    colorIndex = tempCount;
                }

                srting += `<div class='colorPicker-column ${tempClass}' style='background-color:rgb(${colorData[y][x][0]},${colorData[y][x][1]},${colorData[y][x][2]});'></div>`;
                tempCount += 1;
            }
            srting += `</div>`;
        }
    } else {
        grid = {x: 22, y: 22};

        let tempCount = 0;
        
        srting += `<div class='colorPicker-row'>`;
        for (let x = 0; x < grid.x; x++) {
            let h = 0.0;
            let s = 0.0;
            let l = 100.0 - (x * 100.0 / (grid.x - 1));

            colorDiffs[tempCount] = getDeltaEfrom2RGB(defaultValue, hslToRgb(h / 360.0, s / 100.0, l / 100.0));

            srting += `<div class='colorPicker-column' id='colorPicker-column-${tempCount}' style='background-color:hsl(${h}deg,${s}%,${l}%);'></div>`;
            tempCount += 1;
        }
        srting += `</div>`;

        for (let y = 3; y < grid.y; y++) {
            srting += `<div class='colorPicker-row'>`;
            for (let x = 0.0; x < grid.x; x++) {
                let h = 360.0 / grid.x * x;
                let s = 200.0 / grid.y * y;
                let l = 100.0 - (100.0 / grid.y * y);

                colorDiffs[tempCount] = getDeltaEfrom2RGB(defaultValue, hslToRgb(h / 360.0, s / 100.0, l / 100.0));
                                
                srting += `<div class='colorPicker-column' id='colorPicker-column-${tempCount}' style='background-color:hsl(${h}deg,${s}%,${l}%);'></div>`;
                tempCount += 1;
            }
            srting += `</div>`;
        }
    }

    $('#colorPicker-container').html(srting);

    if (colorDiffs.length > 0) {
        colorIndex = colorDiffs.indexOf(Math.min.apply(Math, colorDiffs));
        $('#colorPicker-column-' + colorIndex).addClass('colorPicker-columnDefault');
        $('#colorPicker-column-' + colorIndex).addClass('colorPicker-columnSelected');
    }
    
    $('#colorPicker-holder').width((grid.x * scale) + (grid.x * 6) - 2);
    $('.colorPicker-column').height(scale - 2);

    if ($('.colorPicker-columnSelected').length < 1) {
        colorIndex = 0;
        $('.colorPicker-column').eq(colorIndex).addClass('colorPicker-columnDefault');
        $('.colorPicker-column').eq(colorIndex).addClass('colorPicker-columnSelected');
    }
}

function getDeltaEfrom2RGB(rgb1, rgb2) {
    let xyz1 = RGBtoXYZ(rgb1[0], rgb1[1], rgb1[2]);
    let xyz2 = RGBtoXYZ(rgb2[0], rgb2[1], rgb2[2]);

    let lab1 = XYZtoLAB(xyz1[0], xyz1[1], xyz1[2]);
    let lab2 = XYZtoLAB(xyz2[0], xyz2[1], xyz2[2]);

    return (Math.sqrt(((lab2[0] - lab1[0]) * (lab2[0] - lab1[0])) + ((lab2[1] - lab1[1]) * (lab2[1] - lab1[1])) + ((lab2[2] - lab1[2]) * (lab2[2] - lab1[2]))));
}

function hslToRgb(h, s, l) {
    var r, g, b;
  
    if (s == 0) {
      r = g = b = l; // achromatic
    } else {
      function hue2rgb(p, q, t) {
        if (t < 0) t += 1;
        if (t > 1) t -= 1;
        if (t < 1/6) return p + (q - p) * 6 * t;
        if (t < 1/2) return q;
        if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
        return p;
      }
  
      var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
      var p = 2 * l - q;
  
      r = hue2rgb(p, q, h + 1/3);
      g = hue2rgb(p, q, h);
      b = hue2rgb(p, q, h - 1/3);
    }
  
    return [ Math.abs(r * 255), Math.abs(g * 255), Math.abs(b * 255) ];
}

function RGBtoXYZ(R, G, B) {
    var_R = parseFloat( R / 255 )        //R from 0 to 255
    var_G = parseFloat( G / 255 )        //G from 0 to 255
    var_B = parseFloat( B / 255 )        //B from 0 to 255

    if ( var_R > 0.04045 ) var_R = Math.pow(( ( var_R + 0.055 ) / 1.055 ), 2.4)
    else                   var_R = var_R / 12.92
    if ( var_G > 0.04045 ) var_G = Math.pow(( ( var_G + 0.055 ) / 1.055 ), 2.4)
    else                   var_G = var_G / 12.92
    if ( var_B > 0.04045 ) var_B = Math.pow(( ( var_B + 0.055 ) / 1.055 ), 2.4)
    else                   var_B = var_B / 12.92

    var_R = var_R * 100
    var_G = var_G * 100
    var_B = var_B * 100

    //Observer. = 2°, Illuminant = D65
    X = var_R * 0.4124 + var_G * 0.3576 + var_B * 0.1805
    Y = var_R * 0.2126 + var_G * 0.7152 + var_B * 0.0722
    Z = var_R * 0.0193 + var_G * 0.1192 + var_B * 0.9505
    return [X, Y, Z]
}

function XYZtoLAB(x, y, z) {
    var ref_X =  95.047;
    var ref_Y = 100.000;
    var ref_Z = 108.883;

    var_X = x / ref_X          //ref_X =  95.047   Observer= 2°, Illuminant= D65
    var_Y = y / ref_Y          //ref_Y = 100.000
    var_Z = z / ref_Z          //ref_Z = 108.883

    if ( var_X > 0.008856 ) var_X = Math.pow(var_X, ( 1/3 ))
    else                    var_X = ( 7.787 * var_X ) + ( 16 / 116 )
    if ( var_Y > 0.008856 ) var_Y = Math.pow(var_Y, ( 1/3 ))
    else                    var_Y = ( 7.787 * var_Y ) + ( 16 / 116 )
    if ( var_Z > 0.008856 ) var_Z = Math.pow(var_Z, ( 1/3 ))
    else                    var_Z = ( 7.787 * var_Z ) + ( 16 / 116 )

    CIE_L = ( 116 * var_Y ) - 16
    CIE_a = 500 * ( var_X - var_Y )
    CIE_b = 200 * ( var_Y - var_Z )

    return [CIE_L, CIE_a, CIE_b]
}

function getRGBFromString(str){
    let match = str.match(/rgba?\((\d{1,3}), ?(\d{1,3}), ?(\d{1,3})\)?(?:, ?(\d(?:\.\d?))\))?/);
    return match ? {
        red: match[1],
        green: match[2],
        blue: match[3]
    } : {};
}

function playSound(soundName, volume) {
    let audioElement = document.createElement('audio');
    audioElement.setAttribute('src', 'sounds/' + soundName + '.ogg');
    audioElement.volume = volume;

    audioElement.addEventListener('ended', function() {
        this.remove();
    }, false);

    audioElement.play();
}
