"use strict";

function OnClick(){
	$("#control_panel").ToggleClass("Minimized");
}

function OnRestartButton(){
	var iPlayerID = Players.GetLocalPlayer();
	GameEvents.SendCustomGameEventToServer( "restart", {})
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
	if (key == "stats_record_cs"){
		$("#cs").text = data.value;
		panel.SetHasClass( "cs_anim", true );
	} else if (key == "stats_record_lh"){
		$("#lh").text = data.value;
		panel.SetHasClass( "lh_anim", true );
	} else if (key == "stats_record_dn"){
		$("#dn").text = data.value;
		panel.SetHasClass( "dn_anim", true );
	} else if (key == "stats_accuracy_cs"){
		$("#cs_accuracy").text = parseFloat(Math.round(data.value).toFixed(2)) + "%";
		panel.SetHasClass( "cs_accuracy_anim", true );
	} else if (key == "stats_accuracy_lh"){
		$("#lh_accuracy").text = parseFloat(Math.round(data.value).toFixed(2)) + "%";
		panel.SetHasClass( "lh_accuracy_anim", true );
	} else if (key == "stats_accuracy_dn"){
		$("#dn_accuracy").text = parseFloat(Math.round(data.value).toFixed(2)) + "%";
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

(function () {
	//Setup for popup panel.
	var overlay = $.CreatePanel( "Panel", $.GetContextPanel(), "OverlayPanel" );
	overlay.BLoadLayout( "file://{resources}/layout/custom_game/overlay.xml", false, false );

	CustomNetTables.SubscribeNetTableListener( "stats_records", OnCreepScoreRecordChanged );
})();