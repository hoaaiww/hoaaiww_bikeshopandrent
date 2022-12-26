function closeMenu() {
    $(".mainbox").fadeOut('slow');
    $('#containments_rent').fadeOut();
    $('#containments_shop').fadeOut();
    $.post('https://hoaaiww_bikerental/closeUI', JSON.stringify({}));
}

function changeNum(itemID, type) {
    var getNum = parseInt($('#'+itemID).val());

    if (getNum > 1 && type == 'sub') { getNum = getNum - 1 }
    else if (getNum > 0 && type == 'add') { getNum = getNum + 1 };

    $('#'+itemID).val(getNum);
}

$(document).ready(function() {
    $(document).click(function(event) {
        if ($(event.target).attr('class') == 'checkmark') {
            $(event.target).siblings('input').prop('checked', true);
        }
    });

    $(document).keyup(function(e) {
        if (e.key === "Escape") { closeMenu(); };
    });
});

window.addEventListener('message', function(event) {
    var data = event.data;

    if (data.type == 'openRentMenu') {
        $('#containments_rent').css('display', 'flex');
        $(".mainbox").fadeIn('slow');
    } else if (data.type == 'openShopMenu') {
        $('#containments_shop').css('display', 'flex');
        $(".mainbox").fadeIn('slow');
    } else if (data.type == 'closeUI') {
        closeMenu() 
    } else if (data.type == 'setList') {
        var rentPrice = data.currency + data.rentPrice;
        var buyPrice  = data.currency + data.buyPrice;

        if (data.CP == 'after') {
            rentPrice = data.rentPrice + data.currency;
            buyPrice  = data.buyPrice  + data.currency;
        }

        colorBlock_rent = 
        `
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_rent_color" value="black" checked="checked"><span class="checkmark"></span></div>
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_rent_color" value="white"><span class="checkmark"></span></div>
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_rent_color" value="red"><span class="checkmark"></span></div>
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_rent_color" value="blue"><span class="checkmark"></span></div>
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_rent_color" value="green"><span class="checkmark"></span></div>
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_rent_color" value="yellow"><span class="checkmark"></span></div>
        `;

        colorBlock_buy = 
        `
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_buy_color" value="black" checked="checked"><span class="checkmark"></span></div>
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_buy_color" value="white"><span class="checkmark"></span></div>
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_buy_color" value="red"><span class="checkmark"></span></div>
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_buy_color" value="blue"><span class="checkmark"></span></div>
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_buy_color" value="green"><span class="checkmark"></span></div>
            <div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_buy_color" value="yellow"><span class="checkmark"></span></div>
        `;

        if (data.bikeId == 'tribike') {
            colorBlock_rent = `<div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_rent_color" value="tribike" checked="checked"><span class="checkmark"></span></div>`;
            colorBlock_buy  = `<div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_buy_color" value="tribike" checked="checked"><span class="checkmark"></span></div>`;
        } else if (data.bikeId == 'tribike2') {
            colorBlock_rent = `<div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_rent_color" value="tribike2" checked="checked"><span class="checkmark"></span></div>`;
            colorBlock_buy  = `<div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_buy_color" value="tribike2" checked="checked"><span class="checkmark"></span></div>`;
        } else if (data.bikeId == 'tribike3') {
            colorBlock_rent = `<div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_rent_color" value="tribike3" checked="checked"><span class="checkmark"></span></div>`;
            colorBlock_buy  = `<div class="col-2 colorCont"><input type="radio" name="`+data.bikeId+`_buy_color" value="tribike3" checked="checked"><span class="checkmark"></span></div>`;
        }

        $('#containments_rent').append(`
        <div class="col-4">
            <div class="card">
                <img src="imgs/`+data.bikeId+`.png" alt="" draggable="false" />
                <div class="bikePrice" data-value="`+data.rentPrice+`">`+rentPrice+`/Minute</div>
                <div class="components">
                    <div class="bikeName">`+data.bikeName+`</div>
                    <div class="colors">
                        <span>Select bike's color</span>
                        <div class="row">`+colorBlock_rent+`</div>
                    </div>
                    <div class="rentButtonCont">
                        <span>For how many minutes?</span>
                        <div class="rentMinutesCont">
                            <button class="minus" onClick="changeNum('`+data.bikeId+`', 'sub')">-</button>
                            <input id="`+data.bikeId+`" type="text" pattern="[0-9]+" min="1" max="99" maxlength="2" minlength="1" value="1" class="counterText"></input>
                            <button class="add" onClick="changeNum('`+data.bikeId+`', 'add')">+</button>
                        </div>
                        <div class="rentButton" onClick="rentBike('`+data.bikeId+`')">Rent Bike</div>
                    </div>
                </div>
            </div>
        </div>
        `);

        setInputFilter(document.getElementById(data.bikeId), function(value) {
            return /^\d*?$/.test(value);
        }, "Only digits are allowed");

        $('#containments_shop').append(`
        <div class="col-4">
            <div class="card">
                <img src="imgs/`+data.bikeId+`.png" alt="" draggable="false" />
                <div class="bikePrice" data-value="`+data.buyPrice+`">`+buyPrice+`</div>
                <div class="components">
                    <div class="bikeName">`+data.bikeName+`</div>
                    <div class="colors">
                        <span>Select bike's color</span>
                        <div class="row">`+colorBlock_buy+`</div>
                    </div>
                    <div class="buyButtonCont">
                        <div class="buyButton" onClick="buyBike('`+data.bikeId+`')">Purchase Bike</div>
                    </div>
                </div>
            </div>
        </div>
        `);
    }
});

function rentBike(bike) {
    var rentTime = $('#'+bike).val();
    var color    = '';

    if ( bike != 'tribike' && bike != 'tribike2' && bike != 'tribike3' ) {
        color = $("input[name="+bike+"_rent_color]:checked").val();
    }

    $.post('https://hoaaiww_bikerental/ManageBike', JSON.stringify({ bike: bike, color: color, rentTime: rentTime, renting: true }));
    $('#'+bike).val(1);
}

function buyBike(bike) {
    var color = '';

    if ( bike != 'tribike' && bike != 'tribike2' && bike != 'tribike3' ) {
        color = $("input[name="+bike+"_buy_color]:checked").val();
    }

    $.post('https://hoaaiww_bikerental/ManageBike', JSON.stringify({ bike: bike, color: color, renting: false }));
}

function setInputFilter(textbox, inputFilter, errMsg) {
    [ "input", "keydown", "keyup", "mousedown", "mouseup", "select", "contextmenu", "drop", "focusout" ].forEach(function(event) {
        textbox.addEventListener(event, function(e) {
            if (inputFilter(this.value)) {
                if ([ "keydown", "mousedown", "focusout" ].indexOf(e.type) >= 0) {
                    this.classList.remove("input-error");
                    this.setCustomValidity("");
                }
    
                this.oldValue = this.value;
                this.oldSelectionStart = this.selectionStart;
                this.oldSelectionEnd = this.selectionEnd;
            } else if (this.hasOwnProperty("oldValue")) {
                this.classList.add("input-error");
                this.setCustomValidity(errMsg);
                this.reportValidity();
                this.value = this.oldValue;
                this.setSelectionRange(this.oldSelectionStart, this.oldSelectionEnd);
            } else {
                this.value = "";
            }
        });
    });
};
