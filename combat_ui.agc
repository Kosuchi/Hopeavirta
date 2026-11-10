// ============================================================================
//  combat_ui.agc  -  taistelunakyma: ruudukko, hahmot, toimintopainikkeet
// ============================================================================

function ActCost(mode as integer)
    r as integer
    r = 1
    if mode = MD_POWER or mode = MD_ARC or mode = MD_BARR or mode = MD_FIRE
        r = 2
    endif
endfunction r

function ValidTarget(mode as integer, a as integer, t as integer)
    r as integer
    d as integer
    r = 0
    if t < 0
        exitfunction r
    endif
    d = Dist(cm[a].x, cm[a].y, cm[t].x, cm[t].y)
    if mode = MD_LAY
        if cm[t].side = cm[a].side and cm[t].dead = 0 and d <= 1
            r = 1
        endif
    elseif cm[t].side <> cm[a].side and cm[t].dead = 0
        if mode = MD_STRIKE or mode = MD_POWER
            if d <= cm[a].reach
                r = 1
            endif
        elseif mode = MD_TRIP or mode = MD_FEINT
            if cm[a].ranged = 0 and d <= cm[a].reach
                r = 1
            endif
        elseif mode = MD_DEMO or mode = MD_ARC
            if d <= 6
                r = 1
            endif
        elseif mode = MD_BARR
            if d <= 12
                r = 1
            endif
        elseif mode = MD_FIRE
            if d <= 8
                r = 1
            endif
        endif
    endif
endfunction r

function ModeHelp(mode as integer)
    s as string
    s = ""
    if mode = MD_STRIKE
        s = "Valitse vihollinen, jota iske{a} (kantamalla olevat n{a}kyv{a}t punaisina)"
    elseif mode = MD_MOVE
        s = "Valitse vihre{a} ruutu johon liikut"
    elseif mode = MD_TRIP
        s = "Valitse vihollinen kaadettavaksi (Athletics vs Reflex DC)"
    elseif mode = MD_DEMO
        s = "Valitse vihollinen peloteltavaksi (Intimidation vs Will DC, 6 ruutua)"
    elseif mode = MD_POWER
        s = "Voimaisku (2 toimintoa): valitse vihollinen"
    elseif mode = MD_FEINT
        s = "Harhautus (Deception vs Perception DC): valitse vihollinen vierest{a}"
    elseif mode = MD_LAY
        s = "Lay on Hands: valitse liittolainen (viereinen tai itse)"
    elseif mode = MD_ARC
        s = "S{a}hk{o}kaari: valitse kohde (6 ruutua)"
    elseif mode = MD_BARR
        s = "Voimasarja: valitse kohde (12 ruutua)"
    elseif mode = MD_FIRE
        s = "Tulipallo: valitse keskipiste, sade 4 ruutua (osuu my{o}s omiin!)"
    endif
endfunction s

function PerformOnTarget(a as integer, t as integer)
    m as integer
    m = bMode
    if m = MD_STRIKE
        SpendActs(a, 1)
        DoStrike(a, t, 0)
    elseif m = MD_POWER
        SpendActs(a, 2)
        DoStrike(a, t, 1)
    elseif m = MD_TRIP
        SpendActs(a, 1)
        DoTrip(a, t)
    elseif m = MD_DEMO
        SpendActs(a, 1)
        DoDemoralize(a, t)
    elseif m = MD_FEINT
        SpendActs(a, 1)
        DoFeint(a, t)
    elseif m = MD_LAY
        SpendActs(a, 1)
        DoLay(a, t)
    elseif m = MD_ARC
        SpendActs(a, 2)
        CastArc(a, t)
    elseif m = MD_BARR
        SpendActs(a, 2)
        CastBarrage(a, t)
    elseif m = MD_FIRE
        SpendActs(a, 2)
        CastFireball(a, t)
    endif
    bMode = MD_NONE
    CheckEnd()
endfunction

function SetMode(m as integer)
    a as integer
    a = bCur
    bMode = m
    if m = MD_MOVE
        ComputeMove(a)
    endif
endfunction

function HandleBoardClick(cx as integer, cy as integer)
    a as integer
    t as integer
    a = bCur
    if bMode > 0 and cm[a].acts < ActCost(bMode)
        bMode = MD_NONE
        SetMsg("Ei tarpeeksi toimintoja.")
        exitfunction
    endif
    if bMode = MD_MOVE
        if bMv[cx,cy] > 0 and bBlocked[cx,cy] = 0 and CmbAt(cx, cy) = -1
            SpendActs(a, 1)
            DoMove(a, cx, cy)
            AddLog(CName(a) + " liikkuu")
            bMode = MD_NONE
        else
            SetMsg("Sinne ei p{a}{a}se.")
        endif
    elseif bMode > 0
        t = CmbAt(cx, cy)
        if ValidTarget(bMode, a, t) = 1
            PerformOnTarget(a, t)
        else
            SetMsg("Virheellinen kohde.")
        endif
    endif
endfunction

function ActBtn(n as integer, label as string, en as integer, tip as string)
    r as integer
    r = UiBtn(20 + Mod(n, 6) * 132, 596 + Trunc(n / 6.0) * 40, 126, 34, label, en, tip)
endfunction r

function ModeState(m as integer, ok as integer)
    r as integer
    r = 0
    if ok = 1
        r = 1
        if bMode = m
            r = 2
        endif
    endif
endfunction r

function DrawActions()
    a as integer
    n as integer
    ok as integer
    a = bCur
    n = 0
    UiText(20, 577, 14, "Toiminnot: " + CName(a) + "   (" + Str(cm[a].acts) + " / 3)", 230, 200, 130, 0)

    if ActBtn(n, "Isku", ModeState(MD_STRIKE, IMin(1, Trunc(cm[a].acts / 1.0))), "Isku (1): yksi isku. Seuraavat iskut saavat MAP-rangaistuksen -5 / -10") = 1
        SetMode(MD_STRIKE)
    endif
    n = n + 1
    ok = 0
    if cm[a].acts >= 1 and cm[a].prone = 0
        ok = 1
    endif
    if ActBtn(n, "Liiku", ModeState(MD_MOVE, ok), "Stride (1): liiku nopeutesi verran") = 1
        SetMode(MD_MOVE)
    endif
    n = n + 1
    if cm[a].prone = 1
        if ActBtn(n, "Nouse yl{o}s", ModeState(0, IMin(1, cm[a].acts)), "Stand (1): nouse maasta") = 1
            if SpendActs(a, 1) = 1
                DoStand(a)
            endif
        endif
        n = n + 1
    endif
    ok = 0
    if cm[a].hard > 0 and cm[a].shield = 0 and cm[a].acts >= 1
        ok = 1
    endif
    if ActBtn(n, "Kilpi yl{o}s", ModeState(0, ok), "Raise a Shield (1): +2 AC, Shield Block -reaktio") = 1
        if SpendActs(a, 1) = 1
            DoShield(a)
        endif
    endif
    n = n + 1
    ok = 0
    if cm[a].acts >= 1 and cm[a].ranged = 0
        ok = 1
    endif
    if ActBtn(n, "Kaada", ModeState(MD_TRIP, ok), "Trip (1): Athletics vs Reflex DC. Kaatunut on Off-guard") = 1
        SetMode(MD_TRIP)
    endif
    n = n + 1
    if ActBtn(n, "Pelota", ModeState(MD_DEMO, IMin(1, cm[a].acts)), "Demoralize (1): Intimidation vs Will DC -> Frightened") = 1
        SetMode(MD_DEMO)
    endif
    n = n + 1
    ok = 0
    if cm[a].acts >= 1 and PotionCount(a) > 0
        ok = 1
    endif
    if ActBtn(n, "Juoma (" + Str(PotionCount(a)) + ")", ModeState(0, ok), "Juo parannusjuoma (1)") = 1
        if SpendActs(a, 1) = 1
            DoPotion(a)
        endif
    endif
    n = n + 1

    if cm[a].cls = CL_FIGHTER
        if ActBtn(n, "Voimaisku", ModeState(MD_POWER, IMin(1, Trunc(cm[a].acts / 2.0))), "Power Attack (2): +1 vahinkonoppa, lasketaan kahdeksi iskuksi (MAP)") = 1
            SetMode(MD_POWER)
        endif
        n = n + 1
    elseif cm[a].cls = CL_BARB
        ok = 0
        if cm[a].rage = 0 and cm[a].acts >= 1
            ok = 1
        endif
        if ActBtn(n, "Raivo", ModeState(0, ok), "Rage (1): +2 vahinko, v{a}liaikaiset HP, -1 AC") = 1
            if SpendActs(a, 1) = 1
                DoRage(a)
            endif
        endif
        n = n + 1
    elseif cm[a].cls = CL_ROGUE
        ok = 0
        if cm[a].acts >= 1 and cm[a].ranged = 0
            ok = 1
        endif
        if ActBtn(n, "Harhauta", ModeState(MD_FEINT, ok), "Feint (1): Off-guard -> Sneak Attack lis{a}vahinko") = 1
            SetMode(MD_FEINT)
        endif
        n = n + 1
    elseif cm[a].cls = CL_CHAMP
        ok = 0
        if cm[a].lay > 0 and cm[a].acts >= 1
            ok = 1
        endif
        if ActBtn(n, "Parantava k{a}si", ModeState(MD_LAY, ok), "Lay on Hands (1): parantaa viereist{a} liittolaista, nostaa kaatuneen") = 1
            SetMode(MD_LAY)
        endif
        n = n + 1
    elseif cm[a].cls = CL_WIZ
        if ActBtn(n, "S{a}hk{o}kaari", ModeState(MD_ARC, IMin(1, Trunc(cm[a].acts / 2.0))), "Electric Arc (2): perus-Reflex, kaksi kohdetta, ei kuluta paikkaa") = 1
            SetMode(MD_ARC)
        endif
        n = n + 1
        ok = 0
        if cm[a].acts >= 2 and cm[a].slots > 0
            ok = 1
        endif
        if ActBtn(n, "Voimasarja " + Str(cm[a].slots), ModeState(MD_BARR, ok), "Force Barrage (2): automaattiosuma, ammuksia 2+; kuluttaa loitsupaikan") = 1
            SetMode(MD_BARR)
        endif
        n = n + 1
        ok = 0
        if cm[a].acts >= 2 and cm[a].slots > 0 and cm[a].sRank >= 3
            ok = 1
        endif
        if n < 12
            if ActBtn(n, "Tulipallo", ModeState(MD_FIRE, ok), "Fireball (2): aste 3+, sade 4, perus-Reflex, kuluttaa paikan") = 1
                SetMode(MD_FIRE)
            endif
            n = n + 1
        endif
    endif

    if n < 11
        n = 10
    endif
    if ActBtn(10, "Lopeta vuoro", 1, "Lopeta vuoro (nopeat: muista Shield!)") = 1
        EndTurn()
    endif
    if ActBtn(11, "Antaudu", 1, "Antaudu: ottelu h{a}vit{a}{a}n, taistelijat s{a}{a}stet{a}{a}n") = 1
        bYield = 1
        bOver = 2
        bEndT = 0.5
    endif
endfunction

function DrawBattle(dt as float)
    x as integer
    y as integer
    c as integer
    k as integer
    a as integer
    t as integer
    cx as integer
    cy as integer
    px as float
    py as float
    inB as integer
    hv as integer
    ly as float
    ok as integer
    s as string

    // --- logiikka ---
    if bOver = 0
        a = bCur
        if cm[a].side = 1
            bTimer = bTimer - dt
            if bTimer <= 0
                AIStep()
                bTimer = 0.55
            endif
        elseif cm[a].acts <= 0
            bTimer = bTimer - dt
            if bTimer <= 0
                EndTurn()
            endif
        endif
    else
        bEndT = bEndT - dt
    endif
    a = bCur

    // --- tausta ja otsikko ---
    UiRect(0, 0, SCRW, SCRH, 24, 19, 16, 255)
    UiRect(0, 0, SCRW, 56, 52, 41, 30, 255)
    UiRect(0, 56, SCRW, 3, 130, 100, 55, 255)
    UiText(20, 12, 28, card[bCard].name + " - " + card[bCard].foe, 235, 195, 95, 0)
    UiText(SCRW - 20, 8, 17, "Kierros " + Str(bRound), 245, 235, 200, 2)
    UiText(SCRW - 20, 31, 15, "Vuoro: " + CName(a), 200, 185, 150, 2)

    // --- lauta ---
    UiRect(BOARDX - 4, BOARDY - 4, GRIDW * CELL + 8, GRIDH * CELL + 8, 96, 76, 48, 255)
    for x = 0 to GRIDW - 1
        for y = 0 to GRIDH - 1
            px = BOARDX + x * CELL
            py = BOARDY + y * CELL
            if Mod(x + y, 2) = 0
                UiRect(px, py, CELL, CELL, 74, 62, 50, 255)
            else
                UiRect(px, py, CELL, CELL, 66, 55, 45, 255)
            endif
        next y
    next x

    // --- korostukset ---
    if bOver = 0 and cm[a].side = 0
        if bMode = MD_MOVE
            for x = 0 to GRIDW - 1
                for y = 0 to GRIDH - 1
                    if bMv[x,y] > 0 and CmbAt(x, y) = -1
                        UiRect(BOARDX + x * CELL + 2, BOARDY + y * CELL + 2, CELL - 4, CELL - 4, 90, 190, 100, 110)
                    endif
                next y
            next x
        elseif bMode > 0
            for c = 0 to cmN - 1
                if cm[c].used = 1 and cm[c].dead = 0
                    if ValidTarget(bMode, a, c) = 1
                        UiRect(BOARDX + cm[c].x * CELL + 1, BOARDY + cm[c].y * CELL + 1, CELL - 2, CELL - 2, 240, 90, 70, 120)
                    endif
                endif
            next c
        endif
    endif

    // --- pilarit ja hahmot ---
    for x = 0 to GRIDW - 1
        for y = 0 to GRIDH - 1
            if bBlocked[x,y] = 1
                px = BOARDX + x * CELL
                py = BOARDY + y * CELL
                UiRect(px + 4, py + 4, CELL - 8, CELL - 8, 40, 34, 30, 255)
                UiRect(px + 8, py + 8, CELL - 16, CELL - 16, 112, 100, 88, 255)
            endif
        next y
    next x
    for c = 0 to cmN - 1
        if cm[c].used = 1 and cm[c].dead = 0
            DrawToken(c)
        endif
    next c

    // --- hiiri ---
    inB = 0
    cx = Trunc((uiMX - BOARDX) / CELL)
    cy = Trunc((uiMY - BOARDY) / CELL)
    if uiMX >= BOARDX and uiMY >= BOARDY and cx >= 0 and cx < GRIDW and cy >= 0 and cy < GRIDH
        inB = 1
    endif
    bInsp = -1
    if inB = 1
        bInsp = CmbAt(cx, cy)
        UiRect(BOARDX + cx * CELL, BOARDY + cy * CELL, CELL, 3, 250, 230, 140, 200)
        UiRect(BOARDX + cx * CELL, BOARDY + cy * CELL + CELL - 3, CELL, 3, 250, 230, 140, 200)
    endif
    if bMode > 0 and bInsp >= 0 and cm[bCur].side = 0
        if ValidTarget(bMode, a, bInsp) = 1 and (bMode = MD_STRIKE or bMode = MD_POWER)
            uiTip = "Osumatodenn{a}k{o}isyys " + Str(HitChance(a, bInsp)) + " %  (vs AC " + Str(CmbAC(bInsp, a)) + ")"
        endif
    elseif bMode > 0
        uiTip = ModeHelp(bMode)
    endif

    // --- oikea paneeli: aloitusjarjestys ---
    UiPanel(830, BOARDY - 4, 426, 212)
    UiText(842, BOARDY, 15, "Aloitusj{a}rjestys", 230, 195, 110, 0)
    for k = 0 to bOrderN - 1
        c = bOrder[k]
        ly = BOARDY + 20 + k * 15.5
        if c = bCur and bOver = 0
            UiRect(836, ly - 1, 414, 15, 90, 70, 36, 255)
        endif
        if cm[c].dead = 1
            UiText(844, ly, 13, CName(c) + " (kaatunut)", 110, 100, 95, 0)
        else
            if cm[c].side = 0
                UiText(844, ly, 13, CName(c), 150, 200, 255, 0)
            else
                UiText(844, ly, 13, CName(c), 255, 150, 130, 0)
            endif
            UiText(1000, ly, 13, "HP " + Str(cm[c].hp) + "/" + Str(cm[c].hpMax), 220, 210, 190, 0)
            UiText(1110, ly, 13, "AC " + Str(cm[c].ac) + "  L" + Str(cm[c].lvl), 190, 180, 160, 0)
        endif
    next k

    // --- kortti ---
    t = bInsp
    if t < 0
        t = a
    endif
    UiPanel(830, BOARDY + 218, 426, 150)
    UiText(842, BOARDY + 222, 18, cm[t].name + "  (taso " + Str(cm[t].lvl) + ")", 240, 215, 140, 0)
    UiText(842, BOARDY + 246, 14, "HP " + Str(cm[t].hp) + "/" + Str(cm[t].hpMax) + "   AC " + Str(cm[t].ac) + "   Nopeus " + Str(cm[t].speed) + " ruutua", 220, 210, 190, 0)
    UiText(842, BOARDY + 264, 14, "Fort " + SignStr(cm[t].fort) + "   Ref " + SignStr(cm[t].refl) + "   Will " + SignStr(cm[t].will) + "   Perc " + SignStr(cm[t].perc), 220, 210, 190, 0)
    UiText(842, BOARDY + 282, 14, "Isku " + SignStr(cm[t].atk) + "   " + Str(cm[t].dice) + "d" + Str(cm[t].die) + SignStr(cm[t].flat) + "   kantama " + Str(cm[t].reach), 220, 210, 190, 0)
    s = ""
    if cm[t].prone = 1
        s = s + "Prone  "
    endif
    if cm[t].fright > 0
        s = s + "Frightened " + Str(cm[t].fright) + "  "
    endif
    if cm[t].rage = 1
        s = s + "Rage  "
    endif
    if cm[t].shield = 1
        s = s + "Kilpi  "
    endif
    if cm[t].tmp > 0
        s = s + "TmpHP " + Str(cm[t].tmp) + "  "
    endif
    if cm[t].down = 1
        s = s + "Dying " + Str(cm[t].dying) + "  "
    endif
    if cm[t].cls = CL_WIZ and cm[t].side = 0
        s = s + "Paikat " + Str(cm[t].slots) + " (aste " + Str(cm[t].sRank) + ")"
    endif
    UiText(842, BOARDY + 300, 14, s, 255, 230, 130, 0)
    UiText(842, BOARDY + 318, 14, "Toimintoja " + Str(cm[t].acts) + "   MAP -" + Str(MapPen(t)), 190, 180, 160, 0)
    if cm[t].side = 0
        UiText(842, BOARDY + 336, 14, "Juomia " + Str(PotionCount(t)), 190, 180, 160, 0)
    endif

    // --- loki ---
    UiPanel(830, BOARDY + 374, 426, 160)
    for k = 0 to 8
        UiText(840, BOARDY + 380 + k * 17, 13, bLog[k], 235, 225, 200, 0)
    next k

    // --- toiminnot ---
    if bOver = 0
        if cm[a].side = 0
            DrawActions()
        else
            UiText(20, 610, 20, "Vihollinen toimii: " + CName(a) + "...", 255, 160, 130, 0)
        endif
    endif

    if msgT > 0
        UiRect(SCRW / 2 - 330, 668, 660, 22, 70, 20, 16, 240)
        UiText(SCRW / 2, 670, 16, msg, 255, 225, 170, 1)
    endif

    // --- klikkaus laudalle ---
    if bOver = 0 and cm[a].side = 0 and uiClick = 1 and inB = 1
        uiClick = 0
        HandleBoardClick(cx, cy)
    endif

    // --- lopputulos ---
    if bOver > 0 and bEndT <= 0
        UiRect(0, 0, SCRW, SCRH, 0, 0, 0, 150)
        UiPanel(SCRW / 2 - 220, 250, 440, 190)
        if bOver = 1
            UiText(SCRW / 2, 275, 40, "VOITTO!", 120, 230, 120, 1)
            UiText(SCRW / 2, 330, 17, "Yleis{o} kiljuu nimiesi.", 230, 220, 190, 1)
        else
            UiText(SCRW / 2, 275, 40, "TAPPIO", 240, 110, 100, 1)
            UiText(SCRW / 2, 330, 17, "Keh{a} vaikenee.", 230, 220, 190, 1)
        endif
        if UiButton(SCRW / 2 - 90, 375, 180, 40, "Jatka") = 1
            ApplyResults()
            scr = SC_RESULT
        endif
    endif
endfunction
