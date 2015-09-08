"use strict";
function Overlay(data) {	
	/*
    //overlayPanel.visible = true;
    var x = Game.WorldToScreenX( data["x"], data["y"], data["z"]);
    var y = Game.WorldToScreenY( data["x"], data["y"], data["z"]);
    $.Msg("x = " + x + ", y = " + y);
    //overlayPanel.style.position = x + "px " + y + "px 0px"
    overlayPanel.style.left = x + "px";
    overlayPanel.style.top = y + "px";
    */
    var x = Math.floor(Game.WorldToScreenX( data["x"], data["y"], data["z"]));
    var y = Math.floor(Game.WorldToScreenY( data["x"], data["y"], data["z"]));
    var pct = data["pct"];
    $.Msg('Percentage = ' + pct)
    $.Msg("(x,y) = ("+x+","+y+")");
    var parentPanel = $.GetContextPanel(); // the root panel of the current XML context
    var txtHolderPanel = $.CreatePanel( "Panel", parentPanel, "txtHolder" );
    $.Msg('hittest before: ' + txtHolderPanel.hittest);
    txtHolderPanel.hittest = false;
    $.Msg('hittest after: ' + txtHolderPanel.hittest);
    var txtLabel = $.CreatePanel( "Label", txtHolderPanel, "txt" );
    var text;
    if (pct > 0.75){
        text = "Too early!";
        parentPanel.SetHasClass( "close_anim", true );
    } else if (pct > 0.50 && pct <= 0.75 ){
        text = "Not yet!";
        parentPanel.SetHasClass( "close_anim", true );
    }
    else if (pct > 0.25 && pct <= 0.50){
        text = "Halfway there!";
        parentPanel.SetHasClass( "close_anim", true );
    }
    else if (pct > 0.15 && pct <= 0.25){
        text = "Almost!";
        parentPanel.SetHasClass( "close_anim", true );
    }
    else if (pct > 0.10 && pct <= 0.15){
        text = "*Heavy breating*";
        parentPanel.SetHasClass( "close_anim", true );
    }
    else if (pct > 0.05 && pct <= 0.10){
        text = "*Heavy breating*";
        parentPanel.SetHasClass( "heavy_breathing", true );
    }
    else{
        text = "*Heavy breating*";
        txtLabel.style.animationDuration = "0.5s";
        txtLabel.style.animationIterationCount = "infinite";
        parentPanel.SetHasClass( "heavy_breathing", true );
    }
    txtLabel.text = text;
    /*txtHolderPanel.style.position = x + "px " + y + "px 0px";*/
    txtHolderPanel.style.x = x + "px";
    txtHolderPanel.style.y = y + "px";
    txtHolderPanel.style.y = "0px";
    /*
    txtHolderPanel.style.x = "1700px";
    txtHolderPanel.style.y = "1048px";
    txtHolderPanel.style.z = "0px";
    */
    $.Msg("txtHolderPanel.style.position = " + txtHolderPanel.style.position );

    

    txtLabel.DeleteAsync(1.0);
    txtHolderPanel.DeleteAsync(1.0);
   $.Schedule( 1, OnResetAnimation );
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