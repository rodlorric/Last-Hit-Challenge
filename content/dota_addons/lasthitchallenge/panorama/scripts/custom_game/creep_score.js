"use strict";
function OnLastHitOrDeny(data) {
	var last_hitPanel = $.GetContextPanel();
	$.Msg(data)
	if (data["lh"] == true) {
		//$("#CreepScoreLH").text = Players.GetLastHits( 0 );
		$("#CreepScoreLH").text = data["cs"]["lh"];
		last_hitPanel.SetHasClass( "last_hit_anim", true );		
	} else {
		//$("#CreepScoreDN").text = Players.GetDenies( 0 );
		$("#CreepScoreDN").text = data["cs"]["dn"];
		last_hitPanel.SetHasClass( "deny_anim", true );
	}
	$.Schedule( 1, OnResetAnimation );
}

function OnResetAnimation(data) {
	var last_hitPanel = $.GetContextPanel();
	last_hitPanel.SetHasClass( "last_hit_anim", false );
	last_hitPanel.SetHasClass( "deny_anim", false );
}

(function () {
	GameEvents.Subscribe("last_hit", OnLastHitOrDeny);
})();