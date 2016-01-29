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
    if (!$("#TimeScreenPanel").BHasClass("Minimized")){
        $("#TimeScreenPanel").ToggleClass("Minimized");
    }
}

function OnNewPick(data){
    if (data.value == "time"){
        $("#TimeScreenPanel").ToggleClass("Minimized");
    }
}


function OnSync(){
    time = 1;
}

function HideChat(){
    var chat = $("#Chat");
    if (chat.BHasClass("ChatExpanded")){
        $("#Chat").style.visibility = "collapse;";
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
    GameEvents.Subscribe("new_pick", OnNewPick);

    //disable chat if single player
    var allplayersids = Game.GetAllPlayerIDs();
    if (allplayersids.length == 1){
        $("#Chat").style.visibility = "collapse;";
    }
})();