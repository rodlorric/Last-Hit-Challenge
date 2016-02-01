"use strict";

function OnYes(){
	GameEvents.SendCustomGameEventToServer( "quit", {});
}

function OnNo(){
	//if ($("#QuitPanelEndScreen") == null){
	//	GameEvents.SendCustomGameEventToServer( "cancel", {});
	//}
	var quit = $.GetContextPanel();
	quit.DeleteAsync(0);
}

(function () {
})();