"use strict";

function OnYes(){
	GameEvents.SendCustomGameEventToServer( "quit", {});
}

function OnNo(){
	var quit = $.GetContextPanel();
	quit.DeleteAsync(0);
}

(function () {
})();