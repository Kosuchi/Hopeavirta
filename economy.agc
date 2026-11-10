// ============================================================================
//  economy.agc  -  markkinatalous, lipputulot, vedonlyonti, ottelut ja viikkokierto
//
//  Hopeavirran talous: markkinahinnat elavat satunnaiskavelyna (palaavat kohti
//  1.0:aa) ja tapahtumat shokkaavat niita. Yleison kysynta, lipun hinta,
//  katsomot ja maine maaraavat portin tulot. Palkat, ruoka, vuokra,
//  tilojen yllapito ja lainankorko maksetaan joka viikko.
// ============================================================================

function InitEconomyTables()
    pgp[0] = 6
    pgp[1] = 10
    pgp[2] = 14
    pgp[3] = 24
    pgp[4] = 40
    pgp[5] = 68
    pgp[6] = 108
    pgp[7] = 160
    pgp[8] = 232
    pgp[9] = 320
    pgp[10] = 456
    pgp[11] = 640
    tierMul[0] = 0.7
    tierMul[1] = 1.0
    tierMul[2] = 1.7
    tierMul[3] = 2.8
    oddsT[0] = 1.25
    oddsT[1] = 1.8
    oddsT[2] = 2.8
    oddsT[3] = 4.5
    hypeT[0] = 0.8
    hypeT[1] = 1.0
    hypeT[2] = 1.3
    hypeT[3] = 1.7
    capT[0] = 250
    capT[1] = 500
    capT[2] = 900
    capT[3] = 1500
    tkM[0] = 0.5
    tkM[1] = 1.0
    tkM[2] = 1.5
    tkM[3] = 2.2
    spN[0] = "Ei sponsoria"
    spN[1] = "Harmaakorppi-pankki"
    spN[2] = "Villakauppiaiden kilta"
    spN[3] = "Panimomestarien kilta"
    spB[0] = 0
    spB[1] = 4
    spB[2] = 6
    spB[3] = 8
    spF[0] = 0
    spF[1] = 0
    spF[2] = 60
    spF[3] = 150
    facN[0] = "Kasarmi"
    facN[1] = "Harjoitussali"
    facN[2] = "Sairaala"
    facN[3] = "Katsomot"
    facN[4] = "Sepp{a}"
    stakeT[0] = 0
    stakeT[1] = 500
    stakeT[2] = 2000
    stakeT[3] = 5000
    stakeT[4] = 15000
endfunction

function FacLevel(k as integer)
    r as integer
    r = facB
    if k = 1
        r = facT
    elseif k = 2
        r = facI
    elseif k = 3
        r = facS
    elseif k = 4
        r = facW
    endif
endfunction r

function SetFacLevel(k as integer, v as integer)
    if k = 0
        facB = v
    elseif k = 1
        facT = v
    elseif k = 2
        facI = v
    elseif k = 3
        facS = v
    else
        facW = v
    endif
endfunction

// parannuksen hinta (kuparia): taso 0->1 x1, 1->2 x2.7, 2->3 x6
function FacCost(k as integer, lvl as integer)
    b as integer
    m as float
    r as integer
    b = 150
    if k = 1
        b = 200
    elseif k = 2
        b = 120
    elseif k = 3
        b = 250
    elseif k = 4
        b = 180
    endif
    m = 1.0
    if lvl = 1
        m = 2.7
    elseif lvl = 2
        m = 6.0
    endif
    r = Trunc(b * m * 100)
endfunction r

function FacEffect(k as integer)
    s as string
    if k = 0
        s = "Paikkoja: " + Str(BarracksCap()) + " taistelijaa"
    elseif k = 1
        s = "Harjoitus: +" + Str(50 + 25 * facT) + " XP / viikko"
    elseif k = 2
        s = "Toipuminen: " + Str(1 + facI) + " viikkoa / viikko"
    elseif k = 3
        s = "Katsomo: " + Str(capT[facS]) + " paikkaa"
    else
        s = "Alennus kaupassa: " + Str(5 * facW) + " %"
    endif
endfunction s

// ----------------------------------------------------------------------------
//  Lipputulot, palkinnot, kertoimet
// ----------------------------------------------------------------------------
function TicketCp()
    r as integer
    r = Trunc((15 + cardRef * 10) * tkM[ticketLv])
endfunction r

function Attendance(c as integer)
    raw as float
    k as float
    f as float
    r as integer
    raw = (100 + fame * 5) * demand * hypeT[card[c].tier] * (1.0 + 0.1 * (card[c].n - 1))
    if card[c].champ = 1
        raw = raw * 2.2
    endif
    k = FMax(0.2, 0.9 - fame / 1200.0)
    f = FMax(0.15, 1.0 + (1.0 - tkM[ticketLv]) * k)
    raw = FMin(raw * f, capT[facS])
    r = Trunc(raw)
endfunction r

function GateCp(c as integer)
    r as integer
    r = Trunc(Attendance(c) * TicketCp() * 0.3)
endfunction r

function PurseCp(c as integer)
    f as float
    r as integer
    f = pgp[LvIdx(cardRef)] * 100.0 * tierMul[card[c].tier] * (1.0 + 0.15 * (card[c].n - 1)) * (0.7 + 0.3 * demand)
    if card[c].champ = 1
        f = f * 4
    endif
    r = Trunc(f)
endfunction r

function CardOdds(c as integer)
    r as float
    r = oddsT[card[c].tier]
endfunction r

function SponsorPay()
    r as integer
    r = 0
    if sponsor > 0
        r = (spB[sponsor] + Trunc(fame / 25.0)) * 100
    endif
endfunction r

function ComputeUpkeep()
    i as integer
    n as integer
    upW = 0
    n = 0
    for i = 0 to MAXFT - 1
        if ft[i].used = 1
            upW = upW + ft[i].wage
            n = n + 1
        endif
    next i
    upF = n * Trunc(100 * mkt[IX_FOOD])
    upR = 500
    upB = (facB + facT + facI + facS + facW) * 150
    upI = Trunc(debt * 0.03)
    upTot = upW + upF + upR + upB + upI
endfunction

// ----------------------------------------------------------------------------
//  Koulutus ja hoito
// ----------------------------------------------------------------------------
function TrainCost(i as integer)
    r as integer
    r = Trunc((ft[i].level + 1) * 150 * mkt[IX_TALENT])
endfunction r

function HealCost(i as integer)
    r as integer
    r = Trunc(300 * (ft[i].level + 1) * mkt[IX_POT])
endfunction r

// palauttaa kuinka monta tasoa nousi
function CheckLevel(i as integer)
    n as integer
    n = 0
    while ft[i].xp >= 1000 and ft[i].level < 10
        ft[i].xp = ft[i].xp - 1000
        LevelUpOnce(i)
        n = n + 1
    endwhile
    if n > 0
        ft[i].hp = MaxHPf(i)
        Sfx(S_LEVEL, 80)
    endif
endfunction n

// ----------------------------------------------------------------------------
//  Rekrytointi ja otteluohjelma
// ----------------------------------------------------------------------------
function RefreshRecruits()
    k as integer
    s as integer
    maxL as integer
    lvl as integer
    maxL = Clampi(1 + Trunc(fame / 90.0), 1, 9)
    for k = 0 to NREC - 1
        s = RECBASE + k
        lvl = RI(IMax(1, maxL - 2), maxL)
        MakeFighter(s, RI(0, 4), RI(0, 7), lvl)
        ft[s].pop = ft[s].pop + Trunc(fame / 10.0)
    next k
endfunction

function BuildEnemies(c as integer)
    n as integer
    budLeft as integer
    maxE as integer
    kind as integer
    tries as integer
    m as integer
    diff as integer
    xp as integer
    total as integer
    best as integer
    card[c].ne = 0
    total = 0
    n = card[c].n
    budLeft = Budget(card[c].tier, n)
    maxE = IMin(6, n + 2)
    kind = card[c].kind
    for tries = 1 to 80
        if card[c].ne < maxE and budLeft >= 10
            m = RI(0, NMON - 1)
            if mnKd[m] = kind
                diff = mnLv[m] - cardRef
                if diff >= -4 and diff <= 4
                    xp = XPDiff(diff)
                    if xp <= budLeft
                        cardEn[c,card[c].ne] = m
                        card[c].ne = card[c].ne + 1
                        budLeft = budLeft - xp
                        total = total + xp
                    endif
                endif
            endif
        endif
    next tries
    if card[c].ne = 0
        best = -1
        for m = 0 to NMON - 1
            if mnKd[m] = kind
                if best < 0
                    best = m
                elseif mnLv[m] < mnLv[best]
                    best = m
                endif
            endif
        next m
        cardEn[c,0] = best
        card[c].ne = 1
        total = IMax(10, XPDiff(mnLv[best] - cardRef))
    endif
    card[c].xp = total
endfunction

function GenerateCards()
    c as integer
    r as integer
    cnt as integer
    cardRef = RefLevel()
    cnt = 4
    if Mod(week, 13) = 0
        cnt = 5
    endif
    for c = 0 to 4
        card[c] = gBlankCard
    next c
    for c = 0 to cnt - 1
        card[c].used = 1
        card[c].champ = 0
        r = RI(1, 10)
        if r <= 3
            card[c].n = 1
        elseif r <= 6
            card[c].n = 2
        elseif r <= 8
            card[c].n = 3
        else
            card[c].n = 4
        endif
        card[c].tier = Clampi(Trunc(fame / 200.0) + RI(-1, 1), 0, 3)
        card[c].kind = RI(0, 2)
        card[c].foe = foeN[card[c].kind * 3 + RI(0, 2)]
        card[c].name = btN[card[c].n - 1]
        if c = 4
            card[c].champ = 1
            card[c].n = 4
            card[c].kind = 1
            card[c].tier = Clampi(Trunc(fame / 200.0) + 1, 1, 3)
            card[c].foe = "Hopeavirran mestarit"
            card[c].name = "KAUSIMESTARUUS"
        endif
        BuildEnemies(c)
        card[c].purse = PurseCp(c)
    next c
endfunction

// ----------------------------------------------------------------------------
//  Uusi kilta
// ----------------------------------------------------------------------------
function NewGuild()
    i as integer
    for i = 0 to 21
        ft[i] = gBlankFt
    next i
    for i = 0 to 4
        mkt[i] = 1.0
    next i
    for i = 0 to 7
        histNet[i] = 0
    next i
    gold = 20000
    debt = 0
    week = 1
    fame = 0
    demand = 1.0
    ticketLv = 1
    sponsor = 0
    sponsorIdle = 0
    facB = 0
    facT = 0
    facI = 0
    facS = 0
    facW = 0
    wkIn = 0
    wkOut = 0
    lastIn = 0
    lastOut = 0
    gameOver = 0
    msgT = 0
    selFt = 0
    shopCat = 0
    shopFt = 0
    cardSel = 0
    betLv = 0
    bloodOn = 0
    rosterPage = 0
    i = RI(0, 4)
    if i = 0
        guildName = "Harmaan Joen Veljeskunta"
    elseif i = 1
        guildName = "Hopeavirran Rautakilta"
    elseif i = 2
        guildName = "Punaisen Sulan Seura"
    elseif i = 3
        guildName = "Vanhan Linnan Kilta"
    else
        guildName = "Mustan Sillan Taistelijat"
    endif
    news[0] = "Kilta perustettu. Kaupunki odottaa uusia taistelijoita."
    news[1] = ""
    news[2] = ""
    news[3] = ""
endfunction

// ----------------------------------------------------------------------------
//  Viikon vaihtuminen
// ----------------------------------------------------------------------------
function MarketTick()
    k as integer
    ev as integer
    for k = 0 to 4
        mkt[k] = mkt[k] + (1.0 - mkt[k]) * 0.25 + RF(-0.03, 0.03)
    next k
    demand = demand + (1.0 - demand) * 0.3 + RF(-0.05, 0.05)
    ev = RI(0, 9)
    if ev = 1
        mkt[IX_FOOD] = mkt[IX_FOOD] * 1.25
        demand = demand - 0.05
    elseif ev = 2
        mkt[IX_FOOD] = mkt[IX_FOOD] * 0.85
        demand = demand + 0.1
    elseif ev = 3
        mkt[IX_WEAP] = mkt[IX_WEAP] * 1.2
        mkt[IX_ARM] = mkt[IX_ARM] * 1.2
    elseif ev = 4
        demand = demand + 0.25
    elseif ev = 5
        demand = demand - 0.3
        mkt[IX_POT] = mkt[IX_POT] * 1.3
    elseif ev = 6
        demand = demand + 0.2
    elseif ev = 7
        mkt[IX_WEAP] = mkt[IX_WEAP] * 0.9
        mkt[IX_ARM] = mkt[IX_ARM] * 0.9
        mkt[IX_POT] = mkt[IX_POT] * 0.9
    elseif ev = 8
        mkt[IX_TALENT] = mkt[IX_TALENT] * 1.15
        demand = demand - 0.1
    elseif ev = 9
        demand = demand + 0.05
    endif
    for k = 0 to 4
        mkt[k] = Clampf(mkt[k], 0.6, 1.8)
    next k
    demand = Clampf(demand, 0.5, 1.6)
    news[0] = evN[ev]
    news[1] = "Yleis{o}n kiinnostus: " + Str(Trunc(demand * 100)) + " %   Ruoka: " + Str(Trunc(mkt[IX_FOOD] * 100)) + " %   Aseet: " + Str(Trunc(mkt[IX_WEAP] * 100)) + " %"
endfunction

function EndWeek()
    i as integer
    healed as integer
    pay as integer
    ComputeUpkeep()
    wkOut = wkOut + upTot
    gold = gold - upTot
    news[2] = ""
    news[3] = ""

    if sponsor > 0
        pay = SponsorPay()
        gold = gold + pay
        wkIn = wkIn + pay
        sponsorIdle = sponsorIdle + 1
        if sponsorIdle >= 3
            news[2] = spN[sponsor] + " p{a}{a}tti sopimuksen: kilta ei ole taistellut."
            sponsor = 0
            fame = IMax(0, fame - 15)
        endif
    endif

    healed = 0
    for i = 0 to MAXFT - 1
        if ft[i].used = 1
            ft[i].trained = 0
            ft[i].fought = 0
            if ft[i].injury > 0
                ft[i].injury = IMax(0, ft[i].injury - (1 + facI))
                if ft[i].injury = 0
                    ft[i].wounded = 0
                    ft[i].hp = MaxHPf(i)
                    healed = healed + 1
                endif
            else
                ft[i].hp = MaxHPf(i)
                ft[i].wounded = 0
            endif
        endif
    next i
    if healed > 0
        news[3] = Str(healed) + " taistelijaa toipui vammoistaan."
    endif

    for i = 0 to 6
        histNet[i] = histNet[i + 1]
    next i
    histNet[7] = wkIn - wkOut
    lastIn = wkIn
    lastOut = wkOut
    wkIn = 0
    wkOut = 0

    week = week + 1
    Sfx(S_BELL, 70)
    MarketTick()
    RefreshRecruits()
    GenerateCards()
    cardSel = 0
    betLv = 0

    if gold < -30000
        gameOver = 2
    endif
    if fame >= 1000
        gameOver = 1
    endif
endfunction
