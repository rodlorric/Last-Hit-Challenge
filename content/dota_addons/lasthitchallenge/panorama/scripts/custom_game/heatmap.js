"use strict";

function OnQuit(){
	var heatmap = $.GetContextPanel();
	heatmap.DeleteAsync(0);
}


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
var max = 0;
function drawHeatMap(data){
	var matrix = data.data;
	max = data.max;
	var heatmappanel = $.GetContextPanel().FindChildInLayoutFile("heatmap_panel_detail");
	var heatmap = $.CreatePanel("Panel", heatmappanel, "heatmap");
	heatmap.AddClass("HeatmapPanelDetail");
	if (x_axis.length < y_axis.length){
   		heatmap.style.width = (y_axis.length-1)*20 + "px;";
   		heatmap.style.height = (y_axis.length-1)*20 + "px;";
	} else {
		heatmap.style.width = (x_axis.length-1)*20 + "px;";
   		heatmap.style.height = (x_axis.length-1)*20 + "px;";
	}
   	//heatmap.style.verticalAlign = "middle";
   	//heatmap.style.horizontalAlign = "center";
   	//heatmap.style.flowChildren = "down";
    
    //for (var row in matrix){
    //	var pixel_row = $.CreatePanel("Panel", heatmap,"row_"+row);
    //	pixel_row.width = "100%";
    //	pixel_row.height = y_axis.length/20 + "px";
    //	pixel_row.style.flowChildren = "right";
    //	for (var col in matrix[row]){
    //		var pixel = $.CreatePanel("Panel", pixel_row, "pixel_"+col);
    //		var value = matrix[row][col];
    //		//$.Msg("value = " + value + " Vs. max = " + max + " max*0.80 = " + max*0.80 + " max*0.60 = " + max*0.60 + " max*0.40 = " + max*0.40 + " max*0.20 = " + max*0.20);
    //		if (value <= max*0.20){
    //			pixel.style.backgroundColor = "#00FFFF";
    //		} else if (value <= max*0.40){
    //			pixel.style.backgroundColor = "#99FF33";    			
    //		} else if (value <= max*0.40){
    //			pixel.style.backgroundColor = "#FFFF00";
    //		} else if (value <= max*0.60){
    //			pixel.style.backgroundColor = "#FF6600";
    //		} else if (value <= max*0.80){
    //			pixel.style.backgroundColor = "#FF0000";
    //		} else {
    //			pixel.style.backgroundColor = "#990000";
    //		}
    //		pixel.style.width = "20px";
    //		pixel.style.height = "20px";
    //	}
    //}

   for (var row in matrix){
    	for (var col in matrix[row]){
    		var value = matrix[row][col];
    		if (value > 0){
	    		var pixel = $.CreatePanel("Panel", heatmap, "pixel_"+row+"_"+col);
	    		pixel.AddClass("HeatmapPixel");
	    		if (value <= max*0.20){
	    			pixel.style.backgroundColor = "#00FFFF";
	    		} else if (value <= max*0.40){
	    			pixel.style.backgroundColor = "#99FF33";    			
	    		} else if (value <= max*0.40){
	    			pixel.style.backgroundColor = "#FFFF00";
	    		} else if (value <= max*0.60){
	    			pixel.style.backgroundColor = "#FF6600";
	    		} else if (value <= max*0.80){
	    			pixel.style.backgroundColor = "#FF0000";
	    		} else {
	    			pixel.style.backgroundColor = "#990000";
	    		}
	    		pixel.style.marginTop = row*20 + "px;";
	    		pixel.style.marginLeft = col*20 + "px;";
    			//pixel.style.width = "20px";
    			//pixel.style.height = "20px";
    		}
    	};
    };
    //for (var row in matrix){
    //	for (var col in matrix[row]){
	//		var pixel = $.CreatePanel("Panel", heatmap, "pixel_"+col);
    //		var value = matrix[row][col];
    //		if (value != 0){
	//    		if (value <= max*0.20){
	//    			pixel.style.backgroundColor = "#00FFFF";
	//    		} else if (value <= max*0.40){
	//    			pixel.style.backgroundColor = "#99FF33";    			
	//    		} else if (value <= max*0.40){
	//    			pixel.style.backgroundColor = "#FFFF00";
	//    		} else if (value <= max*0.60){
	//    			pixel.style.backgroundColor = "#FF6600";
	//    		} else if (value <= max*0.80){
	//    			pixel.style.backgroundColor = "#FF0000";
	//    		} else {
	//    			pixel.style.backgroundColor = "#990000";
	//    		}
	//    		pixel.style.transform =  "translateX( " + (x_axis.length - row) * 20 + "px ) translateY( " + (y_axis.length - col) * 20 + "px );";
    //			pixel.style.width = "20px";
    //			pixel.style.height = "20px";
    //		}
    //	}
    //}

}

(function () {
	GameEvents.Subscribe("heatmapdata", drawHeatMap);
})();