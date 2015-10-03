"use strict";
var time = 600;

function OnPickTwo(){
    time = 150;
}

function OnPickFive(){
    time = 300;
}

function OnPickSeven(){
    time = 450;
}

function OnPickTen(){
    time = 600;
}

function OnPick() {
    GameEvents.SendCustomGameEventToServer( "time_picked", { "time" : time });
	GameEvents.SendEventClientSide("hero_picked", {value : false})
    GameEvents.SendEventClientSide("time_picked", {value : time})
    $.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(bRepick){
    if (!bRepick.value) {
        $.GetContextPanel().DeleteAsync(0);
    }    
}

(function () {
    GameEvents.Subscribe("hero_picked", OnHeroPicked);
})();