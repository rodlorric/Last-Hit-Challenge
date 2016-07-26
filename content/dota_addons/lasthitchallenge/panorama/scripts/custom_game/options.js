"use strict";

function OnClick(){
	$("#control_panel").ToggleClass("Minimized");
}

function OnRestartButton(){
	GameEvents.SendCustomGameEventToServer( "restart", { "playerId" : Game.GetLocalPlayerID()})
}

function OnCreepScoreRecordChanged( table_name, key, data ){

	var panel = $.GetContextPanel();
	var playerId = Game.GetLocalPlayerID();

	var cs = playerId + "c";
	var lh = playerId + "l";
	var dn = playerId + "d";
	
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
		$("#cs_accuracy").text = data.value + "%";
		panel.SetHasClass( "cs_accuracy_anim", true );
	} else if (key == playerId + "stats_accuracy_lh"){
		$("#lh_accuracy").text = data.value + "%";
		panel.SetHasClass( "lh_accuracy_anim", true );
	} else if (key == playerId + "stats_accuracy_dn"){
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

function OnInvulnerable(){
	$("#invulnerability").ToggleClass("checked");
}

function OnStart(data){
	if ($("#WaitPanel") != null) {
        $("#WaitPanel").DeleteAsync(0);
    }

	$("#control_panel").style.visibility = "visible";

    var time = data.time;
    var heroId = data.heroId;
    var leveling = data.leveling;

    var playerId = Game.GetLocalPlayerID();

	var panel = $.GetContextPanel();

	var suffix = "" + heroId + time + leveling;
	$("#cs").text = time != -1 ? CustomNetTables.GetTableValue( "stats_records", playerId + "c" + suffix ).value : "--";
	panel.SetHasClass( "cs_anim", true );	
	$("#lh").text = time != -1 ? CustomNetTables.GetTableValue( "stats_records", playerId + "l" + suffix ).value : "--";
	panel.SetHasClass( "lh_anim", true );	
	$("#dn").text =  time != -1 ? CustomNetTables.GetTableValue( "stats_records", playerId + "d" + suffix ).value : "--";
	panel.SetHasClass( "dn_anim", true );

	var date = new Date(null);
    date.setSeconds(time); // specify value for SECONDS here
    var minutes = date.toISOString().substr(14, 5);

	$("#records_header").SetDialogVariable("time" , (time != -1 ? minutes : "--"));
	$("#records_header").SetDialogVariable("lvl" , $.Localize(leveling == "n" ? "#nolvl" : "#lvl"));

    $("#hero_header").text = $.Localize(HeroName(heroId));

    if (time == -1){
    	$("#invulnerability").style.visibility = "visible;";
    	$("#controlpanelcontainer").style.height = "750px";
    } else {
    	$("#invulnerability").style.visibility = "collapse;";
    	$("#controlpanelcontainer").style.height = "730px";
    }
    GameEvents.SendCustomGameEventToServer( "invulnerability", { "invulnerability" : false });
   	$("#invulnerability").checked = false;
	$.Schedule( 1, OnResetAnimation );
}

/*
function OnTimePicked(time){
	var output = '';
	for (var property in time) {
      output += property + ': ' + time[property]+'; ';
    }

    var playerId = Game.GetLocalPlayerID();

	var panel = $.GetContextPanel();

	var suffix = hero_picked + time.value + (leveling ? "n":"l");
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
*/

function OnQuitButton(){
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
		//var pickcreen = $.CreatePanel( "Panel", $.GetContextPanel(), "PickScreen" );
		//pickcreen.BLoadLayout( "file://{resources}/layout/custom_game/pickscreen.xml", false, false );
		GameEvents.SendEventClientSide("new_pick", { "value" : "hero" });
		$("#control_panel").style.visibility = "collapse";
	} else if (option == "time") {
		var localPlayer = Game.GetPlayerInfo(Game.GetLocalPlayerID());
    	if (localPlayer['player_has_host_privileges']){
			//var timescreen = $.CreatePanel( "Panel", $.GetContextPanel(), "TimeScreen" );
			//timescreen.BLoadLayout( "file://{resources}/layout/custom_game/timescreen.xml", false, false );
			$("#control_panel").style.visibility = "collapse";
		} else {
       		var wait = $.CreatePanel( "Panel", $.GetContextPanel(), "WaitPanel" );
       		wait.BLoadLayout( "file://{resources}/layout/custom_game/wait.xml", false, false );
       		var dialog =  wait.FindChildInLayoutFile("wait_dialog");
       		
       		var allplayersids = Game.GetAllPlayerIDs();
       		for (var pid in allplayersids){
       		    if (pid != Game.GetLocalPlayerID()){
       		        var playername = Players.GetPlayerName(parseInt(pid));
       		        dialog.SetDialogVariable( "player", playername );
       		        break;
       		    }
       		}
       	}
		GameEvents.SendEventClientSide("new_pick", { "value" : "time" });
	}
}

function HeroName(hero_picked){
	var heroes = CustomNetTables.GetAllTableValues( "hero_selection" );
    for (var h in heroes) {
        if (hero_picked == heroes[h].key) { 
        	return heroes[h].value.hero;
        }
    }
}

(function () {
	GameEvents.Subscribe("start", OnStart);
	GameEvents.Subscribe("sync", OnSync);
	GameEvents.Subscribe("invulnerable", OnInvulnerable);
	//Setup for popup panel.
	var overlay = $.CreatePanel( "Panel", $.GetContextPanel(), "OverlayPanel" );
	overlay.BLoadLayout( "file://{resources}/layout/custom_game/overlay.xml", false, false );

	var localPlayer = Game.GetPlayerInfo(Game.GetLocalPlayerID());
    if (!localPlayer['player_has_host_privileges']){
    	$("#change_hero_button").enabled = false;
    	$("#change_hero_button").checked = true;
    	$("#change_time_button").enabled = false;
    	$("#change_time_button").checked = true;
		$("#restart_button").enabled = false;
		$("#restart_button").checked = true;
		$("#show_stats_button").enabled = false;
		$("#show_stats_button").checked = true;
		$("#invulnerability" ).enabled = false;
		$("#invulnerability" ).visible = false;
    }

	CustomNetTables.SubscribeNetTableListener( "stats_records", OnCreepScoreRecordChanged );
})();