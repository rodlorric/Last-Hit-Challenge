"use strict";

function OnLastHitOrDeny( table_name, key, data ){
	var scorepanel = $.GetContextPanel();
	if (key == "stats_total_lh") {
		$("#Lasthits").text = data["value"];	
		scorepanel.SetHasClass( "lh_anim", true );
	} else if (key == "stats_total_dn") {
		$("#Denies").text = data["value"];
		scorepanel.SetHasClass( "dn_anim", true );	
	}
	$.Schedule( 1, OnResetAnimation );
}

function OnClockTime(data) {
	var clockPanel = $.GetContextPanel();
	$("#clock").text = data["min"] + ":" + data["sec"];
}

function OnResetAnimation(data) {
	var scorepanel = $.GetContextPanel();
	scorepanel.SetHasClass( "lh_anim", false );
	scorepanel.SetHasClass( "dn_anim", false );
}

function OnHeroPicked(){
	$.Msg("hud OnHeroPicked");
	$("#score_panel").style.visibility = "visible";
	$("#clock_panel").style.visibility = "visible";
}


(function () {
	//GameEvents.Subscribe("last_hit", OnLastHitOrDeny);
	GameEvents.Subscribe("hero_picked", OnHeroPicked);
	GameEvents.Subscribe("clock", OnClockTime);
	CustomNetTables.SubscribeNetTableListener( "stats_totals", OnLastHitOrDeny );
})();