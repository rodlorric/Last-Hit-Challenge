"use strict";

function OnQuit(){
	var leaderboard = $.GetContextPanel();
	ClearList();
	leaderboard.DeleteAsync(0);
}

function OnLeaderboard(data){
	ClearList();
	for (var i in data) {

		var listpanel = $("#leaderlist");
		var row = $.CreatePanel("Panel", listpanel, "");
		row.AddClass("Row");
		row.style.opacity = "1.0;";

		var player_panel = $.CreatePanel("Panel", row, "");
		player_panel.AddClass("PlayerPanel");

		var avatar = $.CreatePanel("DOTAAvatarImage", player_panel, "");
		avatar.steamid = SteamID32to64(data[i]['steam_id']);

		var player = $.CreatePanel("DOTAUserName", player_panel, "");
		player.steamid = SteamID32to64(data[i]['steam_id']);


		var score = $.CreatePanel("Label", row, "");
		score.text = data[i]['value'];
	}
}

function ClearList(){
	var listpanel = $("#leaderlist").Children();
	for (var i in listpanel){
		listpanel[i].DeleteAsync(0.0);
	}
}

function SteamID32to64(steamid32){
	return '765' + (parseInt(steamid32) + 61197960265728);
}

function OnDropDown(){
	var hero = $.FindChildInContext('#dropdown_hero').GetSelected().id;
	var time = $.FindChildInContext('#dropdown_time').GetSelected().id;
	var leveling = $.FindChildInContext('#dropdown_leveling').GetSelected().id;
	var typescore = $.FindChildInContext('#dropdown_type').GetSelected().id;

	GameEvents.SendCustomGameEventToServer( "leaderboard", { "hero" : hero, "time" : time, "leveling" : leveling, "typescore" : typescore});
}

(function () {
	GameEvents.Subscribe("leaderboard", OnLeaderboard);
	
	OnDropDown();
})();