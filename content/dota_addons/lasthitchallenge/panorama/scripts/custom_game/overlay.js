"use strict";
function Overlay(data) {	

    var x = Math.floor(Game.WorldToScreenX( data["x"], data["y"], data["z"]));
    var y = Math.floor(Game.WorldToScreenY( data["x"], data["y"], data["z"]));
    var msg = data["msg"];
    $.Msg("(x,y) = ("+x+","+y+")");
    var parentPanel = $.GetContextPanel(); // the root panel of the current XML context
    var txtHolderPanel = $.CreatePanel( "Panel", parentPanel, "txtHolder");
    txtHolderPanel.hittest = false;

    var txtLabel = $.CreatePanel( "Label", txtHolderPanel, "txt");
    txtLabel.class = ".txt"

    var text;
    parentPanel.SetHasClass( "close_anim", true );
    if (msg != "missed"){        
        if (msg > 0.75){
            text = $.Localize( "#overlay_very_low" );
        } else if (msg > 0.50 && msg <= 0.75 ){
            text = $.Localize( "#overlay_low" );
        } else if (msg > 0.25 && msg <= 0.50){
            text = $.Localize( "#overlay_medium" );
        } else if (msg > 0.15 && msg <= 0.25){
            text = $.Localize( "#overlay_high" );
        } else if (msg > 0.10 && msg <= 0.15){
            text = $.Localize( "#overlay_very_high" );
        } else if (msg > 0.05 && msg <= 0.10){
            text = $.Localize( "#overlay_heavy_breathing" );
        } else {
            txtLabel.style.animationName = "wobble";
            text = $.Localize( "#overlay_heavy_breathing" );
            txtLabel.style.animationDuration = "0.5s";
            parentPanel.SetHasClass( "heavy_breathing", true );
            $.Schedule( 1.0, OnResetAnimation );
        }
    } else {
        text = "#overlay_missed";
    }

    txtLabel.text = text;

    txtHolderPanel.style.x = x + "px";
    txtHolderPanel.style.y = y + "px";
    txtHolderPanel.style.z = "0px";

    $.Msg("txtHolderPanel.style.position = " + txtHolderPanel.style.position );
    

    txtLabel.DeleteAsync(0.7);
    txtHolderPanel.DeleteAsync(0.7);
}

function OnResetAnimation(data) {
    var parentPanel = $.GetContextPanel();
    parentPanel.SetHasClass( "close_anim", false );
    parentPanel.SetHasClass( "heavy_breathing", false );
}

(function () {
	//$.GetContextPanel().visible = false;
	GameEvents.Subscribe("overlay", Overlay);
})();