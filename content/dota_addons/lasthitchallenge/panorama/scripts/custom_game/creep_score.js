"use strict";
function OnLastHitOrDeny(data) {
	var last_hitPanel = $.GetContextPanel();
	$.Msg(data)
	if (data["lh"] == true) {
		//$("#CreepScoreLH").text = Players.GetLastHits( 0 );
		$("#CreepScoreLH").text = data["cs"]["lh"];
		last_hitPanel.SetHasClass( "last_hit_anim", true );
		$.Msg("Animate!")
	} else {
		//$("#CreepScoreDN").text = Players.GetDenies( 0 );
		$("#CreepScoreDN").text = data["cs"]["dn"];
		last_hitPanel.SetHasClass( "deny_anim", true );
	}
}

function OnResetAnimation(data) {
	var last_hitPanel = $.GetContextPanel();
	$.Msg("OnResetAnimation!" + data['lh'])
	if (data["lh"] == true) {
		last_hitPanel.SetHasClass( "last_hit_anim", false );
	} else {
		last_hitPanel.SetHasClass( "deny_anim", false );
	}
}

(function () {
	GameEvents.Subscribe("last_hit", OnLastHitOrDeny);
	GameEvents.Subscribe("reset_animation", OnResetAnimation);
})();