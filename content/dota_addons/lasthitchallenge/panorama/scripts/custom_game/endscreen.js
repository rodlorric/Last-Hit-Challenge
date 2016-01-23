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


//	//Totals
//	var stats_total_cs = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_cs" );
//	var stats_total_lh = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_lh" );
//	var stats_total_dn = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_dn" );
//	var stats_total_miss = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_miss");
//	var stats_total_accuracy = CustomNetTables.GetTableValue( "stats_totals", playerId + "stats_total_accuracy");
//	$("#stats_total_cs").text = stats_total_cs.value;
//	$("#stats_total_lh").text = stats_total_lh.value;
//	$("#stats_total_dn").text = stats_total_dn.value;
//	$("#stats_total_miss").text = stats_total_miss.value;
//	//$("#stats_total_accuracy").text = parseFloat(Math.round(stats_total_accuracy.value).toFixed(2)) + "%";
//	$("#stats_total_accuracy").text = stats_total_accuracy.value + "%";
//
//	//Streaks
//	var stats_streak_cs = CustomNetTables.GetTableValue( "stats_streaks", playerId + "stats_streak_cs" );
//	var stats_streak_lh = CustomNetTables.GetTableValue( "stats_streaks", playerId + "stats_streak_lh" );
//	var stats_streak_dn = CustomNetTables.GetTableValue( "stats_streaks", playerId + "stats_streak_dn" );
//	$("#stats_streak_cs").text = stats_streak_cs.value;
//	$("#stats_streak_lh").text = stats_streak_lh.value;
//	$("#stats_streak_dn").text = stats_streak_dn.value;
//
//	//Session Records
//	//var stats_record_cs = CustomNetTables.GetTableValue( "stats_records", "stats_record_cs_" + data.hero + "_" + data.time + "_" + data.level);
//	var stats_record_cs = CustomNetTables.GetTableValue( "stats_records", playerId + "c" + data.hero + data.maxtime + data.level);
//	//var stats_record_lh = CustomNetTables.GetTableValue( "stats_records", "stats_record_lh_" + data.hero + "_" + data.time + "_" + data.level);
//	var stats_record_lh = CustomNetTables.GetTableValue( "stats_records", playerId + "l" + data.hero + data.maxtime + data.level);
//	//var stats_record_dn = CustomNetTables.GetTableValue( "stats_records", "stats_record_dn_" + data.hero + "_" + data.time + "_" + data.level);
//	var stats_record_dn = CustomNetTables.GetTableValue( "stats_records", playerId + "d" + data.hero + data.maxtime + data.level);
//	//var stats_record_accuracy = CustomNetTables.GetTableValue( "stats_records", "stats_record_accuracy_" + data.hero + "_" + data.time + "_" + data.level);
//	var stats_record_accuracy = CustomNetTables.GetTableValue( "stats_records", playerId + "a" + data.hero + data.maxtime + data.level);
//	$("#stats_record_cs").text = stats_record_cs.value;
//	$("#stats_record_lh").text = stats_record_lh.value;
//	$("#stats_record_dn").text = stats_record_dn.value;
//	//$("#stats_record_accuracy").text = parseFloat(Math.round(stats_record_accuracy.value).toFixed(2)) + "%";
//	$("#stats_record_accuracy").text = stats_record_accuracy.value + "%";
//
//	var date = new Date(null);
//    date.setSeconds(data.maxtime); // specify value for SECONDS here
//    var minutes = date.toISOString().substr(14, 5);
//	$("#acc_record").text = $.Localize("#endscreen_acc_record") +  minutes + ")";
//
//	//Misc
//	var stats_misc_restart = CustomNetTables.GetTableValue( "stats_misc", playerId + "stats_misc_restart" );
//	var stats_misc_session_accuracy = CustomNetTables.GetTableValue( "stats_misc", playerId + "stats_misc_session_accuracy");
//	$("#stats_misc_restart").text = stats_misc_restart.value;
//	//$("#stats_misc_session_accuracy").text = parseFloat(Math.round(stats_misc_session_accuracy.value).toFixed(2)) + "%";
//	$("#stats_misc_session_accuracy").text = stats_misc_session_accuracy.value + "%";
//
//	//Time
//	var stats_time_spent = CustomNetTables.GetTableValue( "stats_time", playerId + "stats_time_spent" );
//	var stats_time_longest = CustomNetTables.GetTableValue( "stats_time", playerId + "stats_time_longest" );
//	var stats_time_shortest = CustomNetTables.GetTableValue( "stats_time", playerId + "stats_time_shortest" );
//	$("#stats_time_spent").text = stats_time_spent.value;
//	$("#stats_time_longest").text = stats_time_longest.value;
//	$("#stats_time_shortest").text = stats_time_shortest.value;

var maxtime = 0;
var leveling = "l";
var time = -1;
function OnEndScreen(data) {
	var playerId = Game.GetLocalPlayerID();
	maxtime = data.maxtime;
	leveling = data.level;

	var stats_total_cs_container = $("#stats_total_cs").Children();
	for (var i in stats_total_cs_container){
		stats_total_cs_container[i].DeleteAsync(0.0);
	}
	var stats_total_lh_container = $("#stats_total_lh").Children();
	for (var i in stats_total_lh_container){
		stats_total_lh_container[i].DeleteAsync(0.0);
	}
	var stats_total_dn_container = $("#stats_total_dn").Children();
	for (var i in stats_total_dn_container){
		stats_total_dn_container[i].DeleteAsync(0.0);
	}
	var stats_total_miss_container = $("#stats_total_miss").Children();
	for (var i in stats_total_miss_container){
		stats_total_miss_container[i].DeleteAsync(0.0);
	}

	var stats_total_accuracy_container = $("#stats_total_accuracy").Children();
	for (var i in stats_total_accuracy_container){
		stats_total_accuracy_container[i].DeleteAsync(0.0);
	}

	var stats_streak_cs_container = $("#stats_streak_cs").Children();
	for (var i in stats_streak_cs_container){
		stats_streak_cs_container[i].DeleteAsync(0.0);
	}

	var stats_streak_lh_container = $("#stats_streak_lh").Children();
	for (var i in stats_streak_lh_container){
		stats_streak_lh_container[i].DeleteAsync(0.0);
	}

	var stats_streak_dn_container = $("#stats_streak_dn").Children();
	for (var i in stats_streak_dn_container){
		stats_streak_dn_container[i].DeleteAsync(0.0);
	}

	var allplayersids = Game.GetAllPlayerIDs();

	for (var pid in allplayersids){		
		//Totals
		var stats_total_cs = CustomNetTables.GetTableValue( "stats_totals", pid + "stats_total_cs" );
		var stats_total_lh = CustomNetTables.GetTableValue( "stats_totals", pid + "stats_total_lh" );
		var stats_total_dn = CustomNetTables.GetTableValue( "stats_totals", pid + "stats_total_dn" );
		var stats_total_miss = CustomNetTables.GetTableValue( "stats_totals", pid + "stats_total_miss");
		var stats_total_accuracy = CustomNetTables.GetTableValue( "stats_totals", pid + "stats_total_accuracy");
		
		var stats_total_cs_container = $("#stats_total_cs");
		var stat_cs = $.CreatePanel("Label", stats_total_cs_container, "");
		stat_cs.text = allplayersids < 2 ? stats_total_cs.value : (Players.GetPlayerName(parseInt(pid)) + ": " + stats_total_cs.value);
		//$("#stats_total_lh").text = stats_total_lh.value;
		var stats_total_lh_container = $("#stats_total_lh");
		var stat_lh = $.CreatePanel("Label", stats_total_lh_container, "");
		stat_lh.text = stats_total_lh.value;
		//$("#stats_total_dn").text = stats_total_dn.value;
		var stats_total_dn_container = $("#stats_total_dn");
		var stat_dn = $.CreatePanel("Label", stats_total_dn_container, "");
		stat_dn.text = stats_total_dn.value;
		//$("#stats_total_miss").text = stats_total_miss.value;
		var stats_total_miss_container = $("#stats_total_miss");
		var stat_miss = $.CreatePanel("Label", stats_total_miss_container, "");
		stat_miss.text = stats_total_miss.value;
		//$("#stats_total_accuracy").text = parseFloat(Math.round(stats_total_accuracy.value).toFixed(2)) + "%";
		//$("#stats_total_accuracy").text = stats_total_accuracy.value + "%";
		var stats_total_accuracy_container = $("#stats_total_accuracy");
		var stat_accuracy = $.CreatePanel("Label", stats_total_accuracy_container, "");
		stat_accuracy.text = stats_total_accuracy.value + "%";

		//Streaks
		var stats_streak_cs = CustomNetTables.GetTableValue( "stats_streaks", pid + "stats_streak_cs" );
		var stats_streak_lh = CustomNetTables.GetTableValue( "stats_streaks", pid + "stats_streak_lh" );
		var stats_streak_dn = CustomNetTables.GetTableValue( "stats_streaks", pid + "stats_streak_dn" );

		var stats_streak_cs_container = $("#stats_streak_cs");
		var stat_streak_cs = $.CreatePanel("Label", stats_streak_cs_container, "");
		stat_streak_cs.text = allplayersids < 2 ? stats_streak_cs.value : (Players.GetPlayerName(parseInt(pid)) + ": " + stats_streak_cs.value);
		//$("#stats_streak_cs").text = stats_streak_cs.value;

		var stats_streak_lh_container = $("#stats_streak_lh");
		var stat_streak_lh = $.CreatePanel("Label", stats_streak_lh_container, "");
		stat_streak_lh.text = stats_streak_lh.value;
		//$("#stats_streak_lh").text = stats_streak_lh.value;

		var stats_streak_dn_container = $("#stats_streak_dn");
		var stat_streak_dn = $.CreatePanel("Label", stats_streak_dn_container, "");
		stat_streak_dn.text = stats_streak_dn.value;
		//$("#stats_streak_dn").text = stats_streak_dn.value;


	}
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

	//var allplayersids = [0,1];
	//var allplayerscolors = ["#3375ff", "#fe86c2"];
	//var allplayersids = [0];
	var stats_misc_history = [];
	var allplayerscolors = [];

	//var temp = [];
	//1 min
	//var stats_misc_history_p1 = [{lh : 1, dn : 1, time: 0}, {lh : 6, dn : 1, time: 30}];

	//P2
	//var stats_misc_history_p2 = [{lh : 1, dn : 1, time: 0}, {lh : 1, dn : 1, time: 30}];


	//10 mins
	//var stats_misc_history_p1 = [{lh : 3, dn : 3, time: 0}, {lh : 6, dn : 1, time: 30}, {lh : 4, dn : 1, time: 60}, {lh : 2, dn : 2, time: 90}, {lh : 2, dn : 1, time: 120}, {lh : 2, dn : 1, time: 150}, {lh : 3, dn : 2, time: 180}, {lh : 3, dn : 0, time: 210}, {lh : 3, dn : 0, time: 240},
	//{lh : 2, dn : 2, time: 270}, {lh : 2, dn : 1, time: 300}, {lh : 1, dn : 3, time: 330}, {lh : 1, dn : 2, time: 360}, {lh : 3, dn : 2, time: 390}, {lh : 3, dn : 2, time: 420}, {lh : 1, dn : 2, time: 450}, {lh : 4, dn : 2, time: 480}, {lh : 5, dn : 0, time: 510}, {lh : 2, dn : 1, time: 540},
	//{lh : 5, dn : 1, time: 570}, {lh : 3, dn : 0, time: 600}];

	//P2
	//var stats_misc_history_p2 = [{lh : 2, dn : 1, time: 0}, {lh : 4, dn : 1, time: 30}, {lh : 2, dn : 1, time: 60}, {lh : 3, dn : 2, time: 90}, {lh : 1, dn : 0, time: 120}, {lh : 4, dn : 0, time: 150}, {lh : 0, dn : 2, time: 180}, {lh : 2, dn : 0, time: 210}, {lh : 2, dn : 0, time: 240},
	//{lh : 2, dn : 2, time: 270}, {lh : 5, dn : 3, time: 300}, {lh : 1, dn : 2, time: 330}, {lh : 3, dn : 1, time: 360}, {lh : 3, dn : 3, time: 390}, {lh : 3, dn : 0, time: 420}, {lh : 1, dn : 2, time: 450}, {lh : 1, dn : 2, time: 480}, {lh : 3, dn : 2, time: 510}, {lh : 2, dn : 2, time: 540},
	//{lh : 2, dn : 4, time: 570}, {lh : 2, dn : 1, time: 600}];

	//temp.push(stats_misc_history_p1);
	//temp.push(stats_misc_history_p2);

	var y_legend = $("#YLegendPanel");

	var y_legend_children = y_legend.Children();
	for (var i in y_legend_children){
		y_legend_children[i].DeleteAsync(0.0);
	}

	$.Msg("y_legend = " + y_legend);

	for (var player in allplayersids){
		stats_misc_history.push(CustomNetTables.GetTableValue("stats_misc", player + "stats_misc_history"));
		//stats_misc_history.push(temp[player]);
		var p_color = Players.GetPlayerColor(parseInt(player)).toString(16);
		p_color = p_color.substring(6, 8) + p_color.substring(4, 6) + p_color.substring(2, 4) + p_color.substring(0, 2);
		allplayerscolors.push("#" + p_color);

		var PLegend = $.CreatePanel("Panel", y_legend, "");
		PLegend.AddClass("LHLegend");
		PLegend.style.backgroundColor = allplayerscolors[player] + ";";
		var PLegendLabel = $.CreatePanel("Label", PLegend, "LegendLabel");
		PLegendLabel.text = "P" + (parseInt(player) + 1);		

		PLegend.SetPanelEvent("onmouseover", function showTooltip() { $.DispatchEvent("DOTAShowTextTooltip", PLegend, Players.GetPlayerName(parseInt(player)) ) });
		PLegend.SetPanelEvent("onmouseout", function() {$.DispatchEvent("DOTAHideTextTooltip", PLegend)});



		var LHLegend = $.CreatePanel("Panel", y_legend, "");
		LHLegend.AddClass("LHLegend");
		LHLegend.style.backgroundColor = allplayerscolors[player] + ";";
		LHLegend.SetPanelEvent("onmouseover", function showTooltip() { $.DispatchEvent("DOTAShowTextTooltip", LHLegend, $.Localize("#endscreen_last_hits"))});
		LHLegend.SetPanelEvent("onmouseout", function() {$.DispatchEvent("DOTAHideTextTooltip", LHLegend)});
		var LHLegendLabel = $.CreatePanel("Label", LHLegend, "LegendLabel");
		LHLegendLabel.text = $.Localize("#endscreen_lh");
		var DNLegend = $.CreatePanel("Panel", y_legend, "");
		DNLegend.AddClass("DNLegend");
		DNLegend.style.backgroundColor = ColorLuminance(allplayerscolors[player],-0.5) + ";"
		DNLegend.SetPanelEvent("onmouseover", function showTooltip() { $.DispatchEvent("DOTAShowTextTooltip", DNLegend, $.Localize("#endscreen_denies"))});
		DNLegend.SetPanelEvent("onmouseout", function() {$.DispatchEvent("DOTAHideTextTooltip", DNLegend)});
		var DNLegendLabel = $.CreatePanel("Label", DNLegend, "LegendLabel");
		DNLegendLabel.text = $.Localize("#endscreen_dn");
	}

	//var history_p1 = stats_misc_history[0];
    //var output = '';
    // for (var property in history_p1) {
    // 		$.Msg("property = " + property);
    // 		var obj = history_p1[property];
    // 		for (var prop in obj){
    //   			output += prop + ': ' + obj[prop] + '; ';
    //   		}
    // }
    // $.Msg(output);

	//var stats_misc_history_p1 = CustomNetTables.GetTableValue("stats_misc", playerId + "stats_misc_history");

	var bar_container = $("#graph_container");
	var x_legend = $("#x_legend");

	var graph_children = bar_container.Children();
	for (var i in graph_children){
		graph_children[i].DeleteAsync(0.0);
	}

	var x_legend = x_legend.Children();
	for (var i in x_legend){
		x_legend[i].DeleteAsync(0.0);
	}

	var max = 1;
	var timeacum = 30;


	//var stats_misc_history_p2 = [];

	//stats_misc_history_p1 = [{lh : 0, dn : 1, time: 0}, {lh : 6, dn : 1, time: 30}];
	//var stats_misc_history_p2 = [{lh : 6, dn : 1, time: 0}, {lh : 1, dn : 1, time: 30}];

	//7:30 mins
	//stats_misc_history_p1 = [{lh : 0, dn : 0}, {lh : 1, dn : 1}, {lh : 3, dn : 1}, {lh : 2, dn : 2}, {lh : 9, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 3, dn : 1}, {lh : 2, dn : 0},
	//{lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 3, dn : 2}, {lh : 1, dn : 2}, {lh : 1, dn : 2}];

	//5 mins
	//stats_misc_history_p1 = [{lh : 0, dn : 0}, {lh : 1, dn : 1}, {lh : 3, dn : 1}, {lh : 2, dn : 2}, {lh : 8, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 3, dn : 1}, {lh : 2, dn : 0},
	//{lh : 2, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}];

	//2 mins
	//stats_misc_history_p1 = [{lh : 0, dn : 0}, {lh : 1, dn : 1}, {lh : 3, dn : 1}, {lh : 2, dn : 2}, {lh : 8, dn : 2}, {lh : 2, dn : 2}, {lh : 2, dn : 2}];

	$.Msg(stats_misc_history.length);
	for (var i in stats_misc_history[0]) {
		var lh_p1 = stats_misc_history[0][i].lh;
		var dn_p1 = stats_misc_history[0][i].dn;

		var lh_p2 = 0;
		var dh_p2 = 0;

		//$.Msg("stats_history length = " + stats_misc_history.length);
		if (stats_misc_history.length > 1){
			lh_p2 = stats_misc_history[1][i].lh;
			dn_p2 = stats_misc_history[1][i].dn;
		}

		if ((lh_p1 > max) || (lh_p2 > max)){
			max = lh_p1 > lh_p2 ? lh_p1 : lh_p2;
		}

		if ((dn_p1 > max) || (dn_p2 > max)){
			max = dn_p1 > dn_p2 ? dn_p1 : lh_p2;
		}
		//if (lh > max){
		//	max = lh;
		//}
		//if (dn > max){
		//	max = dn;
		//}
		//$.Msg("Max = " + max);
	}
	for (var j in stats_misc_history[0]) {
		//if (j > 1){
			var lh_p1 = stats_misc_history[0][j].lh;
			var dn_p1 = stats_misc_history[0][j].dn
			var date = new Date(null);

			var lh_p2 = -1;
			var dn_p2 = -1;

			if (stats_misc_history.length > 1){
				lh_p2 = stats_misc_history[1][j].lh;
				dn_p2 = stats_misc_history[1][j].dn;
			}

			var lh_tie = (lh_p1 == lh_p2);
			var dn_tie = (dn_p1 == dn_p2);

			if (lh_p2 == -1 && dn_p2 == -1){
				lh_p2 = 0;
				dn_p2 = 0;	
			}
	    	//date.setSeconds(timeacum); // specify value for SECONDS here
	    	//var minutes = date.toISOString().substr(14, 5);
			//timeacum += 30;
			date.setSeconds(stats_misc_history[0][j].time); // specify value for SECONDS here
	    	var minutes = date.toISOString().substr(14, 5);
	  		
			var data_container = $.CreatePanel("Panel", bar_container, "data_container");		
			var couple_container = $.CreatePanel("Panel", data_container, "cs_container");

			//LAST HITS
			var bar_superholder = $.CreatePanel("Panel", couple_container, "BarSuperHolder");

			var maxval = (lh_p1 > lh_p2 ? lh_p1 : lh_p2);
			var minval = (lh_p1 < lh_p2 ? lh_p1 : lh_p2);
			var maxvalplayer = (maxval == lh_p1 ? 0 : 1);
			var minvalplayer = (maxvalplayer == 0 ? 1 : 0);


			var ypct = Math.round((maxval * 100)/max);
			var max_y = Math.round((ypct * 160) / 100);
			var ypct = Math.round((minval * 100)/max);
			var min_y = Math.round((ypct * 160) / 100);

			//bar_superholder.style.height = max_y + "px;";
			bar_superholder.style.height = "160px;";
			////$.Msg(">>> Greater = " + (lh < lh_p2 ? lh : lh_p2) + "<<<");

			var bar_holder = $.CreatePanel("Panel", bar_superholder, "BarHolder");
			bar_holder.style.opacity = "1.0";
	  		var height = (lh_tie ? max_y : (max_y - min_y));
	  		var bar = $.CreatePanel( "Panel", bar_holder, "BarLH");
	  		
	  		if (height != 0){
				bar_holder.style.height = height + "px;";
	  			bar.style.height = height + "px;";
	  			bar.style.backgroundColor = lh_tie ? "dimgray" : allplayerscolors[maxvalplayer] + ";";
	  		} else {
	  			bar_holder.style.height ="30px;";
	  			bar.style.height = "30px;";
	  		}

	  		var label = $.CreatePanel("Label", bar, "");
	  		label.text = maxval;
	  		label.style.verticalAlign = "top;";
	  		label.style.textAlign = "center;";
	  		
	  		if (allplayersids.length > 1){
		  		var bar_holder = $.CreatePanel("Panel", bar_superholder, "BarHolder");
				bar_holder.style.opacity = "1.0";
		  		var bar = $.CreatePanel( "Panel", bar_holder, "BarLH");
		  		if (min_y != 0){
					bar_holder.style.height = min_y + "px;";
		  			bar.style.backgroundColor =  lh_tie ? "dimgray" : allplayerscolors[minvalplayer] + ";";
		  			bar.style.height = min_y + "px;";
		  		} else {
		  			bar_holder.height = "30px;";
		  			bar.style.height = "30px;";
		  		}

		  		var label = $.CreatePanel("Label", bar, "");
		  		label.text = minval;
		  		label.style.verticalAlign = "top;";
		  		label.style.textAlign = "center;";
	  		}


	  		//DENIES
	  		var bar_superholder = $.CreatePanel("Panel", couple_container, "BarSuperHolder");

			var maxval = (dn_p1 > dn_p2 ? dn_p1 : dn_p2);
			var minval = (dn_p1 < dn_p2 ? dn_p1 : dn_p2);
			//$.Msg("maxval = " + maxval + ", minval = " + minval);
			//var maxvalplayer = (maxval == dn_p1 ? "P1" : "P2");
			//var minvalplayer = (maxvalplayer == "P1" ? "P2" : "P1");
			var maxvalplayer = (maxval == dn_p1 ? 0 : 1);
			var minvalplayer = (maxvalplayer == 0 ? 1 : 0);

			var dn_tie = (dn_p1 == dn_p2);
			//$.Msg("dn_tie? = " + dn_tie);
			//$.Msg("maxval = " + maxval + ", minval = " + minval);


			var ypct = Math.round((maxval * 100)/max);
			var max_y = Math.round((ypct * 160) / 100);
			var ypct = Math.round((minval * 100)/max);
			var min_y = Math.round((ypct * 160) / 100);
			//$.Msg("max_y = " + max_y + ", min_y = " + min_y);

			//bar_superholder.style.height = max_y + "px;";
			bar_superholder.style.height = "160px;";
			////$.Msg(">>> Greater = " + (dn < dn_p2 ? dn : dn_p2) + "<<<");

			var bar_holder = $.CreatePanel("Panel", bar_superholder, "BarHolder");
			bar_holder.style.opacity = "1.0";
	  		var height = (dn_tie ? max_y : (max_y - min_y));
	  		var bar = $.CreatePanel( "Panel", bar_holder, "BarDN");
	  		if (height != 0){
				bar_holder.style.height = height + "px;";
	  			bar.style.backgroundColor = dn_tie ? "grey" : ColorLuminance(allplayerscolors[maxvalplayer],-0.5) + ";";	  			
	  			bar.style.height = height + "px;";
	  		} else {
		  			bar_holder.height = "30px;";
		  			bar.style.height = "30px;";
		  	}

	  		var label = $.CreatePanel("Label", bar, "");
	  		label.text = maxval;
	  		label.style.verticalAlign = "top;";
	  		label.style.textAlign = "center;";
	  		
	  		if (allplayersids.length > 1){
		  		var bar_holder = $.CreatePanel("Panel", bar_superholder, "BarHolder");
				bar_holder.style.opacity = "1.0";
		  		var bar = $.CreatePanel( "Panel", bar_holder, "BarDN");
		  		if ( min_y != 0){
					bar_holder.style.height = min_y + "px;";
			  		bar.style.backgroundColor =  dn_tie ? "grey" : ColorLuminance(allplayerscolors[minvalplayer],-0.5) + ";";
			  		bar.style.height = min_y + "px;";
		  		} else {
		  			bar_holder.style.height = "30px;";
		  			bar.style.height = "30px;";
		  		}
		  		//$.Msg("2 height = " + min_y);

		  		var label = $.CreatePanel("Label", bar, "");
		  		label.text = minval;
		  		label.style.verticalAlign = "top;";
		  		label.style.textAlign = "center;";
	  		}


	  		var x_hor_bar = $.CreatePanel("Panel", data_container, "HorBar");
	  		var x_label = $.CreatePanel("Label", data_container, "XLegendLabel");
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

	var x_legend = $("#x_legend").Children();
	for (var i in x_legend){
		x_legend[i].RemoveAndDeleteChildren();
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
		var localPlayer = Game.GetPlayerInfo(Game.GetLocalPlayerID());
    	$.Msg(localPlayer);
    	if (localPlayer['player_has_host_privileges']){
			var timescreen = $.CreatePanel( "Panel", $.GetContextPanel(), "TimeScreen" );
			timescreen.BLoadLayout( "file://{resources}/layout/custom_game/timescreen.xml", false, false );
		}
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

function SteamID32to64(steamid32){
	return '765' + (parseInt(steamid32) + 61197960265728);
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

//thanks to http://www.sitepoint.com/javascript-generate-lighter-darker-color/
function ColorLuminance(hex, lum) {
	// validate hex string
	hex = String(hex).replace(/[^0-9a-f]/gi, '');
	if (hex.length < 6) {
		hex = hex[0]+hex[0]+hex[1]+hex[1]+hex[2]+hex[2];
	}
	lum = lum || 0;

	// convert to decimal and change luminosity
	var rgb = "#", c, i;
	for (i = 0; i < 3; i++) {
		c = parseInt(hex.substr(i*2,2), 16);
		c = Math.round(Math.min(Math.max(0, c + (c * lum)), 255)).toString(16);
		rgb += ("00"+c).substr(c.length);
	}
	return rgb;
}

function LoadData(stats_panel, type){
	var playerId = Game.GetLocalPlayerID();
	var playerIdP2 = null;
	var allplayersids = Game.GetAllPlayerIDs();

	var stats_melee = stats_panel.FindChildInLayoutFile("stats_melee");
	var stats_ranged = stats_panel.FindChildInLayoutFile("stats_ranged");
	var stats_siege = stats_panel.FindChildInLayoutFile("stats_siege");

	for (var p in allplayersids){
		var melee_text = "0";
		var ranged_text = "0";
		var siege_text = "0";

		if (type != "miss"){

			var melee = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_melee_" + type ).value;
			var missed_melee = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_melee_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
			var accuracy_melee = parseFloat(Math.round((missed_melee != 0 ? ((melee * 100) / (missed_melee + melee)) : 100)).toFixed(0)) + "% ";			
			melee_text = accuracy_melee + "(" + missed_melee + " / " + (melee + missed_melee) + ")";

			var ranged = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_ranged_" + type ).value;
			var missed_ranged = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_ranged_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
			var accuracy_ranged = parseFloat(Math.round((missed_ranged != 0 ? ((ranged * 100) / (missed_ranged + ranged)) : 100)).toFixed(0)) + "% ";			
			ranged_text = accuracy_ranged + "(" + ranged + " / " + (ranged + missed_ranged) + ")";

			var siege = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_siege_" + type ).value;
			var missed_siege = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_siege_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
			var accuracy_siege = parseFloat(Math.round((missed_siege != 0 ? ((siege * 100) / (missed_siege + siege)) : 100)).toFixed(0)) + "% ";
			siege_text = accuracy_siege + "(" + siege + " / " + (siege + missed_siege) + ")";

			//var tower = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_" + type ).value;
			//var missed_tower = CustomNetTables.GetTableValue( "stats_totals_details", "stats_totals_details_tower_miss_" + ((type == "lh") ? "foe" : "friendly")).value;
			//stats_tower.text = tower + " / " + (tower + missed_tower);

		} else { //misses
			var cs_melee = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_melee_lh").value + 
						CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_melee_dn").value;
			var missed_melee = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_melee_" + type + "_friendly").value + 
						CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_melee_" + type + "_foe").value;
			var accuracy_melee = parseFloat(Math.round((missed_melee != 0 ? ((missed_melee * 100) / (missed_melee + cs_melee)) : 0)).toFixed(0)) + "% ";
			melee_text = accuracy_melee + "(" + missed_melee + " / " + (missed_melee + cs_melee) + ")";

			var cs_ranged = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_ranged_lh").value + 
						CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_ranged_dn").value;
			var missed_ranged = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_ranged_" + type + "_friendly").value + 
						CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_ranged_" + type + "_foe").value;
			var accuracy_ranged = parseFloat(Math.round((missed_ranged != 0 ? ((missed_ranged * 100) / (missed_ranged + cs_ranged)) : 0)).toFixed(0)) + "% ";
			ranged_text = accuracy_ranged + "(" + missed_ranged + " / " + (missed_ranged + cs_ranged) + ")";


			var cs_siege = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_siege_lh").value + 
						CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_siege_dn").value;
			var missed_siege = CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_siege_" + type + "_friendly").value + 
						CustomNetTables.GetTableValue( "stats_totals_details", p + "stats_totals_details_siege_" + type + "_foe").value;
			var accuracy_siege = parseFloat(Math.round((missed_siege != 0 ? ((missed_siege * 100) / (missed_siege + cs_siege)) : 0)).toFixed(0)) + "% ";
			siege_text = accuracy_siege + "(" + missed_siege + " / " + (missed_siege + cs_siege) + ")";
		}

		var playername = Players.GetPlayerName(parseInt(p));

		var playercontainer = $.CreatePanel("Panel", stats_melee, "");
		playercontainer.AddClass("PlayerContainer");
		if (allplayersids > 1){
			var player = $.CreatePanel("Label", playercontainer, "");
			player.AddClass("PlayerName");
			player.text = playername;
		}
		var stats_melee_label = $.CreatePanel("Label", playercontainer, "");			
		stats_melee_label.text = melee_text;

		playercontainer = $.CreatePanel("Panel", stats_ranged, "");
		playercontainer.AddClass("PlayerContainer");
		if (allplayersids > 1){
			var player = $.CreatePanel("Label", playercontainer, "");
			player.AddClass("PlayerName");
			player.text = playername;
		}
		var stats_ranged_label = $.CreatePanel("Label", playercontainer, "");
		stats_ranged_label.text = ranged_text;

		playercontainer = $.CreatePanel("Panel", stats_siege, "");
		playercontainer.AddClass("PlayerContainer");
		if (allplayersids > 1){
			player = $.CreatePanel("Label", playercontainer, "");
			player.AddClass("PlayerName");
			player.text = playername;
		}
		var stats_siege_label = $.CreatePanel("Label", playercontainer, "");
		stats_siege_label.text = siege_text;
	}

	var team = Entities.GetTeamNumber(Players.GetPlayerHeroEntityIndex(0));
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

	var localPlayer = Game.GetPlayerInfo(Game.GetLocalPlayerID());
     if (!localPlayer['player_has_host_privileges']){
    	$("#change_hero_button").enabled = false;
    	$("#change_hero_button").checked = true;
    	$("#change_time_button").enabled = false;
    	$("#change_time_button").checked = true;
		$("#restart_button").enabled = false;
		$("#restart_button").checked = true;
    }
})();