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
	var clickPanel = $.GetContextPanel();
	$("#clock").text = data["min"] + ":" + data["sec"];
}

function OnResetAnimation(data) {
	var scorepanel = $.GetContextPanel();
	scorepanel.SetHasClass( "lh_anim", false );
	scorepanel.SetHasClass( "dn_anim", false );
}


(function () {
	//GameEvents.Subscribe("last_hit", OnLastHitOrDeny);
	GameEvents.Subscribe("clock", OnClockTime);
	CustomNetTables.SubscribeNetTableListener( "stats_totals", OnLastHitOrDeny );
})();