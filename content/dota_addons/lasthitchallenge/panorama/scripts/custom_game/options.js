"use strict";

function OnClick(){
	$("#control_panel").ToggleClass("Minimized");
}

function OnRestartButton(){
	GameEvents.SendCustomGameEventToServer( "restart", {})
}

function OnQuitButton(){
	GameEvents.SendCustomGameEventToServer( "quit", {});
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
	var cs = "srcs";
	var lh = "srlh";
	var dn = "srdn";
	
	if (key.substring(0, cs.length) === cs){
		$("#cs").text = data.value;
		panel.SetHasClass( "cs_anim", true );
	} else if (key.substring(0, lh.length) === lh){
		$("#lh").text = data.value;
		panel.SetHasClass( "lh_anim", true );
	} else if (key.substring(0, dn.length) === dn){
		$("#dn").text = data.value;
		panel.SetHasClass( "dn_anim", true );
	} else if (key == "stats_accuracy_cs"){
		//$("#cs_accuracy").text = parseFloat(Math.round(data.value).toFixed(2)) + "%";
		$("#cs_accuracy").text = data.value + "%";
		panel.SetHasClass( "cs_accuracy_anim", true );
	} else if (key == "stats_accuracy_lh"){
		//$("#lh_accuracy").text = parseFloat(Math.round(data.value).toFixed(2)) + "%";
		$("#lh_accuracy").text = data.value + "%";
		panel.SetHasClass( "lh_accuracy_anim", true );
	} else if (key == "stats_accuracy_dn"){
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


var hero_picked = "nevermore";
var leveling = true;
function OnHeroPicked(data){
	if (data.hero == null){
		if (!data.repick){
			$("#control_panel").style.visibility = "visible";
		} else {
			$("#control_panel").style.visibility = "collapse";
		}
	} else {
		hero_picked = data.hero;
		leveling = data.leveling;
	}
}

function OnTimePicked(time){
	var panel = $.GetContextPanel();
	//var suffix = hero_picked + "_" + time.value + "_" + leveling;
	var suffix = hero_picked + time.value + (leveling ? "n":"l");

	//$("#cs").text = CustomNetTables.GetTableValue( "stats_records", "stats_record_cs_" + suffix ).value;
	$("#cs").text = CustomNetTables.GetTableValue( "stats_records", "srcs" + suffix ).value;
	panel.SetHasClass( "cs_anim", true );	
	//$("#lh").text = CustomNetTables.GetTableValue( "stats_records", "stats_record_lh_" + suffix ).value;
	$("#lh").text = CustomNetTables.GetTableValue( "stats_records", "srlh" + suffix ).value;
	panel.SetHasClass( "lh_anim", true );	
	//$("#dn").text = CustomNetTables.GetTableValue( "stats_records", "stats_record_dn_" + suffix ).value;
	$("#dn").text = CustomNetTables.GetTableValue( "stats_records", "srdn" + suffix ).value;
	panel.SetHasClass( "dn_anim", true );

	var date = new Date(null);
    date.setSeconds(time.value); // specify value for SECONDS here
    var minutes = date.toISOString().substr(14, 5);

    $("#hero_header").text = $.Localize("npc_dota_hero_" + hero_picked);
	$("#records_header").text =  $.Localize( "#controlpanel_records" ) + " " + minutes + " " + $.Localize(leveling ? "#nolvl" : "#lvl");
	$.Schedule( 1, OnResetAnimation );
}

function OnPickButton(){
	var pickcreen = $.CreatePanel( "Panel", $.GetContextPanel(), "PickScreen" );
	pickcreen.BLoadLayout( "file://{resources}/layout/custom_game/pickscreen.xml", false, false );
	GameEvents.SendCustomGameEventToServer( "repick", {})
	GameEvents.SendEventClientSide("hero_picked", {repick : true})
}

(function () {
	//Setup for popup panel.
	var overlay = $.CreatePanel( "Panel", $.GetContextPanel(), "OverlayPanel" );
	overlay.BLoadLayout( "file://{resources}/layout/custom_game/overlay.xml", false, false );

	CustomNetTables.SubscribeNetTableListener( "stats_records", OnCreepScoreRecordChanged );
	GameEvents.Subscribe("hero_picked", OnHeroPicked);
	GameEvents.Subscribe("time_picked", OnTimePicked);
})();