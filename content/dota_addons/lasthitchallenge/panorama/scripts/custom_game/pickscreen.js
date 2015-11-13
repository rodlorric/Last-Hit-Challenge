"use strict";

var HEROES_PER_ROW = 11;
var hero = { "hero" : "nevermore" };

function OnPick(id) {
    hero = { "hero" : id }
	var timescreen = $.CreatePanel( "Panel", $.GetContextPanel(), "TimeScreen" );
	timescreen.BLoadLayout( "file://{resources}/layout/custom_game/timescreen.xml", false, false );
    var toggleButton = $("#disable_leveling");
    GameEvents.SendEventClientSide("hero_picked", {hero : id, leveling : toggleButton.checked})
    GameEvents.SendCustomGameEventToServer( "disable_leveling", { "disable_leveling" : toggleButton.checked });
    //GameEvents.SendEventClientSide("hero_picked", {})
    //$.GetContextPanel().DeleteAsync(0);
}

function OnHeroPicked(data){
	if (data.hero == null){
        if (!data.repick){
            $.GetContextPanel().DeleteAsync(0);
           GameEvents.SendCustomGameEventToServer( "hero_picked", hero);
        }
    }
}

var label = null;
function LevelingShowTooltip(){
    var togglebutton = $("#disable_leveling");
    togglebutton.text = $.Localize( "disable_leveling_tooltip" );
}

function LevelingHideTooltip(){
    var togglebutton = $("#disable_leveling");
    togglebutton.text = $.Localize( "#disable_leveling" );
}

(function () {
    var heroes = CustomNetTables.GetAllTableValues( "hero_selection" );
    if (heroes.length < HEROES_PER_ROW){
        HEROES_PER_ROW = heroes.length;
    }
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
    LevelingHideTooltip();
    GameEvents.Subscribe("hero_picked", OnHeroPicked);
    //var rows = hero_list.length / HEROES_PER_ROW;
    var rows = heroes.length / HEROES_PER_ROW;
    for (var i = 0; i < rows; i++) {
        var pickpanelcontainer = $.CreatePanel( "Panel", $("#pickscreenpanelsupercontainer"), "PickPanelContainer_" + i );
        pickpanelcontainer.AddClass("PickPanelContainer");
        for (var j = 0; j < HEROES_PER_ROW; j++) {    

            var index = (i * HEROES_PER_ROW) + j;
            var pickpanel = $.CreatePanel("Panel", pickpanelcontainer, "pickpanel_" + index);
            pickpanel.AddClass("PickPanel");
            var pickbutton = $.CreatePanel("Button", pickpanel, "pickbutton_" + index);
            pickbutton.AddClass("PickButton");           
            var heroPick = (function(id) {
                return function() {
                    OnPick(id);
                }
            } (heroes[index].key));
            pickbutton.SetPanelEvent("onactivate", heroPick);
            var img = $.CreatePanel("Panel", pickbutton, heroes[index].value.hero + "_bg");
            img.AddClass("HeroPanel");
            if (heroes[index].value.hero != "npc_dota_hero_techies"){
                var heroimage = $.CreatePanel("DOTAHeroImage", img, heroes[index].value.hero);
                heroimage.heroname = heroes[index].value.hero;
            } else {
                var heroimage = $.CreatePanel("Panel", img, heroes[index].value.hero + "_bg");
                img.AddClass("Satyr");
                img.style.width = "128px";
                img.style.height = "72px";
                img.style.backgroundImage = 'url("file://{images}/pickscreen/' + heroes[index].value.hero + '.png");';
                img.style.backgroundPosition = "0% 0%;";
                img.style.backgroundSize = "contain";
                img.style.backgroundRepeat = "no-repeat;";
            }

            var label = $.CreatePanel("Label", pickbutton, "label_" + index);
            label.text = heroes[i*HEROES_PER_ROW+j].value.hero;
            label.hittest = false;

            //img.style.width = "100%;";
            //img.style.height = "100%;";
            //img.style.backgroundImage = 'url("file://{images}/pickscreen/' + heroes[index].value.hero.substr(14) + "_bg" + '.jpg");';
            //img.style.backgroundPosition = "50% 0%;";
            //img.style.backgroundSize = "cover;";
            //img.style.backgroundRepeat = "no-repeat;";

        };

    };
})();