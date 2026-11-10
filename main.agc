// ============================================================================
//  HOPEAVIRTA - KEHAN KILTA
//  Gladiaattoripeli myohaiskeskiaikaisessa fantasiakaupungissa.
//  Saannot: Pathfinder Second Edition (Remaster), ORC-lisenssi.
//  AppGameKit Tier 1 (BASIC), kaikki grafiikka AGK:n omalla moottorilla.
//
//  Moduulit (kaikki samassa projektikansiossa):
//    core_defs.agc      vakiot, tyypit, globaalit
//    core_util.agc      satunnaisuus, matematiikka, merkkijonot, valuutta
//    core_ui.agc        immediate-mode UI (sprite-laatat + tekstiobjektit)
//    rules_pf2e.agc     PF2E:n saannot ja taso-taulukot
//    data_gear.agc      aseet, panssarit, juomat, riimut
//    data_world.agc     esi-isat, luokat, hirvioet, nimet, maailma
//    fighters.agc       taistelijoiden luonti ja johdetut arvot
//    economy.agc        markkinat, portti, vedonlyonti, viikkokierto
//    combat_core.agc    taistelun saannot ja toiminnot
//    combat_ai.agc      vihollisten tekoaly
//    combat_ui.agc      taistelunakyma
//    screens_manage.agc otsikko, kilta, rekrytointi, kauppa, tilat, talous
//    screens_arena.agc  areena, tulokset, loppu
//    save_load.agc      tallennus
// ============================================================================

#include "core_defs.agc"
#include "core_util.agc"
#include "audio.agc"
#include "core_ui.agc"
#include "rules_pf2e.agc"
#include "data_gear.agc"
#include "data_world.agc"
#include "fighters.agc"
#include "economy.agc"
#include "combat_core.agc"
#include "combat_ai.agc"
#include "gfx_tokens.agc"
#include "combat_ui.agc"
#include "screens_manage.agc"
#include "screens_arena.agc"
#include "save_load.agc"

SetWindowTitle("Hopeavirta - Keh" + Chr(228) + "n Kilta")
SetWindowSize(SCRW, SCRH, 0)
SetVirtualResolution(SCRW, SCRH)
SetSyncRate(60, 0)
SetClearColor(18, 14, 12)
SetRandomSeed(GetSeconds())

InitRules()
InitGear()
InitWorld()
InitEconomyTables()
Print("Luodaan " + Chr(228) + Chr(228) + "niefektit...")
Sync()
InitAudio()
UiInit()
scr = SC_TITLE

dtm as float

do
    dtm = GetFrameTime()
    if dtm > 0.05
        dtm = 0.05
    endif
    animT = animT + dtm
    if msgT > 0
        msgT = msgT - dtm
    endif

    UiBegin()
    if scr = SC_TITLE
        ScreenTitle()
    elseif scr = SC_NEW
        ScreenNew()
    elseif scr = SC_HUB
        ScreenHub()
    elseif scr = SC_ROSTER
        ScreenRoster()
    elseif scr = SC_RECRUIT
        ScreenRecruit()
    elseif scr = SC_SHOP
        ScreenShop()
    elseif scr = SC_ARENA
        ScreenArena()
    elseif scr = SC_BATTLE
        DrawBattle(dtm)
    elseif scr = SC_RESULT
        ScreenResult()
    elseif scr = SC_FACIL
        ScreenFacil()
    elseif scr = SC_LEDGER
        ScreenLedger()
    elseif scr = SC_END
        ScreenEnd()
    endif
    UiEnd()
    Sync()
loop
