"use strict";

function OnEndScreen(data) {
	$.Msg("OnEndScreen...");
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
	var stats_record_cs = CustomNetTables.GetTableValue( "stats_records", "stats_record_cs_" + data.hero + "_" + data.time + "_" + data.level);
	var stats_record_lh = CustomNetTables.GetTableValue( "stats_records", "stats_record_lh_" + data.hero + "_" + data.time + "_" + data.level);
	var stats_record_dn = CustomNetTables.GetTableValue( "stats_records", "stats_record_dn_" + data.hero + "_" + data.time + "_" + data.level);
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


	//Graph
	var stats_misc_history = CustomNetTables.GetTableValue("stats_misc", "stats_misc_history");

	var bar_container = $("#graph_container");
	var x_leyend = $("#x_leyend");
	var max = 1;
	var timeacum = 30;

	//10 mins
	//stats_misc_history = [{lh : 3, dn : 1}, {lh : 1, dn : 1}, {lh : 4, dn : 1}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 4, dn : 0}, {lh : 1, dn : 2}, {lh : 3, dn : 0}, {lh : 3, dn : 0},
	//{lh : 2, dn : 2}, {lh : 2, dn : 1}, {lh : 1, dn : 2}, {lh : 3, dn : 2}, {lh : 3, dn : 2}, {lh : 3, dn : 2}, {lh : 1, dn : 2}, {lh : 4, dn : 2}, {lh : 5, dn : 0}, {lh : 2, dn : 1},
	//{lh : 5, dn : 2}, {lh : 3, dn : 0}, {lh : 2, dn : 2}];

	//7:30 mins
	//stats_misc_history = [{lh : 0, dn : 0}, {lh : 1, dn : 1}, {lh : 3, dn : 1}, {lh : 2, dn : 2}, {lh : 9, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 3, dn : 1}, {lh : 2, dn : 0},
	//{lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 3, dn : 2}, {lh : 1, dn : 2}, {lh : 1, dn : 2}];

	//5 mins
	//stats_misc_history = [{lh : 0, dn : 0}, {lh : 1, dn : 1}, {lh : 3, dn : 1}, {lh : 2, dn : 2}, {lh : 8, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 3, dn : 1}, {lh : 2, dn : 0},
	//{lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}];

	//2 mins
	//stats_misc_history = [{lh : 0, dn : 0}, {lh : 1, dn : 1}, {lh : 3, dn : 1}, {lh : 2, dn : 2}, {lh : 8, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}];

	for (var i in stats_misc_history) {
		if (i > 1){
			var lh = stats_misc_history[i].lh;
			var dn = stats_misc_history[i].dn;
			if (lh > max){
				max = lh;
			}
			if (dn > max){
				max = dn;
			}
		}
	};

	for (var j in stats_misc_history) {
		if (j > 1){
			var lh = stats_misc_history[j].lh;
			var dn = stats_misc_history[j].dn
			var date = new Date(null);
	    	date.setSeconds(timeacum); // specify value for SECONDS here
	    	var minutes = date.toISOString().substr(14, 5);
			timeacum += 30;
	  		
			var data_container = $.CreatePanel("Panel", bar_container, "data_container");		
			var couple_container = $.CreatePanel("Panel", data_container, "cs_container");

			var bar_holder = $.CreatePanel("Panel", couple_container, "BarHolder");
			bar_holder.style.opacity = "1.0";
	  		var bar = $.CreatePanel( "Panel", bar_holder, "BarLH");
	  		var ypct = Math.round((lh * 100)/max);
			var y = Math.round((ypct * 160) / 100);
	  		bar.style.height = y + "px;";
	  		var label = $.CreatePanel("Label", bar_holder, "");
	  		label.text = lh;
	  		label.style.verticalAlign = "top;";
	  		label.style.textAlign = "center;";

	  		var bar_holder = $.CreatePanel("Panel", couple_container, "BarHolder");
	  		var bar = $.CreatePanel( "Panel", bar_holder, "BarDN");
	  		bar_holder.style.opacity = "1.0";
	  		var ypct = Math.round((dn * 100)/max);
			var y = Math.round((ypct * 160) / 100);
	  		bar.style.height = y + "px;";
	  		var label = $.CreatePanel("Label", bar_holder, "");
	  		label.text = dn;
	  		label.style.textAlign = "center;";

	  		var x_hor_bar = $.CreatePanel("Panel", data_container, "HorBar");
	  		var x_label = $.CreatePanel("Label", data_container, "XLeyendLabel");
	  		x_label.text = minutes;
  		}
	};

	$("#end_screen_panel").ToggleClass("Maximized");
	$("#end_screen_panel").hittest = true;
}

function OnRestart(){
	$("#end_screen_panel").ToggleClass("Maximized");
	GameEvents.SendCustomGameEventToServer( "restart", {});
	ClearGraph()
}

function OnQuit(){
	GameEvents.SendCustomGameEventToServer( "quit", {});
}

function ClearGraph(){
	//clearing the graph...
	var graph_children = $("#graph_container").Children();
	for (var i in graph_children){
		graph_children[i].DeleteAsync(0.0);
	}

	var x_leyend = $("#x_leyend").Children();
	for (var i in x_leyend){
		x_leyend[i].DeleteAsync(0.0);
	}
}

function OnPickButton(){
	$("#end_screen_panel").ToggleClass("Maximized");
	ClearGraph();

	var pickcreen = $.CreatePanel( "Panel", $.GetContextPanel(), "PickScreen" );
	pickcreen.BLoadLayout( "file://{resources}/layout/custom_game/pickscreen.xml", false, false );
	GameEvents.SendCustomGameEventToServer( "repick", {})
	GameEvents.SendEventClientSide("hero_picked", {repick : true})
}

function OnMagnifyLastHits(){
	var stats = $.CreatePanel( "Panel", $.GetContextPanel(), "LastHitStats" );
	stats.BLoadLayout( "file://{resources}/layout/custom_game/stats.xml", false, false );
	
	var label = stats.FindChildInLayoutFile("stats_title");
	label.text = "stats_last_hits"

	var stats_panel = stats.FindChildInLayoutFile("stats_panel");
	LoadData(stats_panel, "lh");
}

function OnMagnifyDenies(){
	var stats = $.CreatePanel( "Panel", $.GetContextPanel(), "DeniesStats" );
	stats.BLoadLayout( "file://{resources}/layout/custom_game/stats.xml", false, false );
	
	var label = stats.FindChildInLayoutFile("stats_title");
	label.text = "stats_denies"

	var stats_panel = stats.FindChildInLayoutFile("stats_panel");
	LoadData(stats_panel, "dn");
}

function OnMagnifyMisses(){
	var stats = $.CreatePanel( "Panel", $.GetContextPanel(), "MissesStats" );
	stats.BLoadLayout( "file://{resources}/layout/custom_game/stats.xml", false, false );

	var label = stats.FindChildInLayoutFile("stats_title");
	label.text = "stats_misses"

	var stats_panel = stats.FindChildInLayoutFile("stats_panel");
	LoadData(stats_panel, "miss");
}

function LoadData(stats_panel, type){
	var stats_melee = stats_panel.FindChildInLayoutFile("stats_melee");
	var stats_ranged = stats_panel.FindChildInLayoutFile("stats_ranged");
	var stats_siege = stats_panel.FindChildInLayoutFile("stats_siege");
	//var stats_tower = stats_panel.FindChildInLayoutFile("stats_tower");

	if (type != "miss"){

		var melee = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_melee_" + type ).value;
		var missed_melee = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_melee_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
		stats_melee.text = melee + " / " + (melee + missed_melee);

		var ranged = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_ranged_" + type ).value;
		var missed_ranged = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_ranged_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
		stats_ranged.text = ranged + " / " + (ranged + missed_ranged);

		var siege = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_siege_" + type ).value;
		var missed_siege = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_siege_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
		stats_siege.text = siege + " / " + (siege + missed_siege);

		//var tower = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_" + type ).value;
		//var missed_tower = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
		//stats_tower.text = tower + " / " + (tower + missed_tower);

	} else { //misses
		var cs_melee = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_melee_lh").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_melee_dn").value;
		var missed_melee = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_melee_" + type + "_friendly").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_melee_" + type + "_foe").value;
		stats_melee.text = missed_melee + " / " + (missed_melee + cs_melee);

		var cs_ranged = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_ranged_lh").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_ranged_dn").value;
		var missed_ranged = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_ranged_" + type + "_friendly").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_ranged_" + type + "_foe").value;
		stats_ranged.text = missed_ranged + " / " + (missed_ranged + cs_ranged);

		var cs_siege = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_siege_lh").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_siege_dn").value;
		var missed_siege = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_siege_" + type + "_friendly").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_siege_" + type + "_foe").value;
		stats_siege.text = missed_siege + " / " + (missed_siege + cs_siege);

		//var cs_tower = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_lh").value + 
		//			CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_dn").value;
		//var missed_tower = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_" + type + "_friendly").value + 
		//			CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_" + type + "_foe").value;
		//stats_tower.text = missed_tower + " / " + (missed_tower + cs_tower);

	}

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
	if (type == "lh"){
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "DireMeleeImg" : "RadiantMeleeImg");
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "DireRangedImg" : "RadiantRangedImg");
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "DireSiegeImg" : "RadiantSiegeImg");
		//$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "DireTowerImg" : "RadiantTowerImg");
	} else if (type == "dn") {
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "RadiantMeleeImg" : "DireMeleeImg");
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "RadiantRangedImg" : "DireRangedImg");
		$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "RadiantSiegeImg" : "DireSiegeImg");
		//$.CreatePanel( "Panel", stats_panel, (team == DOTATeam_t.DOTA_TEAM_GOODGUYS) ? "RadiantTowerImg" : "DireTowerImg");
	} else {
		$.CreatePanel( "Panel", stats_panel, "DireRadiantMeleeImg");
		$.CreatePanel( "Panel", stats_panel, "DireRadiantRangedImg");
		$.CreatePanel( "Panel", stats_panel, "DireRadiantSiegeImg");
		//$.CreatePanel( "Panel", stats_panel, "DireRadiantTowerImg");
	}
}

(function () {
	GameEvents.Subscribe("end_screen", OnEndScreen);
})();