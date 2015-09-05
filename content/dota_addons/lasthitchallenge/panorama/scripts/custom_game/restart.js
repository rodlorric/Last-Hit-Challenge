"use strict";
/*
function OnRestartButton( args ) {
	$.GetContextPanel().RemoveClass('Hidden');
}
*/

function OnRestartButton( args ){
	var iPlayerID = Players.GetLocalPlayer();
	$.Msg('Player '+iPlayerID+' restart');
	GameEvents.SendCustomGameEventToServer( "restart", {})
	/*$.GetContextPanel().AddClass('Hidden');*/
}

(function () {
	/*GameEvents.Subscribe( "player_died", OnPlayerDied );*/
})();