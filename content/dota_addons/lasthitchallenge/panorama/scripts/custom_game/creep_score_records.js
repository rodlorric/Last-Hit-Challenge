"use strict";
//--------------------------------------------------------------------------------------------------
// SubscribeNetTableListener allows you to be notified when any value in a table changes
//--------------------------------------------------------------------------------------------------
function OnCreepScoreRecordChanged( table_name, key, data )
{
	var new_record_panel = $.GetContextPanel();
	$.Msg( "Table ", table_name, " changed: '", key, "' = ", data );
	$("#cs").text = data["cs"]
	$("#lh").text = data["lh"]
	$("#dn").text = data["dn"]
	$.Msg('anim lh: ' + data["anim"]["lh"])
	$.Msg('anim dn: ' + data["anim"]["dn"])
	$.Msg('anim cs: ' + data["anim"]["cs"])
	if (data["anim"]["lh"] == true) {
		new_record_panel.SetHasClass( "lh_new_record", true );
	} 
	if (data["anim"]["dn"] == true) {
		new_record_panel.SetHasClass( "dn_new_record", true );
	}
	if (data["anim"]["cs"] == true) {
		new_record_panel.SetHasClass( "cs_new_record", true );
	}
} 

function OnResetAnimation(data) {
	var new_record_panel = $.GetContextPanel();
	$.Msg("OnResetAnimation!" + data["anim"])
	new_record_panel.SetHasClass( "lh_new_record", false );
	new_record_panel.SetHasClass( "dn_new_record", false );
	new_record_panel.SetHasClass( "cs_new_record", false );
}


(function () {
	CustomNetTables.SubscribeNetTableListener( "custom_creep_score_records", OnCreepScoreRecordChanged );
	GameEvents.Subscribe("reset_records_animation", OnResetAnimation);
})();