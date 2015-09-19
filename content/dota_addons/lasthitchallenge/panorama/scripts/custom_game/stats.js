"use strict";

function OnQuit(){
	var stats = $.GetContextPanel();
	stats.DeleteAsync(0);
}

(function () {
})();