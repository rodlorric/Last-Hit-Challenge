"use strict";

function OnYes(){
	$.Msg("onyes!");
	GameEvents.SendCustomGameEventToServer( "quit", {});
}

function OnNo(){
	if ($("#QuitPanelEndScreen") == null){
		GameEvents.SendCustomGameEventToServer( "cancel", {});
	}
	var quit = $.GetContextPanel();
	quit.DeleteAsync(0);
}

(function () {
})();