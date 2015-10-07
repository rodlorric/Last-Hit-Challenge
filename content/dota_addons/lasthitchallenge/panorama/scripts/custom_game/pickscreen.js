"use strict";

var hero = { "hero" : "npc_dota_hero_nevermore" }

function OnPick(id) {
    hero = { "hero" : id }
	var timescreen = $.CreatePanel( "Panel", $.GetContextPanel(), "TimeScreen" );
	timescreen.BLoadLayout( "file://{resources}/layout/custom_game/timescreen.xml", false, false );
    var toggleButton = $("#disable_leveling");
    $.Msg(toggleButton.checked?"nolvl":"lvl")
    GameEvents.SendEventClientSide("hero_picked", {hero : id, leveling : toggleButton.checked?"nolvl":"lvl"})
    GameEvents.SendCustomGameEventToServer( "disable_leveling", { "disable_leveling" : toggleButton.checked });
    //GameEvents.SendEventClientSide("hero_picked", {})
    //$.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(data){
	if (data.hero == null){
        if (!data.repick){
            $.GetContextPanel().DeleteAsync(0);
    	   GameEvents.SendCustomGameEventToServer( "hero_picked", hero);
        }
    }
}

var label = null;
function LevelingShowTooltip(){
    var togglebutton = $("#disable_leveling");
    togglebutton.text = $.Localize( "disable_leveling_tooltip" );
}

function LevelingHideTooltip(){
    var togglebutton = $("#disable_leveling");
    togglebutton.text = $.Localize( "#disable_leveling" );
}

(function () {
    LevelingHideTooltip();
    GameEvents.Subscribe("hero_picked", OnHeroPicked);
})();