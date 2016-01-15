"use strict";


var heroes = CustomNetTables.GetAllTableValues( "hero_selection" );
heroes.sort(function (a, b) {
    if ($.Localize(a.value.hero) > $.Localize(b.value.hero)) {
       return 1;
    }
    if ($.Localize(a.value.hero) < $.Localize(b.value.hero)) {
       return -1;
    }
    // a must be equal to b
    return 0;
});

var maxtime = 0;
var leveling = "l";
var time = -1;
function OnEndScreen(data) {
	var playerId = Game.GetLocalPlayerID();
	maxtime = data.maxtime;
	leveling = data.level;
	//Totals
	var stats_total_cs = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_cs" );
	var stats_total_lh = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_lh" );
	var stats_total_dn = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_dn" );
	var stats_total_miss = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_miss");
	var stats_total_accuracy = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_accuracy");
	$("#stats_total_cs").text = stats_total_cs.value;
	$("#stats_total_lh").text = stats_total_lh.value;
	$("#stats_total_dn").text = stats_total_dn.value;
	$("#stats_total_miss").text = stats_total_miss.value;
	//$("#stats_total_accuracy").text = parseFloat(Math.round(stats_total_accuracy.value).toFixed(2)) + "%";
	$("#stats_total_accuracy").text = stats_total_accuracy.value + "%";

	//Streaks
	var stats_streak_cs = CustomNetTables.GetTableValue( "stats_streaks", playerId + "stats_streak_cs" );
	var stats_streak_lh = CustomNetTables.GetTableValue( "stats_streaks", playerId + "stats_streak_lh" );
	var stats_streak_dn = CustomNetTables.GetTableValue( "stats_streaks", playerId + "stats_streak_dn" );
	$("#stats_streak_cs").text = stats_streak_cs.value;
	$("#stats_streak_lh").text = stats_streak_lh.value;
	$("#stats_streak_dn").text = stats_streak_dn.value;

	//Session Records
	//var stats_record_cs = CustomNetTables.GetTableValue( "stats_records", "stats_record_cs_" + data.hero + "_" + data.time + "_" + data.level);
	var stats_record_cs = CustomNetTables.GetTableValue( "stats_records", playerId + "c" + data.hero + data.maxtime + data.level);
	//var stats_record_lh = CustomNetTables.GetTableValue( "stats_records", "stats_record_lh_" + data.hero + "_" + data.time + "_" + data.level);
	var stats_record_lh = CustomNetTables.GetTableValue( "stats_records", playerId + "l" + data.hero + data.maxtime + data.level);
	//var stats_record_dn = CustomNetTables.GetTableValue( "stats_records", "stats_record_dn_" + data.hero + "_" + data.time + "_" + data.level);
	var stats_record_dn = CustomNetTables.GetTableValue( "stats_records", playerId + "d" + data.hero + data.maxtime + data.level);
	//var stats_record_accuracy = CustomNetTables.GetTableValue( "stats_records", "stats_record_accuracy_" + data.hero + "_" + data.time + "_" + data.level);
	var stats_record_accuracy = CustomNetTables.GetTableValue( "stats_records", playerId + "a" + data.hero + data.maxtime + data.level);
	$("#stats_record_cs").text = stats_record_cs.value;
	$("#stats_record_lh").text = stats_record_lh.value;
	$("#stats_record_dn").text = stats_record_dn.value;
	//$("#stats_record_accuracy").text = parseFloat(Math.round(stats_record_accuracy.value).toFixed(2)) + "%";
	$("#stats_record_accuracy").text = stats_record_accuracy.value + "%";

	var date = new Date(null);
    date.setSeconds(data.maxtime); // specify value for SECONDS here
    var minutes = date.toISOString().substr(14, 5);
	$("#acc_record").text = $.Localize("#endscreen_acc_record") +  minutes + ")";

	//Misc
	var stats_misc_restart = CustomNetTables.GetTableValue( "stats_misc", playerId + "stats_misc_restart" );
	var stats_misc_session_accuracy = CustomNetTables.GetTableValue( "stats_misc", playerId + "stats_misc_session_accuracy");
	$("#stats_misc_restart").text = stats_misc_restart.value;
	//$("#stats_misc_session_accuracy").text = parseFloat(Math.round(stats_misc_session_accuracy.value).toFixed(2)) + "%";
	$("#stats_misc_session_accuracy").text = stats_misc_session_accuracy.value + "%";

	//Time
	var stats_time_spent = CustomNetTables.GetTableValue( "stats_time", playerId + "stats_time_spent" );
	var stats_time_longest = CustomNetTables.GetTableValue( "stats_time", playerId + "stats_time_longest" );
	var stats_time_shortest = CustomNetTables.GetTableValue( "stats_time", playerId + "stats_time_shortest" );
	$("#stats_time_spent").text = stats_time_spent.value;
	$("#stats_time_longest").text = stats_time_longest.value;
	$("#stats_time_shortest").text = stats_time_shortest.value;


	//Graph
	var stats_misc_history = CustomNetTables.GetTableValue("stats_misc", playerId + "stats_misc_history");

	$.Msg(stats_misc_history);

	var bar_container = $("#graph_container");
	var x_leyend = $("#x_leyend");

	var graph_children = bar_container.Children();
	for (var i in graph_children){
		graph_children[i].DeleteAsync(0.0);
	}

	var x_leyend = x_leyend.Children();
	for (var i in x_leyend){
		x_leyend[i].DeleteAsync(0.0);
	}

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
		var lh = stats_misc_history[i].lh;
		var dn = stats_misc_history[i].dn;
		if (lh > max){
			max = lh;
		}
		if (dn > max){
			max = dn;
		}
	}
	for (var j in stats_misc_history) {
		//if (j > 1){
			var lh = stats_misc_history[j].lh;
			var dn = stats_misc_history[j].dn
			var date = new Date(null);
	    	//date.setSeconds(timeacum); // specify value for SECONDS here
	    	//var minutes = date.toISOString().substr(14, 5);
			//timeacum += 30;
			date.setSeconds(stats_misc_history[j].time); // specify value for SECONDS here
	    	var minutes = date.toISOString().substr(14, 5);
	  		
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
  		//}
	};

	if (data.time != data.maxtime){
		$("#cancel_button").style.visibility = "visible;"
		$("#cancel_button_top").style.visibility = "visible;"
	} else {
		$("#cancel_button").style.visibility = "collapse;"
		$("#cancel_button_top").style.visibility = "collapse;"
	}

	stats_misc_history = 0
	$("#end_screen_panel").ToggleClass("Maximized");
	$("#end_screen_panel").hittest = true;

	//GameEvents.SendEventClientSide("endscreen", {visible : 1})
}

function OnRestart(){
	//$("#end_screen_panel").ToggleClass("Maximized");
	GameEvents.SendCustomGameEventToServer( "restart", {});
}

function OnCancel(){
	GameEvents.SendCustomGameEventToServer( "cancel", {});
	//GameEvents.SendEventClientSide("endscreen", {visible : 0})
}

function OnCancelServer(){
	$.Msg("Cancel from server!");
	$.Msg("1 has class? = " + $("#end_screen_panel").BHasClass("Maximized"));
	if ($("#end_screen_panel").BHasClass("Maximized")){
		$.Msg("maximizado!");
		$("#end_screen_panel").ToggleClass("Maximized");	
	}
	$.Msg("2 has class? = " + $("#end_screen_panel").BHasClass("Maximized"));
}

function OnQuit(){
	if ($("#QuitPanelEndScreen") == null){
		var quit = $.CreatePanel( "Panel", $.GetContextPanel(), "QuitPanelEndScreen" );
		quit.BLoadLayout( "file://{resources}/layout/custom_game/quit.xml", false, false );
	}
}

function ClearGraph(){
	//clearing the graph...
	var graph_children = $("#graph_container").Children();
	for (var i in graph_children){
		graph_children[i].RemoveAndDeleteChildren();
	}

	var x_leyend = $("#x_leyend").Children();
	for (var i in x_leyend){
		x_leyend[i].RemoveAndDeleteChildren();
	}
}

//function OnPickButton(){
//	$("#end_screen_panel").ToggleClass("Maximized");
//
//	var pickcreen = $.CreatePanel( "Panel", $.GetContextPanel(), "PickScreen" );
//	pickcreen.BLoadLayout( "file://{resources}/layout/custom_game/pickscreen.xml", false, false );
//	GameEvents.SendCustomGameEventToServer( "repick", {})
//	GameEvents.SendEventClientSide("hero_picked", {repick : true})
//}
//
//function OnChangeTime(){
//	$("#end_screen_panel").ToggleClass("Maximized");
//	
//	var timescreen = $.CreatePanel( "Panel", $.GetContextPanel(), "TimeScreen" );
//	timescreen.BLoadLayout( "file://{resources}/layout/custom_game/timescreen.xml", false, false );
//	GameEvents.SendEventClientSide("repick", {});
//	GameEvents.SendCustomGameEventToServer( "repick", {})
//}

function OnPickButton(){	
	//$("#end_screen_panel").ToggleClass("Maximized");
	GameEvents.SendCustomGameEventToServer( "sync", { "value" : "hero" })
}

function OnChangeTime(){
	//$("#end_screen_panel").ToggleClass("Maximized");
	GameEvents.SendCustomGameEventToServer( "sync", { "value" : "time"})
}

function OnSync(params){
	var option = params.value;
	if (option == "hero") { 
		var pickcreen = $.CreatePanel( "Panel", $.GetContextPanel(), "PickScreen" );
		pickcreen.BLoadLayout( "file://{resources}/layout/custom_game/pickscreen.xml", false, false );
	} else if (option == "time") {
		var timescreen = $.CreatePanel( "Panel", $.GetContextPanel(), "TimeScreen" );
		timescreen.BLoadLayout( "file://{resources}/layout/custom_game/timescreen.xml", false, false );
	}
	//} else {
	//	GameEvents.SendCustomGameEventToServer( "quit_control_panel", {});
	//}
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

function OnLeaderBoardButton(){
	var leaderboard = $.CreatePanel( "Panel", $.GetContextPanel(), "LeaderBoard" );
	leaderboard.BLoadLayout( "file://{resources}/layout/custom_game/leaderboard.xml", false, false );
	var playerInfo = Game.GetPlayerInfo( 0 );
	var dropmenuhero = leaderboard.FindChildInLayoutFile("dropdown_hero");
	//<DropDown id="dropdown_hero" oninputsubmit="OnDropDown()"/>
	//var selector = leaderboard.FindChildInLayoutFile("selectorpanel");
	//var dropmenuhero = $.CreatePanel("DropDown", selector, "dropmenuhero");
	dropmenuhero.oninputsubmit = "OnDropDown()";
	for (var i in heroes){
		//var item = $.CreatePanel("Label", dropmenuhero, heroes[i].key);
		//item.text = $.Localize(heroes[i].value.hero);
		if (heroes[i].value.hero == playerInfo.player_selected_hero){
			dropmenuhero.SetSelected(heroes[i].key);
			break;
		}
	}
	var dropmenutime = leaderboard.FindChildInLayoutFile("dropdown_time");
	dropmenutime.SetSelected(maxtime);
	var dropmenuleveling = leaderboard.FindChildInLayoutFile("dropdown_leveling");
	dropmenuleveling.SetSelected(leveling);
}

//HEATMAP

var x_axis = [-2500,-2400,-2300,-2200,-2100,-2000,-1900,-1800,-1700,-1600,-1500,-1400,-1300,-1200,-1100,-1000,-900,
		-800,-700,-600,-500,-400,-300,-200,-100,0,100,200,300,400,500,600,700,800,900,1000,1200,1300,1400,1500,
		1600,1700,1800,1900,2000];
var y_axis = [1500,1400,1300,1200,1100,1000,900,800,700,600,500,400,300,200,100,0,-100,-200,-300,-400,-500,-600,-700,-800,-900,-1000,-1100,-1200,-1300,-1400,-1500,-1600,-1700,-1800,-1900,-2000,-2100,-2200,-2300,-2400,-2500];
//var x_axis = [-2500,-2450-2400,-2350,-2300,-2250,-2200,-2150,-2100,-2050,-2000,-1950,-1900,-1820,-1800,-1750,-1700,-1650,-1600,-1550,-1500,-1450,-1400,-1350,-1300,-1250,-1200,-1150,-1100,-1050,
//	-1000,-950,-900,-850,-800,-750,-700,-650,-600,-550,-500,-450,-400,-350,-300,-250,-200,-150,-100,-50,0,50,100,150,200,250,300,350,400,450,500,550,600,650,700,750,800,850,900,950,1000,1050,1100,
//	1150,1200,1250,1300,1350,1400,1450,1500,1550,1600,1650,1700,1750,1800,1850,1900,1950,2000];
//var y_axis = [1500,1450,1400,1350,1300,1250,1200,1150,1100,1050,1000,950,900,850,800,750,700,650,600,550,500,450,400,350,300,250,200,150,100,50,0,-50,-100,-150,-200,-250,-300,-350,-400,-450,-500,-550,
//	-600,-650,-700,-750,-800,-850,-900,-950,-1000,-1050,-1100,-1150,-1200,-1250,-1300,-1350,-1400,-1450,-1500,-1550,-1600,-1650,-1700,-1750,-1800,-1850,-1900,-1950,-2000,-2050,-2100,-2150,-2200,-2250,
//	-2300,-2350,-2400,-2450,-2500];


var matrix = [];
for (var row in y_axis){
	matrix[row] = [];
	for (var col in x_axis){
		matrix[row][col] = 0
	}
}

var max = 0;

function OnClearData(){
	matrix = [];
	for (var row in y_axis){
		matrix[row] = [];
		for (var col in x_axis){
			matrix[row][col] = 0
		}
	}
}

function HeatMap(data){
    var x = data.x;
    var y = data.y;

    var x_coord;
    var less = false;
    for (var i = x_axis.length - 1; i >= 0; i--) {
    	if (x == x_axis[i]){
    		x_coord = i;
    	}  else if (x < x_axis[i]){
    		less = true;
    	} else {
    		if (less){
    			x_coord = i;
    			break;
    		}
    	}
    };

    var y_coord;
    for (var i = y_axis.length - 1; i >= 0; i--) {
    	if (y == y_axis[i]){
    		y_coord = i;
    	}  else if (y < y_axis[i]){
    		y_coord = i;
    		break;
    	}
    };
    matrix[y_coord][x_coord] += 1;

	for (var row in matrix){
		for (var col in matrix[row]){
			if (matrix[row][col] > max){
				max = matrix[row][col];
			}
		}
	}
}

function OnHeatMapButton(){
	var heatmap = $.CreatePanel( "Panel", $.GetContextPanel(), "HeatMapScreen" );
	heatmap.BLoadLayout( "file://{resources}/layout/custom_game/heatmap.xml", false, false );
	GameEvents.SendEventClientSide("heatmapdata", {max : max, data : matrix, x_axis : x_axis, y_axis : y_axis});
}

function LoadData(stats_panel, type){
	var playerId = Game.GetLocalPlayerID();

	var stats_melee = stats_panel.FindChildInLayoutFile("stats_melee");
	var stats_ranged = stats_panel.FindChildInLayoutFile("stats_ranged");
	var stats_siege = stats_panel.FindChildInLayoutFile("stats_siege");
	//var stats_tower = stats_panel.FindChildInLayoutFile("stats_tower");

	if (type != "miss"){

		var melee = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_melee_" + type ).value;
		var missed_melee = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_melee_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
		var accuracy_melee = parseFloat(Math.round((missed_melee != 0 ? ((melee * 100) / (missed_melee + melee)) : 100)).toFixed(0)) + "% ";
		
		stats_melee.text = accuracy_melee + "(" + melee + " / " + (melee + missed_melee) + ")";

		var ranged = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_ranged_" + type ).value;
		var missed_ranged = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_ranged_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
		var accuracy_ranged = parseFloat(Math.round((missed_ranged != 0 ? ((ranged * 100) / (missed_ranged + ranged)) : 100)).toFixed(0)) + "% ";
		
		stats_ranged.text = accuracy_ranged + "(" + ranged + " / " + (ranged + missed_ranged) + ")";

		var siege = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_siege_" + type ).value;
		var missed_siege = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_siege_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
		var accuracy_siege = parseFloat(Math.round((missed_siege != 0 ? ((siege * 100) / (missed_siege + siege)) : 100)).toFixed(0)) + "% ";
		
		stats_siege.text = accuracy_siege + "(" + siege + " / " + (siege + missed_siege) + ")";

		//var tower = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_" + type ).value;
		//var missed_tower = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
		//stats_tower.text = tower + " / " + (tower + missed_tower);

	} else { //misses
		var cs_melee = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_melee_lh").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_melee_dn").value;
		var missed_melee = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_melee_" + type + "_friendly").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_melee_" + type + "_foe").value;
		var accuracy_melee = parseFloat(Math.round((missed_melee != 0 ? ((missed_melee * 100) / (missed_melee + cs_melee)) : 0)).toFixed(0)) + "% ";
		
		stats_melee.text = accuracy_melee + "(" + missed_melee + " / " + (missed_melee + cs_melee) + ")";


		var cs_ranged = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_ranged_lh").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_ranged_dn").value;
		var missed_ranged = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_ranged_" + type + "_friendly").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_ranged_" + type + "_foe").value;
		var accuracy_ranged = parseFloat(Math.round((missed_ranged != 0 ? ((missed_ranged * 100) / (missed_ranged + cs_ranged)) : 0)).toFixed(0)) + "% ";
		
		stats_ranged.text = accuracy_ranged + "(" + missed_ranged + " / " + (missed_ranged + cs_ranged) + ")";


		var cs_siege = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_siege_lh").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_siege_dn").value;
		var missed_siege = CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_siege_" + type + "_friendly").value + 
					CustomNetTables.GetTableValue( "stats_totals_details", playerId + "stats_totals_details_siege_" + type + "_foe").value;
		var accuracy_siege = parseFloat(Math.round((missed_siege != 0 ? ((missed_siege * 100) / (missed_siege + cs_siege)) : 0)).toFixed(0)) + "% ";
		
		stats_siege.text = accuracy_siege + "(" + missed_siege + " / " + (missed_siege + cs_siege) + ")";


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
	GameEvents.Subscribe("cancel", OnCancelServer);
	GameEvents.Subscribe("cleardata", OnClearData);
	GameEvents.Subscribe("heatmap", HeatMap);
	GameEvents.Subscribe("quit", OnQuit);
})();