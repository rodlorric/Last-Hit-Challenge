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
	if (key == "stats_record_cs_150" || key == "stats_record_cs_300" || key == "stats_record_cs_450" || key == "stats_record_cs_600"){
		$("#cs").text = data.value;
		panel.SetHasClass( "cs_anim", true );
	} else if (key == "stats_record_lh_150" || key == "stats_record_lh_300" || key == "stats_record_lh_450" || key == "stats_record_lh_600"){
		$("#lh").text = data.value;
		panel.SetHasClass( "lh_anim", true );
	} else if (key == "stats_record_dn_150" || key == "stats_record_dn_300" || key == "stats_record_dn_450" || key == "stats_record_dn_600"){
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

function OnHeroPicked(bRepick){
	if (!bRepick.value){
		$("#control_panel").style.visibility = "visible";
	} else {
		$("#control_panel").style.visibility = "collapse";
	}
}

function OnTimePicked(time){
	var panel = $.GetContextPanel();
	$("#cs").text = CustomNetTables.GetTableValue( "stats_records", "stats_record_cs_" + time.value ).value;
	panel.SetHasClass( "cs_anim", true );	
	$("#lh").text = CustomNetTables.GetTableValue( "stats_records", "stats_record_lh_" + time.value ).value;
	panel.SetHasClass( "lh_anim", true );	
	$("#dn").text = CustomNetTables.GetTableValue( "stats_records", "stats_record_dn_" + time.value ).value;
	panel.SetHasClass( "dn_anim", true );

	var date = new Date(null);
    date.setSeconds(time.value); // specify value for SECONDS here
    var minutes = date.toISOString().substr(14, 5);

	$("#records_header").text = $.Localize( "#controlpanel_records" ) + minutes;
	$.Schedule( 1, OnResetAnimation );
}

function OnPickButton(){
	var pickcreen = $.CreatePanel( "Panel", $.GetContextPanel(), "PickScreen" );
	pickcreen.BLoadLayout( "file://{resources}/layout/custom_game/pickscreen.xml", false, false );
	GameEvents.SendCustomGameEventToServer( "repick", {})
	GameEvents.SendEventClientSide("hero_picked", {value : true})
}

(function () {
	//Setup for popup panel.
	var overlay = $.CreatePanel( "Panel", $.GetContextPanel(), "OverlayPanel" );
	overlay.BLoadLayout( "file://{resources}/layout/custom_game/overlay.xml", false, false );

	CustomNetTables.SubscribeNetTableListener( "stats_records", OnCreepScoreRecordChanged );
	GameEvents.Subscribe("hero_picked", OnHeroPicked);
	GameEvents.Subscribe("time_picked", OnTimePicked);
})();