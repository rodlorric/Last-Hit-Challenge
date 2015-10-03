"use strict";
var time = 600;

function OnPickTwo(){
    $.Msg("two!");
    time = 150;
}

function OnPickFive(){
    $.Msg("five!");
    time = 300;
}

function OnPickSeven(){
    $.Msg("seven!");
    time = 450;
}

function OnPickTen(){
   $.Msg("ten!");
    time = 600;
}

function OnPick() {
    $.Msg(time);
    GameEvents.SendCustomGameEventToServer( "time_picked", { "time" : time });
	GameEvents.SendEventClientSide("hero_picked", {value : false})
    $.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(bRepick){
    $.Msg("timeScreen bRepick = " + bRepick.value)
    if (!bRepick.value) {
        $.GetContextPanel().DeleteAsync(0);
    }
    
}

(function () {
    GameEvents.Subscribe("hero_picked", OnHeroPicked);
})();