//kind of working thanks to https://github.com/Perryvw/PanoramaUtils/
function Hurt2(data){
    var scale = $('#overlay').actuallayoutwidth / 1920;
    var msg = data.msg;
    var unitPos = Entities.GetAbsOrigin(data.index);
    var x = Game.WorldToScreenX( unitPos[0], unitPos[1], unitPos[2] );
    var y = Game.WorldToScreenY( unitPos[0], unitPos[1], unitPos[2] );

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
        text = $.Localize("#overlay_missed");
    }

    txtLabel.text = text;

    $.Msg(scale);
    txtHolderPanel.style.transform = "translate3d(" + ( (x * (1/scale)) - 100 ) + "px, " + ( (y * (1/scale)) - 100) + "px, 0px)";

    txtLabel.DeleteAsync(0.7);
    txtHolderPanel.DeleteAsync(0.7);
    $.Msg(unitPos);
}

var index = 0;
var marker = null;
function Hurt(data){
    var msg = data.msg;
    if (marker == null) {
        var marker = new Marker(data.index, "markerContainer" + index, msg);
    } else {
        marker.AddNew(data.index);
    }
    index++;
}

function OnResetAnimation(data) {
    var parentPanel = $.GetContextPanel();
    parentPanel.SetHasClass( "close_anim", false );
    parentPanel.SetHasClass( "heavy_breathing", false );
}

(function () {
	//$.GetContextPanel().visible = false;
    GameEvents.Subscribe("hurt_entity", Hurt);
})();