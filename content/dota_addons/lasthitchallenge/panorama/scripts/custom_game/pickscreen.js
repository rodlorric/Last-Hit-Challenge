"use strict";
function OnPickSatyr(){
    $.Msg("Satyr!");
    GameEvents.SendCustomGameEventToServer( "hero_picked", { "hero" : "npc_dota_hero_jakiro" });
}

function OnPickNevermore(){
    $.Msg("Nevermore!");
    GameEvents.SendCustomGameEventToServer( "hero_picked", { "hero" : "npc_dota_hero_nevermore" });
}

function OnPick() {
    GameEvents.SendEventClientSide("hero_picked", {})
    $.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(){
    $.GetContextPanel().DeleteAsync(0);
}

(function () {
    GameEvents.Subscribe("hero_picked", OnHeroPicked);
})();