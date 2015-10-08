"use strict";
var time = 600;
var hero = null;
function OnPick(time) {
    GameEvents.SendCustomGameEventToServer( "time_picked", { "time" : time });
	GameEvents.SendEventClientSide("hero_picked", {repick : false})
    GameEvents.SendEventClientSide("time_picked", {value : time})
    $.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(data){
    if (data.hero == null){
        if (!data.repick) {
            $.GetContextPanel().DeleteAsync(0);
        }
    }
}

function OnBack(){
    $.GetContextPanel().DeleteAsync(0);
}

(function () {
    GameEvents.Subscribe("hero_picked", OnHeroPicked);
})();