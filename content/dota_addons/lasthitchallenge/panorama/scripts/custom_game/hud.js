"use strict";
function OnLastHitOrDeny(data) {
	var scorepanel = $.GetContextPanel();
	$.Msg(data)
	if (data["lh"] == true) {
		$("#Lasthits").text = data["cs"]["lh"];	
		scorepanel.SetHasClass( "lh_anim", true );
	} else {
		$("#Denies").text = data["cs"]["dn"];
		scorepanel.SetHasClass( "dn_anim", true );	
	}
	

	$.Schedule( 1, OnResetAnimation);
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
	GameEvents.Subscribe("last_hit", OnLastHitOrDeny);
	GameEvents.Subscribe("clock", OnClockTime);
})();