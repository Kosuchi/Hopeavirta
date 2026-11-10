// ============================================================================
//  data_world.agc  -  Hopeavirran maailma: esi-isat, luokat, hirvioet, nimet
//
//  Maailma: Vapaakaupunki Hopeavirta, myohaiskeskiaikainen kauppakaupunki
//  Harmaan joen varrella. Kauppakillat hallitsevat, ja Suuri Keha (vanhan
//  linnan sisapiha) on kaupungin viihde ja talouden sydan. Kilta-mestarit
//  pitavat kehan taistelijoita kuin kauppiaat laivojaan.
//  (Oma maailma - vain saannot ovat PF2E:sta.)
// ============================================================================

function SetMon(i as integer, nm as string, lv as integer, kd as integer, tac as integer, thp as integer, tat as integer, tdm as integer, tfo as integer, tre as integer, twi as integer, sp as integer, fl as integer)
    mnN[i] = nm
    mnLv[i] = lv
    mnKd[i] = kd
    mnAC[i] = tac
    mnHP[i] = thp
    mnAt[i] = tat
    mnDm[i] = tdm
    mnFo[i] = tfo
    mnRe[i] = tre
    mnWi[i] = twi
    mnSp[i] = sp
    mnFl[i] = fl
endfunction

function InitWorld()
    // --- esi-isat (PF2E Player Core): HP, nopeus ruutuina, kaksi nostoa ---
    anN[0] = "Ihminen"
    anHP[0] = 8
    anSp[0] = 5
    anB1[0] = -1
    anB2[0] = -1
    anN[1] = "K{a}{a}pi{o}"
    anHP[1] = 10
    anSp[1] = 4
    anB1[1] = AB_CON
    anB2[1] = AB_WIS
    anN[2] = "Haltia"
    anHP[2] = 6
    anSp[2] = 6
    anB1[2] = AB_DEX
    anB2[2] = AB_INT
    anN[3] = "Gnomi"
    anHP[3] = 8
    anSp[3] = 5
    anB1[3] = AB_CON
    anB2[3] = AB_CHA
    anN[4] = "Goblini"
    anHP[4] = 6
    anSp[4] = 5
    anB1[4] = AB_DEX
    anB2[4] = AB_CHA
    anN[5] = "Puolituinen"
    anHP[5] = 6
    anSp[5] = 5
    anB1[5] = AB_DEX
    anB2[5] = AB_WIS
    anN[6] = "{O}rkki"
    anHP[6] = 10
    anSp[6] = 5
    anB1[6] = AB_STR
    anB2[6] = AB_CON
    anN[7] = "Lehtihenki"
    anHP[7] = 8
    anSp[7] = 5
    anB1[7] = AB_CON
    anB2[7] = AB_WIS

    // --- luokat: HP/taso, aloitusmodit (Str Dex Con Int Wis Cha), nostojarjestys ---
    clN[0] = "Taistelija"
    clN[1] = "Berserkki"
    clN[2] = "Lurjus"
    clN[3] = "Sankari"
    clN[4] = "Velho"
    clHP[0] = 10
    clHP[1] = 12
    clHP[2] = 8
    clHP[3] = 10
    clHP[4] = 6
    SetTmpl(0, 4, 2, 2, 0, 1, 0)
    SetTmpl(1, 4, 1, 3, -1, 1, 0)
    SetTmpl(2, 0, 4, 1, 1, 1, 2)
    SetTmpl(3, 4, 0, 2, 0, 1, 2)
    SetTmpl(4, -1, 2, 1, 4, 1, 0)
    SetPrio(0, 0, 2, 1, 4)
    SetPrio(1, 0, 2, 1, 4)
    SetPrio(2, 1, 5, 2, 4)
    SetPrio(3, 0, 2, 5, 4)
    SetPrio(4, 3, 1, 2, 4)

    // --- hirvioet: nimi, taso, laji (0 peto 1 humanoidi 2 hirvio), AC/HP/isku/vahinko, saavat, nopeus, liput
    // tierit: 0 aaripaa 1 korkea 2 kohtalainen 3 matala
    SetMon(0, "J{a}ttirotta", -1, 0, 2, 3, 2, 3, 2, 1, 3, 6, 0)
    SetMon(1, "Goblinsoturi", -1, 1, 1, 3, 1, 2, 2, 1, 3, 5, 0)
    SetMon(2, "Susi", 1, 0, 2, 2, 1, 2, 1, 1, 3, 7, FL_KNOCK)
    SetMon(3, "Palkkamiekkailija", 1, 1, 1, 2, 1, 2, 2, 2, 2, 5, 0)
    SetMon(4, "J{a}ttih{a}m{a}h{a}kki", 1, 0, 2, 2, 1, 2, 1, 2, 3, 6, FL_KNOCK)
    SetMon(5, "Villisika", 2, 0, 2, 1, 1, 1, 1, 2, 3, 6, 0)
    SetMon(6, "Luolakarhu", 2, 0, 2, 1, 1, 1, 1, 2, 3, 6, FL_KNOCK)
    SetMon(7, "Jousiampuja", 2, 1, 2, 3, 1, 2, 2, 1, 2, 5, FL_RANGED)
    SetMon(8, "J{a}ttil{a}inen", 3, 2, 2, 1, 1, 0, 1, 3, 3, 5, FL_REACH)
    SetMon(9, "Taikuri", 3, 1, 3, 3, 3, 2, 3, 2, 1, 5, FL_CASTER)
    SetMon(10, "P{o}ll{o}karhu", 4, 2, 1, 1, 1, 1, 1, 2, 2, 6, FL_KNOCK)
    SetMon(11, "Miekkamestari", 5, 1, 1, 2, 1, 1, 1, 1, 2, 5, 0)
    SetMon(12, "Peikko", 5, 2, 2, 1, 1, 0, 1, 2, 3, 6, FL_REGEN + FL_REACH)
    SetMon(13, "Lohik{a}{a}rme", 6, 2, 1, 1, 1, 1, 1, 2, 2, 8, FL_KNOCK)
    SetMon(14, "Kivij{a}ttil{a}inen", 7, 2, 2, 1, 1, 0, 1, 3, 2, 6, FL_REACH)
    SetMon(15, "Verikeh{a}n sankari", 8, 1, 0, 2, 1, 1, 1, 2, 1, 5, 0)
    SetMon(16, "Lohik{a}{a}rmeenpoikanen", 9, 2, 1, 1, 0, 1, 1, 1, 1, 7, FL_KNOCK)
    SetMon(17, "Keh{a}n ruhtinas", 10, 1, 1, 1, 1, 1, 1, 1, 1, 6, 0)

    // --- nimet ---
    fnN[0] = "Aarne"
    fnN[1] = "Veikko"
    fnN[2] = "Toivo"
    fnN[3] = "Kalle"
    fnN[4] = "Otso"
    fnN[5] = "Sulo"
    fnN[6] = "Ilmari"
    fnN[7] = "Eino"
    fnN[8] = "Urho"
    fnN[9] = "Tapio"
    fnN[10] = "Sampsa"
    fnN[11] = "Lemmitty"
    fnN[12] = "Aino"
    fnN[13] = "Kyllikki"
    fnN[14] = "Marjatta"
    fnN[15] = "Sirkka"
    fnN[16] = "Ilona"
    fnN[17] = "Helmi"
    fnN[18] = "Tyyne"
    fnN[19] = "Siiri"
    fnN[20] = "Elina"
    fnN[21] = "Aili"
    fnN[22] = "Lempi"
    fnN[23] = "Tuulikki"
    enN[0] = "Rautak{a}si"
    enN[1] = "Kivikasvo"
    enN[2] = "Harmaasusi"
    enN[3] = "Punaparta"
    enN[4] = "Mustakorppi"
    enN[5] = "Ter{a}svarpu"
    enN[6] = "Hopeakieli"
    enN[7] = "Raivokas"
    enN[8] = "Hiljainen"
    enN[9] = "Verikoura"
    enN[10] = "Kuolonkuiskaaja"
    enN[11] = "Sumuinen"
    enN[12] = "Tulenkantaja"
    enN[13] = "Kaksoister{a}"
    enN[14] = "Joenylitt{a}j{a}"
    enN[15] = "Vuorenpoika"
    enN[16] = "Kultasormi"
    enN[17] = "Kolkko"
    enN[18] = "Nopeajalka"
    enN[19] = "Karhunkaulus"
    enN[20] = "Y{o}n kulkija"
    enN[21] = "Lumikki"
    enN[22] = "Suurisuu"
    enN[23] = "Vanha Kettu"

    foeN[0] = "Keh{a}n petotarha"
    foeN[1] = "Sudenkuopan karju"
    foeN[2] = "Metsien vieraat"
    foeN[3] = "Rautakourat"
    foeN[4] = "Mustan Karhun veljet"
    foeN[5] = "Punaisen Sulan kilta"
    foeN[6] = "Hirvi{o}tarha"
    foeN[7] = "Luolien kauhut"
    foeN[8] = "Vuorten vieraat"

    btN[0] = "Kaksintaistelu"
    btN[1] = "Parikamppailu"
    btN[2] = "Kolmen kamppailu"
    btN[3] = "Joukkokamppailu"

    evN[0] = "Rauhallinen viikko. Kauppa k{a}y tasaisesti."
    evN[1] = "Sato ep{a}onnistui: ruoka kallistuu."
    evN[2] = "Runsas sato: ruoka halpenee, kansa juhlii."
    evN[3] = "Sota rajalla: sepp{a}t takovat vain sotakalua."
    evN[4] = "Markkinajuhla! Kaupunki t{a}ynn{a} v{a}ke{a}."
    evN[5] = "Rutto kaduilla: yleis{o} vaikenee, juomat kalliita."
    evN[6] = "Kuninkaan l{a}hetit kaupungissa: katsomot t{a}yttyv{a}t."
    evN[7] = "Kauppalaivue saapui: tavarat halpenevat."
    evN[8] = "Naapurikaupungin turnajaiset: taistelijat kiven alla."
    evN[9] = "Pankit tiukentavat, mutta kehaan uskotaan."
endfunction

function SetTmpl(c as integer, a0 as integer, a1 as integer, a2 as integer, a3 as integer, a4 as integer, a5 as integer)
    clT[c,0] = a0
    clT[c,1] = a1
    clT[c,2] = a2
    clT[c,3] = a3
    clT[c,4] = a4
    clT[c,5] = a5
endfunction

function SetPrio(c as integer, p0 as integer, p1 as integer, p2 as integer, p3 as integer)
    clPr[c,0] = p0
    clPr[c,1] = p1
    clPr[c,2] = p2
    clPr[c,3] = p3
endfunction

// ----------------------------------------------------------------------------
//  Luokkien ammattitaito tasoittain (yksinkertaistettu PF2E:n taulukoista)
// ----------------------------------------------------------------------------
function WeaponRank(c as integer, lvl as integer)
    r as integer
    if c = CL_FIGHTER
        r = 2
        if lvl >= 5
            r = 3
        endif
        if lvl >= 13
            r = 4
        endif
    elseif c = CL_WIZ
        r = 1
    else
        r = 1
        if lvl >= 5
            r = 2
        endif
        if lvl >= 13
            r = 3
        endif
    endif
endfunction r

function ArmorRank(c as integer, lvl as integer)
    r as integer
    r = 1
    if c = CL_FIGHTER and lvl >= 11
        r = 2
    endif
    if c = CL_CHAMP and lvl >= 7
        r = 2
    endif
    if (c = CL_BARB or c = CL_ROGUE or c = CL_WIZ) and lvl >= 13
        r = 2
    endif
endfunction r

// k: 0 kestavyys, 1 refleksit, 2 tahto
function SaveRank(c as integer, k as integer, lvl as integer)
    r as integer
    r = 1
    if c = CL_FIGHTER
        if k <> 2
            r = 2
        endif
        if k = 2 and lvl >= 9
            r = 2
        endif
    elseif c = CL_BARB
        if k <> 1
            r = 2
        endif
    elseif c = CL_ROGUE
        if k <> 0
            r = 2
        endif
    elseif c = CL_CHAMP
        if k <> 1
            r = 2
        endif
    else
        if k = 2
            r = 2
        endif
    endif
endfunction r

function PercRank(c as integer)
    r as integer
    r = 2
    if c = CL_CHAMP or c = CL_WIZ
        r = 1
    endif
endfunction r

function AthRank(c as integer)
    r as integer
    r = 1
    if c = CL_ROGUE
        r = 0
    endif
    if c = CL_WIZ
        r = 0
    endif
    if c = CL_BARB
        r = 2
    endif
endfunction r

function IntRank(c as integer)
    r as integer
    r = 0
    if c = CL_BARB or c = CL_CHAMP or c = CL_FIGHTER
        r = 1
    endif
endfunction r

function DecRank(c as integer)
    r as integer
    r = 0
    if c = CL_ROGUE
        r = 2
    endif
endfunction r

function SpellRank(lvl as integer)
    r as integer
    r = 1
    if lvl >= 7
        r = 2
    endif
    if lvl >= 15
        r = 3
    endif
endfunction r

// salahyokkayksen nopat (lurjus): 1d6 +1 tasoilla 5, 11, 17
function SneakDice(c as integer, lvl as integer)
    r as integer
    r = 0
    if c = CL_ROGUE
        r = 1
        if lvl >= 5
            r = 2
        endif
        if lvl >= 11
            r = 3
        endif
    endif
endfunction r

function RandName()
    s as string
    s = fnN[RI(0, 23)] + " " + enN[RI(0, 23)]
endfunction s

// viikkopalkka kuparia tason mukaan
function WageGp(lvl as integer)
    r as integer
    r = 3
    if lvl = 2
        r = 5
    elseif lvl = 3
        r = 9
    elseif lvl = 4
        r = 14
    elseif lvl = 5
        r = 22
    elseif lvl = 6
        r = 32
    elseif lvl = 7
        r = 46
    elseif lvl = 8
        r = 64
    elseif lvl = 9
        r = 90
    elseif lvl >= 10
        r = 125
    endif
endfunction r

function ClassName(c as integer)
    s as string
    s = clN[c]
endfunction s
