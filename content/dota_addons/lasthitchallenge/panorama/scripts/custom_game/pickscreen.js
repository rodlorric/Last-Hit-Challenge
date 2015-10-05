"use strict";
var hero = { "hero" : "npc_dota_hero_nevermore" }

function OnPickSatyr(){
    hero = { "hero" : "npc_dota_hero_jakiro" }
}

function OnPickNevermore(){
    hero = { "hero" : "npc_dota_hero_nevermore" }
}

function OnPick() {
	var timescreen = $.CreatePanel( "Panel", $.GetContextPanel(), "TimeScreen" );
	timescreen.BLoadLayout( "file://{resources}/layout/custom_game/timescreen.xml", false, false );
    var toggleButton = $("#disable_leveling");
    GameEvents.SendCustomGameEventToServer( "disable_leveling", { "disable_leveling" : toggleButton.checked });
    //GameEvents.SendEventClientSide("hero_picked", {})
    //$.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(bRepick){
	if (!bRepick.value){
		GameEvents.SendCustomGameEventToServer( "hero_picked", hero);
	    $.GetContextPanel().DeleteAsync(0);
    }
}

var label = null;
function LevelingShowTooltip(){
    $.Msg("mouse over");
    var togglebutton = $("#disable_leveling");
    togglebutton.text = $.Localize( "disable_leveling_tooltip" );
}

function LevelingHideTooltip(){
    $.Msg("mouse out");
    var togglebutton = $("#disable_leveling");
    togglebutton.text = $.Localize( "#disable_leveling" );
}

(function () {
    GameEvents.Subscribe("hero_picked", OnHeroPicked);
})();