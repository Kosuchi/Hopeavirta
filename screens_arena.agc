// ============================================================================
//  screens_arena.agc  -  areena (otteluvalinta), tulosten kasittely, loppuruutu
// ============================================================================

function AddRes(s as string)
    if resN < 17
        resLine[resN] = s
        resN = resN + 1
    endif
endfunction

function SelCount()
    i as integer
    n as integer
    n = 0
    for i = 0 to MAXFT - 1
        if ft[i].used = 1 and ft[i].sel = 1
            n = n + 1
        endif
    next i
endfunction n

function ClearSel()
    i as integer
    for i = 0 to MAXFT - 1
        ft[i].sel = 0
    next i
endfunction

function ScreenArena()
    c as integer
    k as integer
    i as integer
    r as integer
    y as float
    x as float
    en as integer
    m as integer
    n as integer
    purse as integer
    s as string
    UiHeader("Areena: Suuri Keh{a}")
    if UiButton(1090, 8, 120, 40, "Takaisin") = 1
        ClearSel()
        scr = SC_HUB
    endif

    for c = 0 to MAXCARD - 1
        y = 70 + c * 88
        if card[c].used = 1
            UiPanel(20, y, 400, 80)
            UiText(34, y + 6, 18, card[c].name, 240, 215, 140, 0)
            UiText(34, y + 30, 14, card[c].foe + "  -  " + TierName(card[c].tier), 205, 195, 170, 0)
            UiText(34, y + 52, 14, Str(card[c].n) + " vs " + Str(card[c].ne) + "    Palkinto " + Money(card[c].purse), 245, 215, 150, 0)
            en = 1
            if c = cardSel
                en = 2
            endif
            if UiBtn(320, y + 22, 90, 36, "Valitse", en, "") = 1
                cardSel = c
                ClearSel()
            endif
        elseif card[c].name <> ""
            UiPanel(20, y, 400, 80)
            UiText(34, y + 30, 16, card[c].name + " (pelattu)", 130, 120, 110, 0)
        endif
    next c

    c = cardSel
    if card[c].used = 0
        UiPanel(440, 70, 820, 90)
        UiText(456, 100, 20, "Valitse ottelu vasemmalta.", 225, 212, 180, 0)
        exitfunction
    endif

    purse = card[c].purse
    if bloodOn = 1 and card[c].champ = 0
        purse = Trunc(purse * 1.5)
    endif
    UiPanel(440, 70, 820, 590)
    UiText(456, 78, 26, card[c].name, 240, 215, 140, 0)
    UiText(456, 112, 17, "Vastustaja: " + card[c].foe + "     Vaikeus: " + TierName(card[c].tier) + "     " + Str(card[c].n) + " vs " + Str(card[c].ne), 225, 212, 180, 0)
    for k = 0 to card[c].ne - 1
        m = cardEn[c,k]
        UiText(456, 140 + k * 18, 15, mnN[m] + "  (taso " + Str(mnLv[m]) + ", " + Str(MonHP(mnHP[m], mnLv[m])) + " HP, AC " + Str(MonAC(mnAC[m], mnLv[m])) + ")", 255, 170, 150, 0)
    next k
    UiText(860, 140, 16, "Yleis{o}: " + Str(Attendance(c)) + "  (katsomo " + Str(capT[facS]) + ")", 225, 212, 180, 0)
    UiText(860, 162, 16, "Lipun hinta: " + Money(TicketCp()), 225, 212, 180, 0)
    UiText(860, 184, 16, "Porttitulo (osuutesi): " + Money(GateCp(c)), 225, 212, 180, 0)
    UiText(860, 206, 16, "Palkinto voitosta: " + Money(purse), 245, 215, 150, 0)
    UiText(860, 228, 16, "XP / taistelija: " + Str(Trunc(card[c].xp * 4.0 / card[c].n)), 190, 220, 255, 0)

    UiText(456, 262, 16, "Lipun hinta:", 235, 195, 95, 0)
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
        if UiBtn(600 + k * 160, 256, 150, 32, s, en, "") = 1
            ticketLv = k
        endif
    next k

    UiText(456, 304, 16, "Veto (kerroin x" + Str(CardOdds(c), 2) + "):", 235, 195, 95, 0)
    for k = 0 to 4
        en = 1
        if k = betLv
            en = 2
        endif
        if stakeT[k] > gold
            en = 0
        endif
        s = "Ei vetoa"
        if k > 0
            s = Money(stakeT[k])
        endif
        if UiBtn(600 + k * 128, 298, 122, 32, s, en, "Voitat vedon jos kilta voittaa ottelun") = 1
            betLv = k
        endif
    next k

    en = 1
    if card[c].champ = 1
        en = 0
    elseif bloodOn = 1
        en = 2
    endif
    s = "Verikeh{a}: POIS"
    if bloodOn = 1 and card[c].champ = 0
        s = "Verikeh{a}: P{A}{A}LL{A}"
    endif
    if UiBtn(456, 342, 250, 34, s, en, "Palkinto x1.5 ja maine x1.5, mutta kaatuneet voivat kuolla") = 1
        if bloodOn = 1
            bloodOn = 0
        else
            bloodOn = 1
        endif
    endif
    UiText(720, 350, 14, "Kaatuneet vakiintuvat vain arenan l{a}{a}k{a}reiden ansiosta, jos ei verikeh{a}{a}.", 180, 170, 150, 0)

    n = SelCount()
    UiText(456, 392, 17, "Valitse " + Str(card[c].n) + " taistelijaa  (valittu " + Str(n) + ")", 235, 195, 95, 0)
    r = 0
    for i = 0 to MAXFT - 1
        if ft[i].used = 1
            x = 456 + Mod(r, 2) * 400
            y = 418 + Trunc(r / 2.0) * 30
            s = ft[i].name + "  " + Str(ft[i].level) + "  " + FirstWord(clN[ft[i].cls])
            en = 1
            if ft[i].injury > 0
                en = 0
                s = ft[i].name + "  vammautunut"
            elseif ft[i].fought = 1
                en = 0
                s = ft[i].name + "  levossa"
            elseif ft[i].sel = 1
                en = 2
            endif
            if UiBtn(x, y, 390, 28, s, en, "HP " + Str(ft[i].hp) + "/" + Str(MaxHPf(i)) + "  AC " + Str(FAC(i)) + "  " + wpN[ft[i].weapon]) = 1
                if ft[i].sel = 1
                    ft[i].sel = 0
                elseif n < card[c].n
                    ft[i].sel = 1
                endif
            endif
            r = r + 1
        endif
    next i

    en = 0
    if n = card[c].n
        en = 1
    endif
    if UiBtn(20, 540, 400, 60, "Taisteluun!", en, "") = 1
        if stakeT[betLv] > gold
            SetMsg("Ei varaa vetoon.")
        else
            bStake = stakeT[betLv]
            SetupBattle(c)
            scr = SC_BATTLE
        endif
    endif
endfunction

// ----------------------------------------------------------------------------
//  Tulokset: kolikot, maine, XP, vammat ja kuolemat
// ----------------------------------------------------------------------------
function ApplyResults()
    c as integer
    i as integer
    lv as integer
    win as integer
    xpEach as integer
    purse as integer
    gate as integer
    bet as integer
    dF as integer
    dead as integer
    nat as integer
    dg as integer
    mult as float
    nm as string
    win = 0
    if bOver = 1
        win = 1
    endif
    resN = 0
    resWin = win
    mult = 1.0
    if bBlood = 1
        mult = 1.5
    endif
    purse = 0
    if win = 1
        purse = Trunc(card[bCard].purse * mult)
    endif
    gate = GateCp(bCard)
    if win = 1
        AddRes("VOITTO! " + card[bCard].name + " (" + card[bCard].foe + ")")
    else
        AddRes("TAPPIO. " + card[bCard].name + " (" + card[bCard].foe + ")")
    endif
    if bYield = 1
        AddRes("Antauduit: yleis{o} h{a}ik{a}ilee.")
    endif
    gold = gold + purse + gate
    wkIn = wkIn + purse + gate
    if win = 1
        Sfx(S_WIN, 90)
        Sfx(S_COIN, 60)
    else
        Sfx(S_LOSE, 80)
    endif
    AddRes("Palkinto " + Money(purse) + "    Porttitulo " + Money(gate))

    if bStake > 0
        if win = 1
            bet = Trunc(bStake * (CardOdds(bCard) - 1.0))
            gold = gold + bet
            wkIn = wkIn + bet
            AddRes("Veto voitti: +" + Money(bet))
        else
            gold = gold - bStake
            wkOut = wkOut + bStake
            AddRes("Veto h{a}visi: -" + Money(bStake))
        endif
    endif

    if win = 1
        dF = Trunc((5 + 6 * card[bCard].tier) * mult)
        if card[bCard].champ = 1
            dF = dF * 3
        endif
    else
        dF = -3
        if bYield = 1
            dF = -6
        endif
    endif
    fame = IMax(0, fame + dF)
    AddRes("Maine " + SignStr(dF) + "  (nyt " + Str(fame) + ")")
    sponsorIdle = 0

    xpEach = Trunc(bXP * 4.0 / bNPl)
    if win = 0
        xpEach = Trunc(xpEach / 4.0)
    endif

    for c = 0 to cmN - 1
        if cm[c].used = 1 and cm[c].side = 0
            i = cm[c].src
            nm = FirstWord(ft[i].name)
            dead = cm[c].dead
            if cm[c].down = 1 and dead = 0 and cm[c].dying > 0
                if bBlood = 1 and bYield = 0
                    nat = D20()
                    dg = Degree(nat, 10 + cm[c].dying, nat)
                    if dg <= 1
                        dead = 1
                    else
                        cm[c].wounded = cm[c].wounded + 1
                    endif
                else
                    cm[c].wounded = cm[c].wounded + 1
                endif
            endif
            if dead = 1
                AddRes(nm + " kuoli keh{a}ss{a}. Kilta suree.")
                fame = IMax(0, fame - 10)
                ft[i] = gBlankFt
            else
                ft[i].pot1 = cm[c].pot1
                ft[i].pot2 = cm[c].pot2
                ft[i].pot3 = cm[c].pot3
                ft[i].hp = IMax(1, cm[c].hp)
                ft[i].wounded = cm[c].wounded
                if cm[c].down = 1
                    ft[i].injury = RI(1, 3) + IMin(2, cm[c].wounded - 1)
                    AddRes(nm + " loukkaantui: toipuu " + Str(ft[i].injury) + " viikossa.")
                endif
                ft[i].xp = ft[i].xp + xpEach
                ft[i].fought = 1
                if win = 1
                    ft[i].wins = ft[i].wins + 1
                    ft[i].pop = IMin(100, ft[i].pop + RI(2, 6))
                else
                    ft[i].losses = ft[i].losses + 1
                endif
                lv = CheckLevel(i)
                if lv > 0
                    AddRes(nm + " nousi tasolle " + Str(ft[i].level) + "!")
                endif
            endif
        endif
    next c
    AddRes("Kokemus: " + Str(xpEach) + " XP / selviytynyt taistelija")
    card[bCard].used = 0
    ClearSel()
    if fame >= 1000
        gameOver = 1
    endif
endfunction

function ScreenResult()
    i as integer
    UiHeader("Ottelun tulos")
    UiPanel(240, 90, 800, 520)
    if resWin = 1
        UiText(640, 104, 40, "VOITTO", 120, 230, 120, 1)
    else
        UiText(640, 104, 40, "TAPPIO", 240, 110, 100, 1)
    endif
    for i = 1 to resN - 1
        UiText(270, 170 + (i - 1) * 28, 18, resLine[i], 235, 225, 200, 0)
    next i
    if UiButton(520, 550, 240, 46, "Jatka") = 1
        if gameOver > 0
            scr = SC_END
        else
            scr = SC_HUB
        endif
    endif
endfunction

function ScreenEnd()
    UiRect(0, 0, SCRW, SCRH, 18, 14, 12, 255)
    if gameOver = 1
        UiText(SCRW / 2, 150, 64, "LEGENDA", 235, 195, 95, 1)
        UiText(SCRW / 2, 240, 24, guildName + " nousi Hopeavirran yl{a}puolelle.", 230, 220, 190, 1)
        UiText(SCRW / 2, 290, 20, "Suuri Keh{a} kantaa nime{a}si viel{a} sadan vuoden p{a}{a}st{a}.", 210, 200, 170, 1)
    else
        UiText(SCRW / 2, 150, 64, "KONKURSSI", 240, 110, 100, 1)
        UiText(SCRW / 2, 240, 24, "Velkojat veiv{a}t kiltatalon ja viimeisetkin miekat.", 230, 220, 190, 1)
        UiText(SCRW / 2, 290, 20, "Keh{a}n portit sulkeutuvat " + guildName + " kohdalta.", 210, 200, 170, 1)
    endif
    UiText(SCRW / 2, 360, 20, "Viikkoja: " + Str(week) + "     Maine: " + Str(fame), 225, 212, 180, 1)
    if UiButton(SCRW / 2 - 150, 450, 300, 56, "Takaisin otsikkoon") = 1
        scr = SC_TITLE
    endif
endfunction
