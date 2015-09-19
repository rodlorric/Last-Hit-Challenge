"use strict";

function OnEndScreen(data) {
	//Totals
	var stats_total_cs = CustomNetTables.GetTableValue( "stats_totals", "stats_total_cs" );
	var stats_total_lh = CustomNetTables.GetTableValue( "stats_totals", "stats_total_lh" );
	var stats_total_dn = CustomNetTables.GetTableValue( "stats_totals", "stats_total_dn" );
	var stats_total_miss = CustomNetTables.GetTableValue( "stats_totals", "stats_total_miss");
	var stats_total_accuracy = CustomNetTables.GetTableValue( "stats_totals", "stats_total_accuracy");
	$("#stats_total_cs").text = stats_total_cs.value;
	$("#stats_total_lh").text = stats_total_lh.value;
	$("#stats_total_dn").text = stats_total_dn.value;
	$("#stats_total_miss").text = stats_total_miss.value;
	$("#stats_total_accuracy").text = parseFloat(Math.round(stats_total_accuracy.value).toFixed(2)) + "%";

	//Streaks
	var stats_streak_cs = CustomNetTables.GetTableValue( "stats_streaks", "stats_streak_cs" );
	var stats_streak_lh = CustomNetTables.GetTableValue( "stats_streaks", "stats_streak_lh" );
	var stats_streak_dn = CustomNetTables.GetTableValue( "stats_streaks", "stats_streak_dn" );
	$("#stats_streak_cs").text = stats_streak_cs.value;
	$("#stats_streak_lh").text = stats_streak_lh.value;
	$("#stats_streak_dn").text = stats_streak_dn.value;

	//Session Records
	var stats_record_cs = CustomNetTables.GetTableValue( "stats_records", "stats_record_cs" );
	var stats_record_lh = CustomNetTables.GetTableValue( "stats_records", "stats_record_lh" );
	var stats_record_dn = CustomNetTables.GetTableValue( "stats_records", "stats_record_dn" );
	var stats_record_accuracy = CustomNetTables.GetTableValue( "stats_records", "stats_record_accuracy" );
	$("#stats_record_cs").text = stats_record_cs.value;
	$("#stats_record_lh").text = stats_record_lh.value;
	$("#stats_record_dn").text = stats_record_dn.value;
	$("#stats_record_accuracy").text = parseFloat(Math.round(stats_record_accuracy.value).toFixed(2)) + "%";

	//Misc
	var stats_misc_restart = CustomNetTables.GetTableValue( "stats_misc", "stats_misc_restart" );
	var stats_misc_session_accuracy = CustomNetTables.GetTableValue( "stats_misc", "stats_misc_session_accuracy");
	$("#stats_misc_restart").text = stats_misc_restart.value;
	$("#stats_misc_session_accuracy").text = parseFloat(Math.round(stats_misc_session_accuracy.value).toFixed(2)) + "%";

	//Time
	var stats_time_spent = CustomNetTables.GetTableValue( "stats_time", "stats_time_spent" );
	var stats_time_longest = CustomNetTables.GetTableValue( "stats_time", "stats_time_longest" );
	var stats_time_shortest = CustomNetTables.GetTableValue( "stats_time", "stats_time_shortest" );
	$("#stats_time_spent").text = stats_time_spent.value;
	$("#stats_time_longest").text = stats_time_longest.value;
	$("#stats_time_shortest").text = stats_time_shortest.value;


	$("#end_screen_panel").ToggleClass("Maximized");
}

function OnRestart(){
	GameEvents.SendCustomGameEventToServer( "restart", {});
	$("#end_screen_panel").ToggleClass("Maximized");
}

function OnQuit(){
	GameEvents.SendCustomGameEventToServer( "quit", {});
}

function OnMagnifyLastHits(){
	$.Msg("Magnify LastHits!");
	var stats = $.CreatePanel( "Panel", $.GetContextPanel(), "LastHitStats" );
	stats.BLoadLayout( "file://{resources}/layout/custom_game/stats.xml", false, false );
	
	var label = stats.FindChildInLayoutFile("stats_title");
	label.text = "LAST HITS"

	var stats_panel = stats.FindChildInLayoutFile("stats_panel");
	LoadData(stats_panel, "lh");
}

function OnMagnifyDenies(){
	var stats = $.CreatePanel( "Panel", $.GetContextPanel(), "DeniesStats" );
	stats.BLoadLayout( "file://{resources}/layout/custom_game/stats.xml", false, false );
	
	var label = stats.FindChildInLayoutFile("stats_title");
	label.text = "LAST HITS"

	var stats_panel = stats.FindChildInLayoutFile("stats_panel");
	LoadData(stats_panel, "dn");
}

function OnMagnifyMisses(){
	$.Msg("Magnify Misses!");
	var stats = $.CreatePanel( "Panel", $.GetContextPanel(), "MissesStats" );
	stats.BLoadLayout( "file://{resources}/layout/custom_game/stats.xml", false, false );

	var label = stats.FindChildInLayoutFile("stats_title");
	label.text = "MISSES"

	var stats_panel = stats.FindChildInLayoutFile("stats_panel");
	LoadData(stats_panel, "miss");
}

function LoadData(stats_panel, type){
	var stats_melee = stats_panel.FindChildInLayoutFile("stats_melee");
	var stats_ranged = stats_panel.FindChildInLayoutFile("stats_ranged");
	var stats_siege = stats_panel.FindChildInLayoutFile("stats_siege");
	var stats_tower = stats_panel.FindChildInLayoutFile("stats_tower");

	stats_melee.text = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_melee_" + type ).value;
	stats_ranged.text = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_ranged_" + type ).value;
	stats_siege.text = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_siege_" + type ).value;
	stats_tower.text = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_" + type ).value;

	var team = Entities.GetTeamNumber(Players.GetPlayerHeroEntityIndex(0));
	/*
	if (team == DOTATeam_t.DOTA_TEAM_GOODGUYS){	
		$.CreatePanel( "Panel", stats_panel, "DireMeleeImg");
		$.CreatePanel( "Panel", stats_panel, "DireRangedImg");
		$.CreatePanel( "Panel", stats_panel, "DireSiegeImg");
		$.CreatePanel( "Panel", stats_panel, "DireTowerImg");
	} else {
		$.CreatePanel( "Panel", stats_panel, "RadiantMeleeImg");
		$.CreatePanel( "Panel", stats_panel, "RadiantRangedImg");
		$.CreatePanel( "Panel", stats_panel, "RadiantSiegeImg");
		$.CreatePanel( "Panel", stats_panel, "RadiantTowerImg");
	}
	*/
	if (type != "miss"){
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "DireMeleeImg" : "RadiantMeleeImg");
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "DireRangedImg" : "RadiantRangedImg");
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "DireSiegeImg" : "RadiantSiegeImg");
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "DireTowerImg" : "RadiantTowerImg");
	} else {
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "RadiantMeleeImg" : "DireMeleeImg");
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "RadiantRangedImg" : "DireRangedImg");
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "RadiantSiegeImg" : "DireSiegeImg");
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "RadiantTowerImg" : "DireTowerImg");
	}
}

(function () {
	GameEvents.Subscribe("end_screen", OnEndScreen);
})();