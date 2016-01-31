"use strict";
var time = -2;
var heroId = null;
var leveling = null;

function OnPick(time){
    GameEvents.SendCustomGameEventToServer( "new_pick", { "playerId" : Game.GetLocalPlayerID(), "time" : time});

    var wait = $.CreatePanel( "Panel", $.GetContextPanel(), "WaitPanel" );
    wait.BLoadLayout( "file://{resources}/layout/custom_game/wait.xml", false, false );
    var dialog =  wait.FindChildInLayoutFile("wait_dialog");

    var allplayersids = Game.GetAllPlayerIDs();
    for (var pid in allplayersids){
        if (pid != Game.GetLocalPlayerID()){
            var playername = Players.GetPlayerName(parseInt(pid));
            dialog.SetDialogVariable( "player", playername );
            break;
        }
    }
}

function OnTimePicked(data){
    $.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(data){
    heroId = data.heroId;
    leveling = data.leveling;
}

function OnStart(data){    
    var localPlayer = Game.GetPlayerInfo(Game.GetLocalPlayerID());
    if (localPlayer['player_has_host_privileges']){
        if (!$("#TimeScreenPanel").BHasClass("Minimized")){
            $("#TimeScreenPanel").ToggleClass("Minimized");
            $("#WaitPanel").DeleteAsync(0);
        }
    }
    $("#TimeChat").style.visibility = "collapse;";
    $("#TimeScreen").hittest = false;
}

function OnNewPick(data){
    if (data.value == "time"){
        $("#TimeScreen").hittest = true;

        var localPlayer = Game.GetPlayerInfo(Game.GetLocalPlayerID());
        if (localPlayer['player_has_host_privileges']){
            $("#TimeScreenPanel").ToggleClass("Minimized");
        } else {
           var wait = $.CreatePanel( "Panel", $.GetContextPanel(), "WaitPanel" );
            wait.BLoadLayout( "file://{resources}/layout/custom_game/wait.xml", false, false );
            var dialog =  wait.FindChildInLayoutFile("wait_dialog");
            
            for (var pid in allplayersids){
                if (pid != Game.GetLocalPlayerID()){
                    var playername = Players.GetPlayerName(parseInt(pid));
                    dialog.SetDialogVariable( "player", playername );
                    break;
                }
            } 
        }

        //reenables chat only if 1v1
        var allplayersids = Game.GetAllPlayerIDs();
        if (allplayersids.length > 1){
            $("#TimeChat").style.visibility = "visible;";
        }
    }
}


function OnSync(){
    time = 1;
}

function HideChat(){
    var chat = $("#TimeChat");
    if (chat.BHasClass("ChatExpanded")){
        chat.ToggleClass("ChatExpanded");
    }
}


function OnBack(){
    if (time == 1){
        GameEvents.SendCustomGameEventToServer("restart", {});
    }
    OnNewPick({ "value" : "time"});
}

(function () {
    GameEvents.Subscribe("time_picked_server", OnTimePicked);
    GameEvents.Subscribe("hero_picked", OnHeroPicked);
    GameEvents.Subscribe("start", OnStart);
    GameEvents.Subscribe("sync", OnSync);
    GameEvents.Subscribe("new_pick", OnNewPick);

    //disable chat if single player
    var allplayersids = Game.GetAllPlayerIDs();
    if (allplayersids.length == 1){
        $("#TimeChat").style.visibility = "collapse;";
    }
})();