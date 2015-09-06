"use strict";
function Clock(data) {
	var clickPanel = $.GetContextPanel();
	$("#min").text = data["min"];
	$("#sec").text = data["sec"];
}

(function () {
	GameEvents.Subscribe("clock", Clock);
})();