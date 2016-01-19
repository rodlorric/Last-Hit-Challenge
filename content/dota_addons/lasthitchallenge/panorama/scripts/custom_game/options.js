"use strict";

function OnClick(){
	$("#control_panel").ToggleClass("Minimized");
}

function OnRestartButton(){
	GameEvents.SendCustomGameEventToServer( "restart", { "playerId" : Game.GetLocalPlayerID()})
}


/*
function OnCreepScoreRecordChanged( table_name, key, data ){
	var panel = $.GetContextPanel();
	$("#cs").text = data["cs"]
	$("#lh").text = data["lh"]
	$("#dn").text = data["dn"]
	if (data["anim"]["lh"] == true) {
		panel.SetHasClass( "cs_anim", true );
	} 
	if (data["anim"]["dn"] == true) {
		panel.SetHasClass( "lh_anim", true );
	}
	if (data["anim"]["cs"] == true) {
		panel.SetHasClass( "dn_anim", true );
	}
	$.Schedule( 1, OnResetAnimation );
} 
*/
function OnCreepScoreRecordChanged( table_name, key, data ){

	var panel = $.GetContextPanel();
	var playerId = Game.GetLocalPlayerID();

	var cs = playerId + "c";
	var lh = playerId + "l";
	var dn = playerId + "d";

	$.Msg("key = " + key);
	
	if (key.substring(0, cs.length) === cs){
		$("#cs").text = data.value;
		panel.SetHasClass( "cs_anim", true );
	} else if (key.substring(0, lh.length) === lh){
		$("#lh").text = data.value;
		panel.SetHasClass( "lh_anim", true );
	} else if (key.substring(0, dn.length) === dn){
		$("#dn").text = data.value;
		panel.SetHasClass( "dn_anim", true );
	} else if (key == playerId + "stats_accuracy_cs"){
		//$("#cs_accuracy").text = parseFloat(Math.round(data.value).toFixed(2)) + "%";
		$("#cs_accuracy").text = data.value + "%";
		panel.SetHasClass( "cs_accuracy_anim", true );
	} else if (key == playerId + "stats_accuracy_lh"){
		//$("#lh_accuracy").text = parseFloat(Math.round(data.value).toFixed(2)) + "%";
		$("#lh_accuracy").text = data.value + "%";
		panel.SetHasClass( "lh_accuracy_anim", true );
	} else if (key == playerId + "stats_accuracy_dn"){
		//$("#dn_accuracy").text = parseFloat(Math.round(data.value).toFixed(2)) + "%";
		$("#dn_accuracy").text = data.value + "%";
		panel.SetHasClass( "dn_accuracy_anim", true );
	}
	$.Schedule( 1, OnResetAnimation );
} 

function OnResetAnimation() {
	var panel = $.GetContextPanel();
	panel.SetHasClass( "cs_anim", false );
	panel.SetHasClass( "lh_anim", false );
	panel.SetHasClass( "dn_anim", false );
	panel.SetHasClass( "cs_accuracy_anim", false );
	panel.SetHasClass( "lh_accuracy_anim", false );
	panel.SetHasClass( "dn_accuracy_anim", false );
}

function OnToggle(){
	var toggleButton = $("#hide_overlay");
	var overlay = $("#OverlayPanel");
	if (toggleButton.checked){
		overlay.style.visibility = "collapse";
	} else {
		overlay.style.visibility = "visible";
	}
	GameEvents.SendCustomGameEventToServer( "hidehelp", { "hidehelp" : toggleButton.checked });
}

function OnInvulnerability(){
	GameEvents.SendCustomGameEventToServer( "invulnerability", { "invulnerability" : $("#invulnerability").checked });
}


//var hero_picked = "nevermore";
//var leveling = true;
//function OnHeroPicked(data){
//	if (data.hero == null){
//		if (!data.repick){
//			$("#control_panel").style.visibility = "visible";
//		} else {
//			$("#control_panel").style.visibility = "collapse";
//		}
//	} else {
//		hero_picked = data.hero;
//		leveling = data.leveling;
//	}
//}

function OnStart(data){
	$.Msg("OnStart options.js");
	$("#control_panel").style.visibility = "visible";
	var output = '';
	for (var property in data) {
      output += property + ': ' + data[property]+'; ';
    }
    $.Msg("Time = " + output);

    $.Msg("time.value = " + data.time);
    var time = data.time;
    var heroId = data.heroId;
    var leveling = data.leveling;

    var playerId = Game.GetLocalPlayerID();

	var panel = $.GetContextPanel();

	var suffix = heroId + time + (leveling ? "n":"l");
	$.Msg("suffix = " + suffix);
	$("#cs").text = time != -1 ? CustomNetTables.GetTableValue( "stats_records", playerId + "c" + suffix ).value : "--";
	panel.SetHasClass( "cs_anim", true );	
	$("#lh").text = time != -1 ? CustomNetTables.GetTableValue( "stats_records", playerId + "l" + suffix ).value : "--";
	panel.SetHasClass( "lh_anim", true );	
	$("#dn").text =  time != -1 ? CustomNetTables.GetTableValue( "stats_records", playerId + "d" + suffix ).value : "--";
	panel.SetHasClass( "dn_anim", true );

	var date = new Date(null);
    date.setSeconds(time); // specify value for SECONDS here
    var minutes = date.toISOString().substr(14, 5);

	$("#records_header").text = $.Localize( "#controlpanel_records" ) + " " + (time != -1 ? minutes : "--") + " " + $.Localize(leveling ? "#nolvl" : "#lvl");

    $("#hero_header").text = $.Localize(HeroName(heroId));

    if (time == -1){
    	$("#invulnerability").style.visibility = "visible;";
    	$("#controlpanelcontainer").style.height = "780px";
    } else {
    	$("#invulnerability").style.visibility = "collapse;";
    	$("#controlpanelcontainer").style.height = "760px";
    }
    GameEvents.SendCustomGameEventToServer( "invulnerability", { "invulnerability" : false });
   	$("#invulnerability").checked = false;
	$.Schedule( 1, OnResetAnimation );
}

function OnTimePicked(time){
	var output = '';
	for (var property in time) {
      output += property + ': ' + time[property]+'; ';
    }
    $.Msg("Time = " + output);

    $.Msg("time.value = " + time.value);

    var playerId = Game.GetLocalPlayerID();

	var panel = $.GetContextPanel();

	var suffix = hero_picked + time.value + (leveling ? "n":"l");
	$.Msg("suffix = " + suffix);
	$("#cs").text = time.value != -1 ? CustomNetTables.GetTableValue( "stats_records", playerId + "c" + suffix ).value : "--";
	panel.SetHasClass( "cs_anim", true );	
	$("#lh").text = time.value != -1 ? CustomNetTables.GetTableValue( "stats_records", playerId + "l" + suffix ).value : "--";
	panel.SetHasClass( "lh_anim", true );	
	$("#dn").text =  time.value != -1 ? CustomNetTables.GetTableValue( "stats_records", playerId + "d" + suffix ).value : "--";
	panel.SetHasClass( "dn_anim", true );

	var date = new Date(null);
    date.setSeconds(time.value); // specify value for SECONDS here
    var minutes = date.toISOString().substr(14, 5);

	$("#records_header").text = $.Localize( "#controlpanel_records" ) + " " + (time.value != -1 ? minutes : "--") + " " + $.Localize(leveling ? "#nolvl" : "#lvl");

    $("#hero_header").text = $.Localize(HeroName(hero_picked));

    if (time.value == -1){
    	$("#invulnerability").style.visibility = "visible;";
    	$("#controlpanelcontainer").style.height = "780px";
    } else {
    	$("#invulnerability").style.visibility = "collapse;";
    	$("#controlpanelcontainer").style.height = "730px";
    }
    GameEvents.SendCustomGameEventToServer( "invulnerability", { "invulnerability" : false });
   	$("#invulnerability").checked = false;
	$.Schedule( 1, OnResetAnimation );
}

function OnQuitButton(){
	$.Msg("Showing stats!");
	GameEvents.SendCustomGameEventToServer( "sync", { "value" : "stats" })
	GameEvents.SendCustomGameEventToServer( "quit_control_panel", {});
}

function OnPickButton(){	
	GameEvents.SendCustomGameEventToServer( "sync", { "value" : "hero" })
}

function OnChangeTime(){
	GameEvents.SendCustomGameEventToServer( "sync", { "value" : "time"})
}

function OnSync(params){
	var option = params.value;
	if (option == "hero") { 
		var pickcreen = $.CreatePanel( "Panel", $.GetContextPanel(), "PickScreen" );
		pickcreen.BLoadLayout( "file://{resources}/layout/custom_game/pickscreen.xml", false, false );
	} else if (option == "time") {
		var localPlayer = Game.GetPlayerInfo(Game.GetLocalPlayerID());
    	$.Msg(localPlayer);
    	if (localPlayer['player_has_host_privileges']){
			var timescreen = $.CreatePanel( "Panel", $.GetContextPanel(), "TimeScreen" );
			timescreen.BLoadLayout( "file://{resources}/layout/custom_game/timescreen.xml", false, false );
		}
	}
	//} else {
	//	$.Msg("OnSync stats... " + params.value)
	//	GameEvents.SendCustomGameEventToServer( "quit_control_panel", {});
	//}
}


//function PickHero(){
//	for (var playerId of Game.GetAllPlayerIDs()) {
//		SendEventClientSide("pick_hero", {})
//	     var playerInfo = Game.GetPlayerInfo(playerId);      
//	     var output = '';
//	     for (var property in playerInfo) {
//	       output += property + ': ' + playerInfo[property]+'; ';
//	     }
//	     $.Msg(output);
//	}
//}


function HeroName(hero_picked){
	var heroes = CustomNetTables.GetAllTableValues( "hero_selection" );
    for (var h in heroes) {
        if (hero_picked == heroes[h].key) { 
        	return heroes[h].value.hero;
        }
    }
}

//function OnStart(data){
//    var heroId = data.heroId;
//    var leveling = data.leveling;
//    var time = data.time;
//    var playerId = data.playerId;
//    $.Msg("option.js heroId = " + heroId + ", leveling = " + leveling + ", time = " + time + ", playerId = " + playerId);
//}


(function () {
	//GameEvents.Subscribe("start_game", OnStart);
	GameEvents.Subscribe("start", OnStart);
	GameEvents.Subscribe("sync", OnSync);
	//Setup for popup panel.
	var overlay = $.CreatePanel( "Panel", $.GetContextPanel(), "OverlayPanel" );
	overlay.BLoadLayout( "file://{resources}/layout/custom_game/overlay.xml", false, false );

	var localPlayer = Game.GetPlayerInfo(Game.GetLocalPlayerID());
    if (!localPlayer['player_has_host_privileges']){
    	$("#change_hero_button").enabled = false;
    	$("#change_time_button").enabled = false;
		$("#restart_button").enabled = false;
		$("#show_stats_button").enabled = false;
		$("#invulnerability" ).enabled = false;
    }

	CustomNetTables.SubscribeNetTableListener( "stats_records", OnCreepScoreRecordChanged );
	//GameEvents.Subscribe("hero_picked", OnHeroPicked);
	//GameEvents.Subscribe("time_picked", OnTimePicked);
})();