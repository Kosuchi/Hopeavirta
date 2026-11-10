// ============================================================================
//  screens_manage.agc  -  otsikko, uusi peli, kilta, taistelijat, varvays,
//                         kauppa, tilat, talous
// ============================================================================

global relConf as integer
global nsCount as integer

function RankName(f as integer)
    s as string
    if f >= 1000
        s = "Legenda"
    elseif f >= 750
        s = "Kuninkaan suosikki"
    elseif f >= 500
        s = "Keh{a}n mestari"
    elseif f >= 250
        s = "Kaupungin puheenaihe"
    elseif f >= 100
        s = "Keh{a}n tulokas"
    else
        s = "Tuntematon"
    endif
endfunction s

function DmgStr(i as integer)
    s as string
    s = Str(1 + ft[i].wStrk) + "d" + Str(wpD[ft[i].weapon]) + SignStr(FDmgMod(i))
endfunction s

function DrawFighterCard(i as integer, x as float, y as float, w as float)
    wp as integer
    UiPanel(x, y, w, 280)
    wp = ft[i].weapon
    UiText(x + 14, y + 8, 22, ft[i].name, 240, 215, 140, 0)
    UiText(x + 14, y + 36, 16, clN[ft[i].cls] + " - " + anN[ft[i].anc] + "   Taso " + Str(ft[i].level), 205, 195, 170, 0)
    UiText(x + 14, y + 62, 16, "HP " + Str(ft[i].hp) + " / " + Str(MaxHPf(i)) + "     AC " + Str(FAC(i)) + "     Nopeus " + Str(FSpeed(i)) + " ruutua", 230, 220, 195, 0)
    UiText(x + 14, y + 86, 16, "Fort " + SignStr(FSave(i, 0)) + "   Ref " + SignStr(FSave(i, 1)) + "   Will " + SignStr(FSave(i, 2)) + "   Perc " + SignStr(FPerc(i)), 230, 220, 195, 0)
    UiText(x + 14, y + 110, 15, "Vo " + SignStr(ft[i].aStr) + "  Ket " + SignStr(ft[i].aDex) + "  Kes " + SignStr(ft[i].aCon) + "  {A}ly " + SignStr(ft[i].aInt) + "  Vii " + SignStr(ft[i].aWis) + "  Kar " + SignStr(ft[i].aCha), 200, 190, 165, 0)
    UiText(x + 14, y + 138, 16, wpN[wp] + " " + SignStr(FAtk(i)) + "  vahinko " + DmgStr(i), 245, 225, 170, 0)
    UiText(x + 14, y + 162, 16, arN[ft[i].armor] + " / " + shN[ft[i].shield], 230, 220, 195, 0)
    UiText(x + 14, y + 186, 15, "Riimut: ase +" + Str(ft[i].wPot) + "  iskunoppa x" + Str(1 + ft[i].wStrk) + "  panssari +" + Str(ft[i].aPot) + "  kest{a}v{a}" + " +" + Str(ft[i].aRes), 200, 190, 165, 0)
    UiText(x + 14, y + 208, 15, "Juomia: " + Str(ft[i].pot1) + " / " + Str(ft[i].pot2) + " / " + Str(ft[i].pot3), 200, 190, 165, 0)
    if ft[i].cls = CL_WIZ
        UiText(x + 14, y + 230, 15, "Loitsu-DC " + Str(FSpellDC(i)) + "   paikkoja " + Str(2 + Trunc(ft[i].level / 3.0)), 200, 170, 230, 0)
    elseif ft[i].cls = CL_ROGUE
        UiText(x + 14, y + 230, 15, "Sneak Attack " + Str(SneakDice(CL_ROGUE, ft[i].level)) + "d6", 160, 220, 140, 0)
    elseif ft[i].cls = CL_BARB
        UiText(x + 14, y + 230, 15, "Rage: +2 vahinko, v{a}liaikaiset HP", 240, 160, 110, 0)
    elseif ft[i].cls = CL_CHAMP
        UiText(x + 14, y + 230, 15, "Lay on Hands: " + Str(6 + 3 * Trunc(ft[i].level / 2.0)) + " HP, 1 / ottelu", 240, 225, 140, 0)
    else
        UiText(x + 14, y + 230, 15, "Power Attack: +1 vahinkonoppa", 150, 190, 245, 0)
    endif
    UiText(x + 14, y + 254, 15, "Voitot " + Str(ft[i].wins) + "  Tappiot " + Str(ft[i].losses) + "   Suosio " + Str(ft[i].pop), 190, 180, 160, 0)
endfunction

// ----------------------------------------------------------------------------
//  Otsikkoruutu ja uusi peli
// ----------------------------------------------------------------------------
function ScreenTitle()
    UiRect(0, 0, SCRW, SCRH, 18, 14, 12, 255)
    UiRect(0, 170, SCRW, 4, 130, 100, 55, 255)
    UiText(SCRW / 2, 36, 76, "HOPEAVIRTA", 235, 195, 95, 1)
    UiText(SCRW / 2, 122, 28, "Keh{a}n Kilta  -  gladiaattorien johtajapeli", 200, 185, 150, 1)
    UiText(SCRW / 2, 200, 19, "Hopeavirta on vapaakaupunki Harmaan joen mutkassa, jossa kauppakillat hallitsevat ja kolikko on ainoa kuningas.", 225, 212, 180, 1)
    UiText(SCRW / 2, 232, 19, "Kaupungin syd{a}n on Suuri Keh{a}: vanhan linnan raunioitunut sis{a}piha, jonne kansa kerj{a}{a}ntyy katsomaan taistelijoita.", 225, 212, 180, 1)
    UiText(SCRW / 2, 264, 19, "Miekat, jouset ja taika elett{a}v{a}t pankkeja, panimoita ja villakauppiaita - ja keh{a}n pit{a}j{a}t rikastuvat.", 225, 212, 180, 1)
    UiText(SCRW / 2, 296, 19, "Sin{a} olet Kilta-Mestari. Palkkaa taistelijat, hio heid{a}t mestareiksi ja tee Keh{a}st{a} kultakaivos.", 225, 212, 180, 1)
    UiText(SCRW / 2, 328, 19, "Tavoite: nosta kiltasi maine tuhanteen - ennen kuin velkojat viev{a}t viimeisetkin kolikot.", 245, 215, 140, 1)
    if UiButton(SCRW / 2 - 150, 410, 300, 56, "Uusi peli") = 1
        StartNewSetup()
    endif
    if GetFileExists("hopeavirta.sav") = 1
        if UiButton(SCRW / 2 - 150, 482, 300, 56, "Jatka tallennettua") = 1
            if LoadGame() = 1
                scr = SC_HUB
            else
                SetMsg("Tallennuksen lataus ep{a}onnistui.")
            endif
        endif
    endif
    UiText(SCRW / 2, 610, 14, "Pelin s{a}{a}nn{o}t perustuvat Pathfinder Second Edition (Remaster) -s{a}{a}nt{o}ihin (Paizo Inc.), jotka on julkaistu ORC-lisenssill{a}.", 150, 140, 120, 1)
    UiText(SCRW / 2, 630, 14, "Maailma, nimet ja teksti ovat omia; Paizon maailmaa (Golarion) tai tavaramerkkej{a} ei k{a}ytet{a}.", 150, 140, 120, 1)
    UiText(SCRW / 2, 650, 14, "Kaikki grafiikka piirret{a}{a}n AppGameKitin omalla moottorilla.", 150, 140, 120, 1)
    if msgT > 0
        UiRect(SCRW / 2 - 330, 560, 660, 26, 70, 20, 16, 240)
        UiText(SCRW / 2, 564, 17, msg, 255, 225, 170, 1)
    endif
endfunction

function StartNewSetup()
    i as integer
    j as integer
    c as integer
    t as integer
    NewGuild()
    scr = SC_NEW
    nsCount = 0
    RollStarters()
endfunction

function RollStarters()
    k as integer
    c as integer
    t as integer
    cls as integer
    for k = 0 to 3
        ft[RECBASE + k] = gBlankFt
    next k
    c = RI(0, 4)
    for k = 0 to 3
        cls = Mod(c + k, 5)
        MakeFighter(RECBASE + k, cls, RI(0, 7), 1)
        ft[RECBASE + k].sel = 0
    next k
    nsCount = 0
endfunction

function ScreenNew()
    k as integer
    x as float
    en as integer
    s as integer
    UiHeader("Uusi kilta: " + guildName)
    UiText(SCRW / 2, 72, 20, "Valitse kaksi alkutaistelijaa. Alkup{a}{a}oma: " + Money(gold), 230, 210, 160, 1)
    for k = 0 to 3
        x = 20 + k * 312
        DrawFighterCard(RECBASE + k, x, 110, 300)
        en = 1
        if ft[RECBASE + k].sel = 1
            en = 2
        endif
        if UiBtn(x + 60, 400, 180, 40, "Valitse", en, "") = 1
            if ft[RECBASE + k].sel = 1
                ft[RECBASE + k].sel = 0
                nsCount = nsCount - 1
            elseif nsCount < 2
                ft[RECBASE + k].sel = 1
                nsCount = nsCount + 1
            endif
        endif
    next k
    if UiButton(20, 500, 220, 44, "Arvo uudet") = 1
        RollStarters()
    endif
    en = 0
    if nsCount = 2
        en = 1
    endif
    if UiBtn(SCRW / 2 - 130, 580, 260, 56, "Aloita peli", en, "") = 1
        s = 0
        for k = 0 to 3
            if ft[RECBASE + k].sel = 1
                ft[s] = ft[RECBASE + k]
                ft[s].sel = 0
                s = s + 1
            endif
        next k
        for k = 0 to 5
            ft[RECBASE + k] = gBlankFt
        next k
        for k = 0 to 1
            ft[k].wage = Trunc(WageGp(1) * 100 * 0.8)
        next k
        RefreshRecruits()
        GenerateCards()
        news[0] = "Kilta " + guildName + " avaa ovensa."
        scr = SC_HUB
    endif
endfunction

// ----------------------------------------------------------------------------
//  Kilta (paavalikko)
// ----------------------------------------------------------------------------
function ScreenHub()
    i as integer
    n as integer
    inj as integer
    UiHeader(guildName)
    if UiButton(30, 80, 300, 50, "Taistelijat") = 1
        scr = SC_ROSTER
    endif
    if UiButton(30, 140, 300, 50, "V{a}rv{a}ys") = 1
        scr = SC_RECRUIT
    endif
    if UiButton(30, 200, 300, 50, "Kauppa") = 1
        scr = SC_SHOP
    endif
    if UiBtn(30, 260, 300, 50, "Areena", 1, "Valitse ottelu ja taistelijat") = 1
        scr = SC_ARENA
    endif
    if UiButton(30, 320, 300, 50, "Talous") = 1
        scr = SC_LEDGER
    endif
    if UiButton(30, 380, 300, 50, "Tilat") = 1
        scr = SC_FACIL
    endif
    if UiButton(30, 440, 300, 50, "Tallenna peli") = 1
        SaveGame()
        SetMsg("Peli tallennettu.")
    endif
    if UiBtn(30, 530, 300, 64, "Seuraava viikko", 1, "Maksa kulut, toivu, p{a}ivit{a} markkinat ja otteluohjelma") = 1
        EndWeek()
        if gameOver > 0
            scr = SC_END
        endif
    endif

    UiPanel(360, 80, 890, 170)
    UiText(376, 88, 20, "Kaupungin uutiset", 235, 195, 95, 0)
    for i = 0 to 3
        UiText(376, 120 + i * 28, 17, news[i], 225, 212, 180, 0)
    next i

    ComputeUpkeep()
    n = RosterCount()
    inj = 0
    for i = 0 to MAXFT - 1
        if ft[i].used = 1 and ft[i].injury > 0
            inj = inj + 1
        endif
    next i
    UiPanel(360, 270, 440, 324)
    UiText(376, 278, 20, "Kilta", 235, 195, 95, 0)
    UiText(376, 312, 17, "Taistelijoita: " + Str(n) + " / " + Str(BarracksCap()), 225, 212, 180, 0)
    UiText(376, 338, 17, "Vammautuneita: " + Str(inj) + "   Otteluvalmiita: " + Str(HealthyCount()), 225, 212, 180, 0)
    UiText(376, 364, 17, "Velka: " + Money(debt), 225, 212, 180, 0)
    UiText(376, 390, 17, "Sponsori: " + spN[sponsor], 225, 212, 180, 0)
    UiText(376, 416, 17, "Seuraavan viikon kulut: " + Money(upTot), 245, 190, 150, 0)
    UiText(376, 442, 17, "Yleis{o}n kiinnostus: " + Str(Trunc(demand * 100)) + " %", 225, 212, 180, 0)
    UiText(376, 468, 17, "Otteluita tarjolla: " + Str(card[0].used + card[1].used + card[2].used + card[3].used + card[4].used), 225, 212, 180, 0)
    UiText(376, 510, 17, "Sijoitus: " + RankName(fame), 240, 215, 140, 0)
    UiBar(376, 540, 408, 18, fame / 1000.0, 200, 160, 60)
    UiText(376, 562, 14, "Maine " + Str(fame) + " / 1000  (voitto)", 190, 180, 160, 0)

    UiPanel(820, 270, 430, 324)
    UiText(836, 278, 20, "Maailma", 235, 195, 95, 0)
    UiText(836, 312, 15, "Hopeavirran kymmenen kiltaa kilpailevat Suuren", 205, 195, 170, 0)
    UiText(836, 334, 15, "Keh{a}n yleis{o}st{a}. Kaupungin neuvosto verottaa", 205, 195, 170, 0)
    UiText(836, 356, 15, "jokaisen ottelun, mutta rikkaat kauppiaat", 205, 195, 170, 0)
    UiText(836, 378, 15, "sponsoroivat voittajia. Jos seppien hinnat nousevat", 205, 195, 170, 0)
    UiText(836, 400, 15, "tai rutto iskee, katsomot tyhjenev{a}t.", 205, 195, 170, 0)
    UiText(836, 440, 15, "Ottelut: taso-ero ratkaisee. PF2E:ssa tasoero 4", 205, 195, 170, 0)
    UiText(836, 462, 15, "tarkoittaa lyhytt{a} taistelua. Lukitse varusteet,", 205, 195, 170, 0)
    UiText(836, 484, 15, "pid{a} juomat mukana ja saarta viholliset.", 205, 195, 170, 0)
endfunction

// ----------------------------------------------------------------------------
//  Taistelijat
// ----------------------------------------------------------------------------
function ScreenRoster()
    i as integer
    en as integer
    ok as integer
    lv as integer
    s as string
    UiHeader("Taistelijat")
    if UiButton(1090, 8, 120, 40, "Takaisin") = 1
        scr = SC_HUB
    endif
    for i = 0 to MAXFT - 1
        en = 1
        if i = selFt
            en = 2
        endif
        if ft[i].used = 1
            s = ft[i].name + "  " + Str(ft[i].level) + "  " + FirstWord(clN[ft[i].cls])
            if ft[i].injury > 0
                s = s + "  [vammautunut " + Str(ft[i].injury) + " vk]"
            endif
            if UiBtn(20, 70 + i * 36, 540, 32, s, en, "") = 1
                selFt = i
                relConf = 0
            endif
        else
            UiBtn(20, 70 + i * 36, 540, 32, "(tyhj{a})", 0, "")
        endif
    next i

    if ft[selFt].used = 1
        i = selFt
        DrawFighterCard(i, 590, 70, 660)
        UiText(606, 360, 16, "XP " + Str(ft[i].xp) + " / 1000", 225, 212, 180, 0)
        UiBar(606, 384, 300, 14, ft[i].xp / 1000.0, 90, 170, 220)
        s = "Valmis"
        if ft[i].injury > 0
            s = "Vammautunut: " + Str(ft[i].injury) + " viikkoa (Wounded " + Str(ft[i].wounded) + ")"
        endif
        UiText(606, 408, 16, "Tila: " + s + "      Palkka: " + Money(ft[i].wage) + " / vk", 225, 212, 180, 0)

        en = 1
        if ft[i].trained = 1 or ft[i].level >= 10 or ft[i].injury > 0
            en = 0
        endif
        if UiBtn(606, 450, 300, 48, "Harjoittele: " + Money(TrainCost(i)), en, "+" + Str(50 + 25 * facT) + " XP t{a}ll{a} viikolla") = 1
            if gold >= TrainCost(i)
                gold = gold - TrainCost(i)
                wkOut = wkOut + TrainCost(i)
                ft[i].xp = ft[i].xp + 50 + 25 * facT
                ft[i].trained = 1
                lv = CheckLevel(i)
                if lv > 0
                    SetMsg(FirstWord(ft[i].name) + " nousi tasolle " + Str(ft[i].level) + "!")
                else
                    SetMsg("Harjoitus tehty.")
                endif
            else
                SetMsg("Ei varaa harjoitukseen.")
            endif
        endif
        en = 0
        if ft[i].injury > 0
            en = 1
        endif
        if UiBtn(926, 450, 300, 48, "Hoida: " + Money(HealCost(i)), en, "Lyhent{a}{a} toipumista viikolla") = 1
            if gold >= HealCost(i)
                gold = gold - HealCost(i)
                wkOut = wkOut + HealCost(i)
                ft[i].injury = IMax(0, ft[i].injury - 1)
                if ft[i].injury = 0
                    ft[i].wounded = 0
                    ft[i].hp = MaxHPf(i)
                endif
                SetMsg("Parantaja hoiti taistelijaa.")
            else
                SetMsg("Ei varaa parantajaan.")
            endif
        endif
        if relConf = 0
            if UiButton(606, 520, 300, 44, "Erota taistelija") = 1
                relConf = 1
            endif
        else
            if UiBtn(606, 520, 300, 44, "Varmista: erota", 2, "Taistelija l{a}htee kiltasta pysyv{a}sti") = 1
                SetMsg(FirstWord(ft[i].name) + " erotettu.")
                ft[i] = gBlankFt
                relConf = 0
            endif
        endif
    else
        UiPanel(590, 70, 660, 120)
        UiText(606, 100, 20, "Valitse taistelija vasemmalta.", 225, 212, 180, 0)
    endif
endfunction

// ----------------------------------------------------------------------------
//  Varvays
// ----------------------------------------------------------------------------
function ScreenRecruit()
    k as integer
    s as integer
    fee as integer
    y as float
    en as integer
    UiHeader("V{a}rv{a}ys: kapakoiden vapaat miekat")
    if UiButton(1090, 8, 120, 40, "Takaisin") = 1
        scr = SC_HUB
    endif
    UiText(20, 68, 16, "Taistelijoita " + Str(RosterCount()) + " / " + Str(BarracksCap()) + "    Talentti-indeksi " + Str(Trunc(mkt[IX_TALENT] * 100)) + " %", 200, 190, 165, 0)
    for k = 0 to NREC - 1
        s = RECBASE + k
        y = 92 + k * 98
        UiPanel(20, y, 1240, 90)
        if ft[s].used = 1
            fee = ft[s].wage * 4
            UiText(36, y + 8, 21, ft[s].name, 240, 215, 140, 0)
            UiText(36, y + 38, 16, clN[ft[s].cls] + " - " + anN[ft[s].anc] + "   Taso " + Str(ft[s].level) + "   Suosio " + Str(ft[s].pop), 205, 195, 170, 0)
            UiText(36, y + 62, 15, wpN[ft[s].weapon] + " " + SignStr(FAtk(s)) + " (" + DmgStr(s) + ")   " + arN[ft[s].armor] + " / " + shN[ft[s].shield], 200, 190, 165, 0)
            UiText(560, y + 8, 17, "HP " + Str(ft[s].hp) + "   AC " + Str(FAC(s)) + "   Fort " + SignStr(FSave(s, 0)) + "  Ref " + SignStr(FSave(s, 1)) + "  Will " + SignStr(FSave(s, 2)), 230, 220, 195, 0)
            UiText(560, y + 38, 17, "Palkka " + Money(ft[s].wage) + " / vk", 245, 215, 150, 0)
            UiText(560, y + 62, 17, "Allekirjoitus " + Money(fee), 245, 215, 150, 0)
            en = 1
            if RosterCount() >= BarracksCap() or gold < fee
                en = 0
            endif
            if UiBtn(1060, y + 22, 170, 46, "Palkkaa", en, "Siirt{a}{a} taistelijan kiltaan") = 1
                k = FreeSlot()
                if k >= 0
                    gold = gold - fee
                    wkOut = wkOut + fee
                    Sfx(S_COIN, 60)
                    ft[k] = ft[s]
                    ft[k].sel = 0
                    SetMsg(FirstWord(ft[k].name) + " liittyi kiltaan!")
                    ft[s] = gBlankFt
                endif
                k = NREC
            endif
        else
            UiText(36, y + 34, 18, "(palkattu)", 130, 120, 110, 0)
        endif
    next k
endfunction

// ----------------------------------------------------------------------------
//  Kauppa
// ----------------------------------------------------------------------------
function ShopRow(y as float, nm as string, info as string, price as integer, cur as integer, en as integer)
    r as integer
    s as string
    UiRect(20, y, 1240, 34, 40, 33, 27, 255)
    s = nm
    if cur = 1
        s = nm + "   (k{a}yt{o}ss{a})"
    endif
    UiText(32, y + 7, 17, s, 235, 220, 185, 0)
    UiText(430, y + 8, 15, info, 200, 190, 165, 0)
    UiText(1000, y + 7, 17, Money(price), 245, 215, 150, 2)
    r = 0
    if cur = 1
        UiBtn(1060, y + 2, 170, 30, "-", 0, "")
    else
        r = UiBtn(1060, y + 2, 170, 30, "Osta", en, "")
    endif
endfunction r

function Spend(price as integer)
    r as integer
    r = 0
    if gold >= price
        gold = gold - price
        wkOut = wkOut + price
        r = 1
        Sfx(S_COIN, 60)
    else
        SetMsg("Kolikot eiv{a}t riit{a}.")
    endif
endfunction r

function ScreenShop()
    k as integer
    i as integer
    n as integer
    p as integer
    en as integer
    y as float
    s as string
    f as integer
    cur as integer
    UiHeader("Kauppa: sepp{a}t ja apteekki")
    if UiButton(1090, 8, 120, 40, "Takaisin") = 1
        scr = SC_HUB
    endif
    // valitse taistelija
    if ft[shopFt].used = 0
        shopFt = IMax(0, FreeSlot())
        for k = 0 to MAXFT - 1
            if ft[k].used = 1
                shopFt = k
                exit
            endif
        next k
    endif
    f = shopFt
    if ft[f].used = 0
        UiText(30, 90, 20, "Ei taistelijoita.", 225, 212, 180, 0)
        exitfunction
    endif
    if UiButton(20, 70, 40, 34, "<") = 1
        for k = 1 to MAXFT
            n = Mod(shopFt - k + MAXFT, MAXFT)
            if ft[n].used = 1
                shopFt = n
                exit
            endif
        next k
    endif
    if UiButton(66, 70, 40, 34, ">") = 1
        for k = 1 to MAXFT
            n = Mod(shopFt + k, MAXFT)
            if ft[n].used = 1
                shopFt = n
                exit
            endif
        next k
    endif
    UiText(120, 75, 19, ft[f].name + "  -  " + clN[ft[f].cls] + " " + Str(ft[f].level) + "   AC " + Str(FAC(f)) + "   Isku " + SignStr(FAtk(f)) + " (" + DmgStr(f) + ")", 240, 215, 140, 0)

    for k = 0 to 4
        en = 1
        if k = shopCat
            en = 2
        endif
        if k = 0
            s = "Aseet"
        elseif k = 1
            s = "Panssarit"
        elseif k = 2
            s = "Kilvet"
        elseif k = 3
            s = "Juomat"
        else
            s = "Riimut"
        endif
        if UiBtn(20 + k * 150, 116, 144, 34, s, en, "") = 1
            shopCat = k
        endif
    next k
    UiText(790, 124, 15, "Vanha varuste myyd{a}{a}n 40 %:n hintaan.", 190, 180, 160, 0)

    y = 162
    if shopCat = 0
        for i = 1 to NWEAP - 1
            s = "die d" + Str(wpD[i])
            s = "d" + Str(wpD[i])
            if (wpF[i] && WF_AGILE) <> 0
                s = s + " agile"
            endif
            if (wpF[i] && WF_FINESSE) <> 0
                s = s + " finesse"
            endif
            if (wpF[i] && WF_TWOH) <> 0
                s = s + " kaksik{a}tinen"
            endif
            if (wpF[i] && WF_REACH) <> 0
                s = s + " reach"
            endif
            if (wpF[i] && WF_RANGED) <> 0
                s = s + " ampuma-ase " + Str(wpR[i]) + " ruutua"
            endif
            if wpDd[i] > 0
                s = s + " deadly d" + Str(wpDd[i])
            endif
            if (wpF[i] && WF_MARTIAL) <> 0
                s = s + "  (sotilas)"
            endif
            p = Pr(wpP[i], IX_WEAP)
            en = 1
            if ft[f].cls = CL_WIZ and (wpF[i] && WF_MARTIAL) <> 0
                en = 0
            endif
            cur = 0
            if ft[f].weapon = i
                cur = 1
            endif
            if ShopRow(y, wpN[i], s, p, cur, en) = 1
                if (wpF[i] && WF_TWOH) <> 0 and ft[f].shield > 0
                    SetMsg("Kaksik{a}tinen ase ei sovi kilven kanssa. Myy kilpi ensin.")
                elseif Spend(p) = 1
                    gold = gold + Trunc(wpP[ft[f].weapon] * 0.4)
                    wkOut = wkOut - Trunc(wpP[ft[f].weapon] * 0.4)
                    ft[f].weapon = i
                    SetMsg(wpN[i] + " ostettu.")
                endif
            endif
            y = y + 36
        next i
    elseif shopCat = 1
        for i = 1 to NARMOR - 1
            s = "AC +" + Str(arAC[i]) + "  dex-katto +" + Str(arCap[i])
            if arSp[i] > 0
                s = s + "  nopeus -" + Str(arSp[i]) + " ruutua"
            endif
            p = Pr(arP[i], IX_ARM)
            cur = 0
            if ft[f].armor = i
                cur = 1
            endif
            if ShopRow(y, arN[i], s, p, cur, 1) = 1
                if Spend(p) = 1
                    gold = gold + Trunc(arP[ft[f].armor] * 0.4)
                    wkOut = wkOut - Trunc(arP[ft[f].armor] * 0.4)
                    ft[f].armor = i
                    SetMsg(arN[i] + " ostettu.")
                endif
            endif
            y = y + 36
        next i
    elseif shopCat = 2
        for i = 1 to NSHIELD - 1
            s = "Kilven nosto +2 AC, kovuus " + Str(shH[i]) + " (Shield Block)"
            p = Pr(shP[i], IX_ARM)
            cur = 0
            if ft[f].shield = i
                cur = 1
            endif
            if ShopRow(y, shN[i], s, p, cur, 1) = 1
                if (wpF[ft[f].weapon] && WF_TWOH) <> 0
                    SetMsg("Kaksik{a}tinen ase est{a}{a} kilven k{a}yt{o}n.")
                elseif Spend(p) = 1
                    gold = gold + Trunc(shP[ft[f].shield] * 0.4)
                    wkOut = wkOut - Trunc(shP[ft[f].shield] * 0.4)
                    ft[f].shield = i
                    SetMsg(shN[i] + " ostettu.")
                endif
            endif
            y = y + 36
        next i
    elseif shopCat = 3
        for i = 0 to 2
            s = Str(ptDn[i]) + "d" + Str(ptDd[i]) + SignStr(ptFl[i]) + " HP   (1 toiminto)"
            p = Pr(ptP[i], IX_POT)
            if ShopRow(y, ptN[i], s, p, 0, 1) = 1
                if Spend(p) = 1
                    if i = 0
                        ft[f].pot1 = ft[f].pot1 + 1
                    elseif i = 1
                        ft[f].pot2 = ft[f].pot2 + 1
                    else
                        ft[f].pot3 = ft[f].pot3 + 1
                    endif
                    SetMsg(ptN[i] + " ostettu.")
                endif
            endif
            y = y + 36
        next i
    else
        n = ft[f].wPot + 1
        if n <= 3
            p = Pr(rnW[n] - rnW[ft[f].wPot], IX_WEAP)
            if ShopRow(y, "Aseen teho +" + Str(n), "+" + Str(n) + " osumaan (item bonus)", p, 0, 1) = 1
                if Spend(p) = 1
                    ft[f].wPot = n
                    SetMsg("Riimu kaiverrettu.")
                endif
            endif
        endif
        y = y + 36
        n = ft[f].wStrk + 1
        if n <= 3
            p = Pr(rnS[n] - rnS[ft[f].wStrk], IX_WEAP)
            if ShopRow(y, "Iskuriimu " + Str(n), "iskunopat " + Str(1 + n) + " kpl", p, 0, 1) = 1
                if Spend(p) = 1
                    ft[f].wStrk = n
                    SetMsg("Riimu kaiverrettu.")
                endif
            endif
        endif
        y = y + 36
        n = ft[f].aPot + 1
        if n <= 3
            p = Pr(rnA[n] - rnA[ft[f].aPot], IX_ARM)
            if ShopRow(y, "Panssarin teho +" + Str(n), "+" + Str(n) + " AC", p, 0, 1) = 1
                if Spend(p) = 1
                    ft[f].aPot = n
                    SetMsg("Riimu kaiverrettu.")
                endif
            endif
        endif
        y = y + 36
        n = ft[f].aRes + 1
        if n <= 3
            p = Pr(rnR[n] - rnR[ft[f].aRes], IX_ARM)
            if ShopRow(y, "Kest{a}v{a}" + " " + Str(n), "+" + Str(n) + " kaikkiin pelastusheittoihin", p, 0, 1) = 1
                if Spend(p) = 1
                    ft[f].aRes = n
                    SetMsg("Riimu kaiverrettu.")
                endif
            endif
        endif
    endif
endfunction

// ----------------------------------------------------------------------------
//  Tilat
// ----------------------------------------------------------------------------
function ScreenFacil()
    k as integer
    lv as integer
    y as float
    cost as integer
    en as integer
    s as string
    UiHeader("Tilat ja rakennukset")
    if UiButton(1090, 8, 120, 40, "Takaisin") = 1
        scr = SC_HUB
    endif
    for k = 0 to 4
        y = 80 + k * 110
        lv = FacLevel(k)
        UiPanel(20, y, 1240, 100)
        UiText(40, y + 10, 24, facN[k] + "  (taso " + Str(lv) + " / 3)", 240, 215, 140, 0)
        UiText(40, y + 46, 17, FacEffect(k), 225, 212, 180, 0)
        UiText(40, y + 70, 15, "Yll{a}pito: 1 kr / taso / viikko", 180, 170, 150, 0)
        if lv < 3
            cost = FacCost(k, lv)
            en = 1
            if gold < cost
                en = 0
            endif
            if UiBtn(960, y + 28, 270, 46, "Paranna: " + Money(cost), en, "") = 1
                gold = gold - cost
                wkOut = wkOut + cost
                SetFacLevel(k, lv + 1)
                SetMsg(facN[k] + " parannettu!")
            endif
        else
            UiBtn(960, y + 28, 270, 46, "Taso t{a}ysi", 0, "")
        endif
    next k
endfunction

// ----------------------------------------------------------------------------
//  Talous
// ----------------------------------------------------------------------------
function ScreenLedger()
    k as integer
    x as float
    h as float
    mx as integer
    v as integer
    en as integer
    s as string
    UiHeader("Talous: kirjanpito, markkinat ja pankki")
    if UiButton(1090, 8, 120, 40, "Takaisin") = 1
        scr = SC_HUB
    endif
    ComputeUpkeep()

    UiPanel(20, 76, 400, 330)
    UiText(36, 84, 20, "Kirjanpito", 235, 195, 95, 0)
    UiText(36, 116, 16, "T{a}ll{a} viikolla:  tulot " + Money(wkIn) + "   menot " + Money(wkOut), 225, 212, 180, 0)
    UiText(36, 140, 16, "Viime viikolla:  tulot " + Money(lastIn) + "   menot " + Money(lastOut), 225, 212, 180, 0)
    UiText(36, 172, 16, "Seuraavan viikon kulut:", 245, 215, 150, 0)
    UiText(36, 194, 15, "Palkat " + Money(upW) + "    Ruoka " + Money(upF), 205, 195, 170, 0)
    UiText(36, 214, 15, "Vuokra " + Money(upR) + "    Tilat " + Money(upB), 205, 195, 170, 0)
    UiText(36, 234, 15, "Lainan korko " + Money(upI) + "    Yhteens{a} " + Money(upTot), 205, 195, 170, 0)
    UiText(36, 266, 16, "Nettotulos, 8 viimeist{a} viikkoa:", 245, 215, 150, 0)
    mx = 1000
    for k = 0 to 7
        mx = IMax(mx, IAbs(histNet[k]))
    next k
    for k = 0 to 7
        x = 40 + k * 44
        h = 50.0 * histNet[k] / mx
        if h >= 0
            UiRect(x, 350 - h, 32, IMax(1, Trunc(h)), 90, 190, 100, 255)
        else
            UiRect(x, 350, 32, IMax(1, Trunc(-h)), 210, 90, 80, 255)
        endif
    next k
    UiRect(36, 350, 360, 2, 130, 110, 80, 255)

    UiPanel(440, 76, 400, 330)
    UiText(456, 84, 20, "Markkinat", 235, 195, 95, 0)
    UiText(456, 120, 15, "Aseet " + Str(Trunc(mkt[IX_WEAP] * 100)) + " %", 225, 212, 180, 0)
    UiBar(600, 122, 220, 14, mkt[IX_WEAP] / 1.8, 200, 160, 60)
    UiText(456, 150, 15, "Panssarit " + Str(Trunc(mkt[IX_ARM] * 100)) + " %", 225, 212, 180, 0)
    UiBar(600, 152, 220, 14, mkt[IX_ARM] / 1.8, 200, 160, 60)
    UiText(456, 180, 15, "Juomat " + Str(Trunc(mkt[IX_POT] * 100)) + " %", 225, 212, 180, 0)
    UiBar(600, 182, 220, 14, mkt[IX_POT] / 1.8, 200, 160, 60)
    UiText(456, 210, 15, "Ruoka " + Str(Trunc(mkt[IX_FOOD] * 100)) + " %", 225, 212, 180, 0)
    UiBar(600, 212, 220, 14, mkt[IX_FOOD] / 1.8, 200, 160, 60)
    UiText(456, 240, 15, "Taistelijat " + Str(Trunc(mkt[IX_TALENT] * 100)) + " %", 225, 212, 180, 0)
    UiBar(600, 242, 220, 14, mkt[IX_TALENT] / 1.8, 200, 160, 60)
    UiText(456, 280, 15, "Yleis{o}n kysynt{a} " + Str(Trunc(demand * 100)) + " %", 240, 215, 140, 0)
    UiBar(600, 282, 220, 14, demand / 1.6, 90, 170, 220)
    UiText(456, 320, 14, "Hinnat palaavat kohti 100 %:a, mutta tapahtumat", 180, 170, 150, 0)
    UiText(456, 340, 14, "heilauttavat niit{a} viikoittain.", 180, 170, 150, 0)

    UiPanel(860, 76, 400, 330)
    UiText(876, 84, 20, "Pankki (korko 3 % / vk)", 235, 195, 95, 0)
    UiText(876, 116, 17, "Velka: " + Money(debt) + "   (raja 2000 kr)", 225, 212, 180, 0)
    en = 1
    if debt + 10000 > 200000
        en = 0
    endif
    if UiBtn(876, 150, 170, 40, "Lainaa 100 kr", en, "") = 1
        debt = debt + 10000
        gold = gold + 10000
        wkIn = wkIn + 10000
    endif
    en = 1
    if debt + 50000 > 200000
        en = 0
    endif
    if UiBtn(1060, 150, 170, 40, "Lainaa 500 kr", en, "") = 1
        debt = debt + 50000
        gold = gold + 50000
        wkIn = wkIn + 50000
    endif
    en = 0
    if debt >= 10000 and gold >= 10000
        en = 1
    endif
    if UiBtn(876, 200, 170, 40, "Maksa 100 kr", en, "") = 1
        debt = debt - 10000
        gold = gold - 10000
        wkOut = wkOut + 10000
    endif
    en = 0
    if debt >= 50000 and gold >= 50000
        en = 1
    endif
    if UiBtn(1060, 200, 170, 40, "Maksa 500 kr", en, "") = 1
        debt = debt - 50000
        gold = gold - 50000
        wkOut = wkOut + 50000
    endif
    UiText(876, 256, 18, "Lipun hinta (porttitulo):", 235, 195, 95, 0)
    for k = 0 to 3
        en = 1
        if k = ticketLv
            en = 2
        endif
        if k = 0
            s = "Halpa"
        elseif k = 1
            s = "Normaali"
        elseif k = 2
            s = "Korkea"
        else
            s = "Ylh{a}inen"
        endif
        if UiBtn(876 + Mod(k, 2) * 184, 284 + Trunc(k / 2.0) * 46, 174, 40, s, en, "Vaikuttaa yleis{o}m{a}{a}r{a}{a}n ja tuloon. Maine tekee yleis{o}st{a} hintaj{a}mm{a}n.") = 1
            ticketLv = k
        endif
    next k

    UiPanel(20, 420, 1240, 230)
    UiText(36, 428, 20, "Sponsorit  (nykyinen: " + spN[sponsor] + ")", 235, 195, 95, 0)
    UiText(36, 456, 15, "Sponsori maksaa viikkopalkkion, mutta p{a}{a}ttyy jos kilta ei taistele kolmeen viikkoon.", 190, 180, 160, 0)
    for k = 0 to 3
        en = 1
        if fame < spF[k]
            en = 0
        endif
        if k = sponsor
            en = 2
        endif
        s = spN[k]
        if k > 0
            s = s + " (" + Str(spB[k] + Trunc(fame / 25.0)) + " kr / vk, maine " + Str(spF[k]) + "+)"
        endif
        if UiBtn(36, 486 + k * 38, 560, 32, s, en, "") = 1
            sponsor = k
            sponsorIdle = 0
        endif
    next k
endfunction
