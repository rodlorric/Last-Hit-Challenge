"use strict";
var hero = { "hero" : "npc_dota_hero_nevermore" }

function OnPickSatyr(){
    $.Msg("Satyr!");
    hero = { "hero" : "npc_dota_hero_jakiro" }
}

function OnPickNevermore(){
    hero = { "hero" : "npc_dota_hero_nevermore" }
}

function OnPick() {
	var timescreen = $.CreatePanel( "Panel", $.GetContextPanel(), "TimeScreen" );
	timescreen.BLoadLayout( "file://{resources}/layout/custom_game/timescreen.xml", false, false );
    
    //GameEvents.SendEventClientSide("hero_picked", {})
    //$.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(bRepick){
	$.Msg("pickScreen bRepick " + bRepick )
	if (!bRepick.value){
		GameEvents.SendCustomGameEventToServer( "hero_picked", hero);
	    $.GetContextPanel().DeleteAsync(0);
    }
}

(function () {
    GameEvents.Subscribe("hero_picked", OnHeroPicked);
})();