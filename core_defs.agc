// ============================================================================
//  HOPEAVIRTA - KEHAN KILTA                                   core_defs.agc
//  Vakiot, tietotyypit ja KAIKKI globaalit muuttujat (ladataan ensimmaisena).
//  Tekstit kirjoitetaan {a}=a-umlaut, {o}=o-umlaut (isot {A} {O}); Tx() muuntaa ne.
// ============================================================================

#constant SCRW      1280
#constant SCRH      720

// ruudut
#constant SC_TITLE  0
#constant SC_HUB    1
#constant SC_ROSTER 2
#constant SC_RECRUIT 3
#constant SC_SHOP   4
#constant SC_ARENA  5
#constant SC_BATTLE 6
#constant SC_RESULT 7
#constant SC_FACIL  8
#constant SC_LEDGER 9
#constant SC_END    10
#constant SC_NEW    11

// luokat
#constant CL_FIGHTER 0
#constant CL_BARB   1
#constant CL_ROGUE  2
#constant CL_CHAMP  3
#constant CL_WIZ    4
#constant NCLASS    5
#constant NANC      8

// ominaisuudet
#constant AB_STR 0
#constant AB_DEX 1
#constant AB_CON 2
#constant AB_INT 3
#constant AB_WIS 4
#constant AB_CHA 5

// varusteet
#constant NWEAP     13
#constant NARMOR    8
#constant NSHIELD   3
#constant WF_AGILE  1
#constant WF_FINESSE 2
#constant WF_MARTIAL 4
#constant WF_RANGED 8
#constant WF_TWOH   16
#constant WF_REACH  32

// kilta ja taistelijat
#constant MAXFT     16
#constant RECBASE   16
#constant NREC      6
#constant NMON      18
#constant MAXCARD   5

// hirviolippuja
#constant FL_KNOCK  1
#constant FL_REACH  2
#constant FL_RANGED 4
#constant FL_CASTER 8
#constant FL_REGEN  16

// markkinaindeksit
#constant IX_WEAP   0
#constant IX_ARM    1
#constant IX_POT    2
#constant IX_FOOD   3
#constant IX_TALENT 4

// taistelu
#constant GRIDW     14
#constant GRIDH     9
#constant CELL      56
#constant BOARDX    24
#constant BOARDY    66
#constant MAXCMB    12
#constant MD_NONE   0
#constant MD_STRIKE 1
#constant MD_MOVE   2
#constant MD_TRIP   3
#constant MD_DEMO   4
#constant MD_POWER  5
#constant MD_FEINT  6
#constant MD_LAY    7
#constant MD_ARC    8
#constant MD_BARR   9
#constant MD_FIRE   10

// ----------------------------------------------------------------------------
//  Tyypit
// ----------------------------------------------------------------------------
type tFighter
    used as integer
    name as string
    anc as integer
    cls as integer
    level as integer
    xp as integer
    aStr as integer
    aDex as integer
    aCon as integer
    aInt as integer
    aWis as integer
    aCha as integer
    weapon as integer
    armor as integer
    shield as integer
    wPot as integer
    wStrk as integer
    aPot as integer
    aRes as integer
    pot1 as integer
    pot2 as integer
    pot3 as integer
    hp as integer
    injury as integer
    wounded as integer
    wage as integer
    pop as integer
    wins as integer
    losses as integer
    trained as integer
    fought as integer
    sel as integer
endtype

type tCmb
    used as integer
    side as integer
    src as integer
    mon as integer
    name as string
    glyph as string
    cls as integer
    lvl as integer
    x as integer
    y as integer
    hp as integer
    hpMax as integer
    tmp as integer
    ac as integer
    fort as integer
    refl as integer
    will as integer
    perc as integer
    atk as integer
    dice as integer
    die as integer
    flat as integer
    deadly as integer
    agile as integer
    ranged as integer
    reach as integer
    speed as integer
    acts as integer
    mapN as integer
    off as integer
    prone as integer
    fright as integer
    rage as integer
    shield as integer
    hard as integer
    react as integer
    dying as integer
    wounded as integer
    down as integer
    dead as integer
    init as integer
    spDC as integer
    spMod as integer
    slots as integer
    sRank as integer
    sneak as integer
    flags as integer
    athl as integer
    intim as integer
    decep as integer
    lay as integer
    pot1 as integer
    pot2 as integer
    pot3 as integer
    kind as integer
endtype

type tCard
    used as integer
    name as string
    foe as string
    n as integer
    tier as integer
    kind as integer
    ne as integer
    xp as integer
    purse as integer
    champ as integer
endtype

// ----------------------------------------------------------------------------
//  Pelin tila
// ----------------------------------------------------------------------------
global scr as integer
global gold as integer
global debt as integer
global week as integer
global fame as integer
global demand as float
global mkt as float[5]
global ticketLv as integer
global sponsor as integer
global sponsorIdle as integer
global facB as integer
global facT as integer
global facI as integer
global facS as integer
global facW as integer
global guildName as string
global news as string[5]
global wkIn as integer
global wkOut as integer
global lastIn as integer
global lastOut as integer
global histNet as integer[8]
global gameOver as integer
global msg as string
global msgT as float
global selFt as integer
global shopCat as integer
global shopFt as integer
global cardSel as integer
global betLv as integer
global bloodOn as integer
global cardRef as integer
global resLine as string[18]
global resN as integer
global resWin as integer
global upW as integer
global upF as integer
global upR as integer
global upB as integer
global upI as integer
global upTot as integer
global rosterPage as integer
global animT as float

global ft as tFighter[22]
global card as tCard[5]
global cardEn as integer[5,6]
global gBlankFt as tFighter
global gBlankCm as tCmb
global gBlankCard as tCard

// ----------------------------------------------------------------------------
//  Taistelun tila
// ----------------------------------------------------------------------------
global cm as tCmb[12]
global cmN as integer
global bOrder as integer[12]
global bOrderN as integer
global bPos as integer
global bCur as integer
global bRound as integer
global bMode as integer
global bOver as integer
global bTimer as float
global bEndT as float
global bBlocked as integer[14,9]
global bMv as integer[14,9]
global bLog as string[9]
global bCard as integer
global bBlood as integer
global bInsp as integer
global bXP as integer
global bNPl as integer
global bStake as integer
global bPurse as integer
global bGate as integer
global bYield as integer

// ----------------------------------------------------------------------------
//  Datataulukot (taytetaan Init-funktioissa)
// ----------------------------------------------------------------------------
global tAC as string[4]
global tAtk as string[4]
global tSav as string[4]
global tHP as string[4]
global tDmg as string[4]
global xpDiff as integer[9]
global bdBase as integer[4]
global bdAdj as integer[4]

global wpN as string[13]
global wpD as integer[13]
global wpF as integer[13]
global wpDd as integer[13]
global wpR as integer[13]
global wpP as integer[13]
global arN as string[8]
global arAC as integer[8]
global arCap as integer[8]
global arSp as integer[8]
global arP as integer[8]
global shN as string[3]
global shH as integer[3]
global shP as integer[3]
global ptN as string[3]
global ptDn as integer[3]
global ptDd as integer[3]
global ptFl as integer[3]
global ptP as integer[3]
global rnW as integer[4]
global rnS as integer[4]
global rnA as integer[4]
global rnR as integer[4]

global anN as string[8]
global anHP as integer[8]
global anSp as integer[8]
global anB1 as integer[8]
global anB2 as integer[8]
global clN as string[5]
global clHP as integer[5]
global clT as integer[5,6]
global clPr as integer[5,4]
global mnN as string[18]
global mnLv as integer[18]
global mnKd as integer[18]
global mnAC as integer[18]
global mnHP as integer[18]
global mnAt as integer[18]
global mnDm as integer[18]
global mnFo as integer[18]
global mnRe as integer[18]
global mnWi as integer[18]
global mnSp as integer[18]
global mnFl as integer[18]
global fnN as string[24]
global enN as string[24]
global foeN as string[9]
global btN as string[4]
global evN as string[10]

global pgp as integer[11]
global tierMul as float[4]
global oddsT as float[4]
global hypeT as float[4]
global capT as integer[4]
global tkM as float[4]
global spN as string[4]
global spB as integer[4]
global spF as integer[4]
global facN as string[5]
global stakeT as integer[5]
