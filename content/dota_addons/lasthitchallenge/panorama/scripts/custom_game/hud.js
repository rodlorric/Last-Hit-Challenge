"use strict";

var end_screen = false;
function OnLastHitOrDeny( table_name, key, data ){
	var scorepanel = $.GetContextPanel();
	var playerId = Game.GetLocalPlayerID();

	if (key == playerId + "stats_total_lh") {
		$("#Lasthits").text = data["value"];	
		scorepanel.SetHasClass( "lh_anim", true );
	} else if (key == playerId + "stats_total_dn") {
		$("#Denies").text = data["value"];
		scorepanel.SetHasClass( "dn_anim", true );	
	}
	$.Schedule( 1, OnResetAnimation );
}

function OnClockTime(data) {
	var clockPanel = $.GetContextPanel();
	var color = (data["bTimeLeft"] == 0 ? "#A0A0A0FF" : "#8B0000FF");
	if ($("#clock").style.color != color){
		$("#clock").style.color = color;
	}
	$("#clock").text = data["min"] + ":" + data["sec"];
}

function OnResetAnimation(data) {
	var scorepanel = $.GetContextPanel();
	scorepanel.SetHasClass( "lh_anim", false );
	scorepanel.SetHasClass( "dn_anim", false );
}

function OnStart(data){
    var heroId = data.heroId;
    var leveling = data.leveling;
    var time = data.time;
    var playerId = data.playerId;
    
    $("#score_panel").style.visibility = "visible";
	$("#clock_panel").style.visibility = "visible";

	//In case of reconnection, this shuould show current LH/D scores instead of 0/0
	var stats_total_lh = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_lh" ).value;
	var stats_total_dn = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_dn" ).value;
	$("#Lasthits").text = stats_total_lh;
	$.GetContextPanel().SetHasClass( "lh_anim", true );
	$("#Denies").text = stats_total_dn;
	$.GetContextPanel().SetHasClass( "dn_anim", true );
	$.Schedule( 1, OnResetAnimation );	

    var localPlayer = Game.GetPlayerInfo(Game.GetLocalPlayerID());
    if (localPlayer['player_has_host_privileges']){
    	GameEvents.SendCustomGameEventToServer("start", {});
    }
    GameEvents.SendCustomGameEventToServer("spawn_heroes", { "playerId" : playerId, "heroId" : heroId, "leveling" : leveling, "time" : time });
}

var end_screen = false;
function OnEndScreen(endscreen){
	if (endscreen.visible == 1){
		end_screen = true;
	} else {
		end_screen = false;
	}
}

function OnQuit(){
	if (end_screen){
		GameEvents.SendEventClientSide("quit", {});
	} else if ($("#QuitPanel") == null){
		//GameEvents.SendCustomGameEventToServer( "quit_dialog", {});
		var quit = $.CreatePanel( "Panel", $.GetContextPanel(), "QuitPanel" );
		quit.BLoadLayout( "file://{resources}/layout/custom_game/quit.xml", false, false );
	}
}

function HideClock(){
	$("#clock_panel").style.visibility = "collapse";
	$("#score_panel").style.visibility = "collapse";
}

function Pause(){
	var playerName = Players.GetPlayerName(parseInt(Game.GetLocalPlayerID()));
	var p_color = Players.GetPlayerColor(parseInt(Game.GetLocalPlayerID())).toString(16);
	p_color = "#" + p_color.substring(6, 8) + p_color.substring(4, 6) + p_color.substring(2, 4) + p_color.substring(0, 2);
	GameEvents.SendCustomGameEventToServer("pause", { "playerName" : playerName, "playerColor" : p_color });
}

(function () {
	//GameEvents.Subscribe("last_hit", OnLastHitOrDeny);
	//GameEvents.Subscribe("hero_picked", OnHeroPicked);
	GameEvents.Subscribe("clock", OnClockTime);
	GameEvents.Subscribe("endscreen", OnEndScreen);
	//GameEvents.Subscribe("start_game", OnStart);
	GameEvents.Subscribe("start", OnStart);
	GameEvents.Subscribe("new_pick", HideClock);

	Game.AddCommand("CustomGamePause", Pause, "", 0 );

	CustomNetTables.SubscribeNetTableListener( "stats_totals", OnLastHitOrDeny );
})();