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
            text = "Too early!";            
        } else if (msg > 0.50 && msg <= 0.75 ){
            text = "Not yet!";
        } else if (msg > 0.25 && msg <= 0.50){
            text = "Halfway there!";
        } else if (msg > 0.15 && msg <= 0.25){
            text = "Almost!";
        } else if (msg > 0.10 && msg <= 0.15){
            text = "*Heavy breating*";
        } else if (msg > 0.05 && msg <= 0.10){
            text = "*Heavy breating*";
        } else {
            txtLabel.style.animationName = "wobble";
            text = "*Heavy breating*";
            txtLabel.style.animationDuration = "0.5s";
            parentPanel.SetHasClass( "heavy_breathing", true );
            $.Schedule( 1.0, OnResetAnimation );
        }
    } else {
        text = "Missed!";
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