"use strict";
var time = -2;
var heroId = null;
var leveling = null;

function OnPick(time){
    GameEvents.SendCustomGameEventToServer( "new_pick", { "playerId" : Game.GetLocalPlayerID(), "time" : time});
}

function OnTimePicked(data){
    $.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(data){
    heroId = data.heroId;
    leveling = data.leveling;
}

function OnStart(data){
    $.GetContextPanel().DeleteAsync(0);
}

function OnSync(){
    time = 1;
}

function HideChat(){
    var chat = $("#Chat");
    if (chat.BHasClass("ChatExpanded")){
        $("#Chat").ToggleClass("ChatExpanded");
    }
}


function OnBack(){
    if (time == 1){
        GameEvents.SendCustomGameEventToServer("restart", {});
    }
    $.GetContextPanel().DeleteAsync(0);
}

(function () {
    GameEvents.Subscribe("time_picked_server", OnTimePicked);
    GameEvents.Subscribe("hero_picked", OnHeroPicked);
    GameEvents.Subscribe("start", OnStart);
    GameEvents.Subscribe("sync", OnSync);
})();