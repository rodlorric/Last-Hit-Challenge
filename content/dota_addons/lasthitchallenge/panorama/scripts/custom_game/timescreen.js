"use strict";
var time = -2;
var heroId = null;
var leveling = null;

//function OnPick(time) {
//    GameEvents.SendCustomGameEventToServer( "time_picked", { "time" : time });
//	//GameEvents.SendEventClientSide("hero_picked", {repick : false})
//    //GameEvents.SendEventClientSide("time_picked", {value : time})
//    //$.GetContextPanel().DeleteAsync(0);
//}

function OnPick(time){
    GameEvents.SendCustomGameEventToServer( "new_pick", { "playerId" : Game.GetLocalPlayerID(), "time" : time});
}

function OnTimePicked(data){
    $.Msg("Timescreen.js OnTimePicked");
    $.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(data){
    $.Msg("HeroPicked timescreen.js " + data);
    heroId = data.heroId;
    leveling = data.leveling;
}

function OnStart(data){
    $.Msg("OnStart timescreen.js");
    $.GetContextPanel().DeleteAsync(0);
}

function OnSync(){
    $.Msg("OnRepick timescreen.js");
    time = 1;
}

//function OnStart(data){
//    $.Msg("OnStart!");
//    var output = '';
//      for (var property in data) {
//        output += property + ': ' + data[property]+'; ';
//      }
//      $.Msg(output);
//    $.Msg("OnStart: " + data.time);
//    GameEvents.SendEventClientSide("start_game", {heroId : hero["hero"], leveling : $("#disable_leveling").checked, time : data.time})
//    $.GetContextPanel().DeleteAsync(0);
//}

function OnBack(){
    $.Msg("Time = " + time);
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