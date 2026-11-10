// ============================================================================
//  combat_core.agc  -  vuoropohjainen areenataistelu (PF2E-saannoilla)
//
//  Kolme toimintoa vuorossa, usean iskun rangaistus (MAP), neljan asteen
//  onnistumiset, Off-guard + saartaminen, kaatuminen/kuoleminen (dying,
//  wounded), Frightened, Prone, kilven nosto + Shield Block, taikuus.
// ============================================================================

global bRows as integer[9]

function AddLog(s as string)
    i as integer
    for i = 0 to 7
        bLog[i] = bLog[i + 1]
    next i
    bLog[8] = s
endfunction

function CName(c as integer)
    s as string
    if cm[c].side = 0
        s = FirstWord(cm[c].name)
    else
        s = cm[c].name
    endif
endfunction s

function CmbAt(x as integer, y as integer)
    i as integer
    r as integer
    r = -1
    for i = 0 to cmN - 1
        if cm[i].used = 1 and cm[i].dead = 0 and cm[i].x = x and cm[i].y = y
            r = i
            exit
        endif
    next i
endfunction r

// ----------------------------------------------------------------------------
//  Taistelijoiden rakentaminen
// ----------------------------------------------------------------------------
function BuildPlayerCmb(c as integer, i as integer)
    w as integer
    cm[c] = gBlankCm
    w = ft[i].weapon
    cm[c].used = 1
    cm[c].side = 0
    cm[c].src = i
    cm[c].mon = -1
    cm[c].name = ft[i].name
    cm[c].glyph = Left(ft[i].name, 1)
    cm[c].cls = ft[i].cls
    cm[c].lvl = ft[i].level
    cm[c].hpMax = MaxHPf(i)
    cm[c].hp = IMin(ft[i].hp, cm[c].hpMax)
    if cm[c].hp < 1
        cm[c].hp = 1
    endif
    cm[c].ac = FAC(i)
    cm[c].fort = FSave(i, 0)
    cm[c].refl = FSave(i, 1)
    cm[c].will = FSave(i, 2)
    cm[c].perc = FPerc(i)
    cm[c].atk = FAtk(i)
    cm[c].dice = 1 + ft[i].wStrk
    cm[c].die = wpD[w]
    cm[c].flat = FDmgMod(i)
    cm[c].deadly = wpDd[w]
    cm[c].agile = 0
    if (wpF[w] && WF_AGILE) <> 0
        cm[c].agile = 1
    endif
    cm[c].ranged = 0
    cm[c].reach = 1
    if (wpF[w] && WF_RANGED) <> 0
        cm[c].ranged = 1
        cm[c].reach = wpR[w]
    elseif (wpF[w] && WF_REACH) <> 0
        cm[c].reach = 2
    endif
    cm[c].speed = FSpeed(i)
    cm[c].sneak = SneakDice(ft[i].cls, ft[i].level)
    cm[c].athl = ft[i].aStr + ProfB(AthRank(ft[i].cls), ft[i].level)
    cm[c].intim = ft[i].aCha + ProfB(IntRank(ft[i].cls), ft[i].level)
    cm[c].decep = ft[i].aCha + ProfB(DecRank(ft[i].cls), ft[i].level)
    cm[c].hard = shH[ft[i].shield]
    cm[c].wounded = ft[i].wounded
    cm[c].pot1 = ft[i].pot1
    cm[c].pot2 = ft[i].pot2
    cm[c].pot3 = ft[i].pot3
    if ft[i].cls = CL_CHAMP
        cm[c].lay = 1
    endif
    if ft[i].cls = CL_WIZ
        cm[c].slots = 2 + Trunc(ft[i].level / 3.0)
        cm[c].sRank = Clampi(Trunc((ft[i].level + 1) / 2.0), 1, 5)
        cm[c].spMod = FSpellMod(i)
        cm[c].spDC = FSpellDC(i)
    endif
endfunction

function BuildMonCmb(c as integer, m as integer)
    lv as integer
    cm[c] = gBlankCm
    lv = mnLv[m]
    cm[c].used = 1
    cm[c].side = 1
    cm[c].src = -1
    cm[c].mon = m
    cm[c].name = mnN[m]
    cm[c].glyph = Left(mnN[m], 1)
    cm[c].lvl = lv
    cm[c].kind = mnKd[m]
    cm[c].hpMax = MonHP(mnHP[m], lv)
    cm[c].hp = cm[c].hpMax
    cm[c].ac = MonAC(mnAC[m], lv)
    cm[c].fort = MonSave(mnFo[m], lv)
    cm[c].refl = MonSave(mnRe[m], lv)
    cm[c].will = MonSave(mnWi[m], lv)
    cm[c].perc = MonSave(2, lv)
    cm[c].atk = MonAtk(mnAt[m], lv)
    cm[c].dice = MonDice(mnDm[m], lv)
    cm[c].die = MonDie(mnDm[m], lv)
    cm[c].flat = MonFlat(mnDm[m], lv)
    cm[c].speed = mnSp[m]
    cm[c].flags = mnFl[m]
    cm[c].reach = 1
    if (cm[c].flags && FL_REACH) <> 0
        cm[c].reach = 2
    endif
    if (cm[c].flags && FL_RANGED) <> 0
        cm[c].ranged = 1
        cm[c].reach = 10
    endif
    cm[c].athl = cm[c].atk
    cm[c].intim = cm[c].atk - 2
endfunction

function SetupBattle(ci as integer)
    i as integer
    j as integer
    c as integer
    np as integer
    ne as integer
    x as integer
    y as integer
    tries as integer
    t as integer
    for i = 0 to 11
        cm[i] = gBlankCm
    next i
    for i = 0 to 8
        bLog[i] = ""
    next i
    for x = 0 to GRIDW
        for y = 0 to GRIDH
            bBlocked[x,y] = 0
            bMv[x,y] = -1
        next y
    next x
    cmN = 0
    bCard = ci
    bBlood = bloodOn
    if card[ci].champ = 1
        bBlood = 0
    endif
    for i = 0 to MAXFT - 1
        if ft[i].used = 1 and ft[i].sel = 1
            BuildPlayerCmb(cmN, i)
            cmN = cmN + 1
        endif
    next i
    np = cmN
    for j = 0 to card[ci].ne - 1
        BuildMonCmb(cmN, cardEn[ci,j])
        cmN = cmN + 1
    next j
    ne = cmN - np
    bNPl = np
    bXP = card[ci].xp

    for c = 0 to np - 1
        cm[c].x = 1 + Mod(c, 2)
        cm[c].y = Trunc((c + 0.5) * GRIDH / (np * 1.0))
    next c
    for c = 0 to ne - 1
        cm[np + c].x = GRIDW - 2 - Mod(c, 2)
        cm[np + c].y = Trunc((c + 0.5) * GRIDH / (ne * 1.0))
    next c
    for j = 1 to 7
        x = RI(4, 9)
        y = RI(0, GRIDH - 1)
        bBlocked[x,y] = 1
    next j

    for c = 0 to cmN - 1
        cm[c].init = D20() + cm[c].perc
    next c
    bOrderN = 0
    for c = 0 to cmN - 1
        bOrder[bOrderN] = c
        bOrderN = bOrderN + 1
    next c
    for i = 0 to bOrderN - 2
        for j = i + 1 to bOrderN - 1
            if cm[bOrder[j]].init > cm[bOrder[i]].init
                t = bOrder[i]
                bOrder[i] = bOrder[j]
                bOrder[j] = t
            endif
        next j
    next i
    bRound = 1
    bPos = -1
    bOver = 0
    bMode = MD_NONE
    bInsp = -1
    bYield = 0
    bEndT = 0
    Sfx(S_CROWD, 60)
    AddLog("Kehien kutsu! " + card[ci].name + " vs " + card[ci].foe)
    NextTurn()
endfunction

// ----------------------------------------------------------------------------
//  Perussaannot: AC, off-guard, saartaminen, tallit
// ----------------------------------------------------------------------------
function Flanked(a as integer, t as integer)
    ox as integer
    oy as integer
    b as integer
    f as integer
    f = 0
    if cm[a].ranged = 0
        if IAbs(cm[a].x - cm[t].x) <= 1 and IAbs(cm[a].y - cm[t].y) <= 1
            ox = 2 * cm[t].x - cm[a].x
            oy = 2 * cm[t].y - cm[a].y
            if ox >= 0 and ox < GRIDW and oy >= 0 and oy < GRIDH
                b = CmbAt(ox, oy)
                if b >= 0 and b <> a
                    if cm[b].side = cm[a].side and cm[b].down = 0
                        f = 1
                    endif
                endif
            endif
        endif
    endif
endfunction f

function IsOffGuard(t as integer, a as integer)
    r as integer
    r = 0
    if cm[t].prone = 1 or cm[t].off = a + 1
        r = 1
    elseif Flanked(a, t) = 1
        r = 1
    endif
endfunction r

function CmbAC(t as integer, a as integer)
    r as integer
    r = cm[t].ac
    if IsOffGuard(t, a) = 1
        r = r - 2
    endif
    if cm[t].shield = 1
        r = r + 2
    endif
    r = r - cm[t].fright
endfunction r

function CanStrike(a as integer, t as integer)
    r as integer
    r = 0
    if Dist(cm[a].x, cm[a].y, cm[t].x, cm[t].y) <= cm[a].reach
        r = 1
    endif
endfunction r

function MapPen(a as integer)
    r as integer
    r = 0
    if cm[a].mapN = 1
        r = 5
        if cm[a].agile = 1
            r = 4
        endif
    elseif cm[a].mapN >= 2
        r = 10
        if cm[a].agile = 1
            r = 8
        endif
    endif
endfunction r

// osumatodennakoisuus prosentteina (UI:ta varten)
function HitChance(a as integer, t as integer)
    need as integer
    r as integer
    need = CmbAC(t, a) - (cm[a].atk - MapPen(a) - cm[a].fright)
    r = Clampi((21 - need) * 5, 5, 95)
endfunction r

// ----------------------------------------------------------------------------
//  Vahinko, kaatuminen, parannus
// ----------------------------------------------------------------------------
function DamageCmb(t as integer, dmg as integer, crit as integer, src as integer)
    blk as integer
    if dmg <= 0
        exitfunction
    endif
    if cm[t].tmp > 0
        blk = IMin(cm[t].tmp, dmg)
        cm[t].tmp = cm[t].tmp - blk
        dmg = dmg - blk
    endif
    if cm[t].shield = 1 and cm[t].react = 0 and cm[t].hard > 0 and dmg > 0
        blk = IMin(cm[t].hard, dmg)
        dmg = dmg - blk
        cm[t].react = 1
        Sfx(S_BLOCK, 80)
        AddLog("  " + CName(t) + " torjuu kilvell{a} " + Str(blk) + " (Shield Block)")
    endif
    if dmg <= 0
        exitfunction
    endif
    if cm[t].down = 1 and cm[t].dead = 0
        cm[t].dying = cm[t].dying + 1 + crit
        if cm[t].dying >= 4
            cm[t].dead = 1
            AddLog("  " + CName(t) + " kuolee!")
            Sfx(S_DEATH, 80)
        endif
        exitfunction
    endif
    cm[t].hp = cm[t].hp - dmg
    if cm[t].hp <= 0
        cm[t].hp = 0
        cm[t].down = 1
        cm[t].prone = 1
        Sfx(S_FALL, 70)
        if cm[t].side = 0
            cm[t].dying = 1 + crit + cm[t].wounded
            AddLog("  " + CName(t) + " kaatuu! (dying " + Str(cm[t].dying) + ")")
            if cm[t].dying >= 4
                cm[t].dead = 1
                AddLog("  " + CName(t) + " kuolee!")
            Sfx(S_DEATH, 80)
            endif
        else
            cm[t].dead = 1
            AddLog("  " + CName(t) + " kaatuu.")
            Sfx(S_DEATH, 55)
        endif
    endif
endfunction

function HealCmb(t as integer, amt as integer)
    Sfx(S_HEAL, 70)
    if cm[t].down = 1 and cm[t].dead = 0
        cm[t].down = 0
        cm[t].dying = 0
        cm[t].wounded = cm[t].wounded + 1
        cm[t].hp = IMin(cm[t].hpMax, amt)
        cm[t].prone = 1
        AddLog("  " + CName(t) + " her{a}{a}! (" + Str(cm[t].hp) + " HP)")
    else
        cm[t].hp = IMin(cm[t].hpMax, cm[t].hp + amt)
        AddLog("  " + CName(t) + " parantuu " + Str(amt) + " (" + Str(cm[t].hp) + "/" + Str(cm[t].hpMax) + ")")
    endif
endfunction

function SpendActs(c as integer, n as integer)
    r as integer
    r = 0
    if cm[c].acts >= n
        cm[c].acts = cm[c].acts - n
        r = 1
    endif
endfunction r

// ----------------------------------------------------------------------------
//  Toiminnot
// ----------------------------------------------------------------------------
function DoStrike(a as integer, t as integer, power as integer)
    nat as integer
    tot as integer
    ac as integer
    deg as integer
    dmg as integer
    crit as integer
    sn as integer
    dice as integer
    k as integer
    nat = D20()
    tot = nat + cm[a].atk - MapPen(a) - cm[a].fright
    ac = CmbAC(t, a)
    deg = Degree(tot, ac, nat)
    cm[a].mapN = cm[a].mapN + 1 + power
    StrikeSfx(a, deg)
    if deg >= 2
        dice = cm[a].dice + power
        dmg = Roll(dice, cm[a].die) + cm[a].flat
        if cm[a].rage = 1
            dmg = dmg + 2
            if cm[a].agile = 1
                dmg = dmg - 1
            endif
        endif
        sn = 0
        if cm[a].sneak > 0 and IsOffGuard(t, a) = 1 and (cm[a].agile = 1 or cm[a].ranged = 1)
            sn = Roll(cm[a].sneak, 6)
            dmg = dmg + sn
        endif
        if dmg < 1
            dmg = 1
        endif
        crit = 0
        if deg = 3
            crit = 1
            dmg = dmg * 2
            if cm[a].deadly > 0
                dmg = dmg + Roll(IMin(2, dice), cm[a].deadly)
            endif
        endif
        AddLog(CName(a) + " > " + CName(t) + ": " + Str(tot) + " vs " + Str(ac) + " " + DegTxt(deg) + " " + Str(dmg))
        DamageCmb(t, dmg, crit, a)
        if (cm[a].flags && FL_KNOCK) <> 0 and cm[t].prone = 0 and cm[t].dead = 0
            k = D20() + cm[t].refl
            if k < 10 + cm[a].atk
                cm[t].prone = 1
                AddLog("  " + CName(t) + " kaatuu maahan (Prone)")
            endif
        endif
    else
        AddLog(CName(a) + " > " + CName(t) + ": " + Str(tot) + " vs " + Str(ac) + " " + DegTxt(deg))
    endif
endfunction

// kestavyys 0, refleksi 1, tahto 2
function SaveCheck(t as integer, k as integer, dc as integer)
    nat as integer
    v as integer
    d as integer
    nat = D20()
    v = cm[t].refl
    if k = 0
        v = cm[t].fort
    elseif k = 2
        v = cm[t].will
    endif
    d = Degree(nat + v - cm[t].fright, dc, nat)
endfunction d

function BasicSave(t as integer, a as integer, dc as integer, dmg as integer, nm as string)
    d as integer
    r as integer
    d = SaveCheck(t, 1, dc)
    r = dmg
    if d = 3
        r = 0
    elseif d = 2
        r = Trunc(dmg / 2.0)
    elseif d = 0
        r = dmg * 2
    endif
    AddLog("  " + CName(t) + " (" + nm + " DC" + Str(dc) + "): " + DegTxt(d) + " " + Str(r))
    if r > 0
        DamageCmb(t, r, 0, a)
    endif
endfunction

function DoTrip(a as integer, t as integer)
    nat as integer
    tot as integer
    dc as integer
    d as integer
    nat = D20()
    tot = nat + cm[a].athl - MapPen(a) - cm[a].fright
    dc = 10 + cm[t].refl
    d = Degree(tot, dc, nat)
    cm[a].mapN = cm[a].mapN + 1
    if d >= 2
        cm[t].prone = 1
        Sfx(S_TRIP, 75)
        AddLog(CName(a) + " kaataa " + CName(t) + " (" + Str(tot) + " vs " + Str(dc) + ")")
        if d = 3
            DamageCmb(t, Roll(1, 6), 0, a)
        endif
    else
        AddLog(CName(a) + " yritt{a}{a} kaataa " + CName(t) + ": ohi (" + Str(tot) + " vs " + Str(dc) + ")")
        if d = 0
            cm[a].prone = 1
            AddLog("  " + CName(a) + " kaatuu itse!")
        endif
    endif
endfunction

function DoDemoralize(a as integer, t as integer)
    nat as integer
    tot as integer
    dc as integer
    d as integer
    nat = D20()
    tot = nat + cm[a].intim - cm[a].fright
    dc = 10 + cm[t].will
    d = Degree(tot, dc, nat)
    if d >= 2
        cm[t].fright = IMax(cm[t].fright, 1)
        if d = 3
            cm[t].fright = 2
        endif
        Sfx(S_SCARE, 70)
        AddLog(CName(a) + " pelottaa " + CName(t) + ": Frightened " + Str(cm[t].fright))
    else
        AddLog(CName(a) + " pelottelee " + CName(t) + ": ei tehoa (" + Str(tot) + " vs " + Str(dc) + ")")
    endif
endfunction

function DoFeint(a as integer, t as integer)
    nat as integer
    tot as integer
    dc as integer
    d as integer
    nat = D20()
    tot = nat + cm[a].decep - cm[a].fright
    dc = 10 + cm[t].perc
    d = Degree(tot, dc, nat)
    if d >= 2
        cm[t].off = a + 1
        AddLog(CName(a) + " harhauttaa " + CName(t) + ": Off-guard (" + Str(tot) + " vs " + Str(dc) + ")")
    else
        AddLog(CName(a) + " harhautus ep{a}onnistuu (" + Str(tot) + " vs " + Str(dc) + ")")
    endif
endfunction

function DoLay(a as integer, t as integer)
    amt as integer
    amt = 6 + 3 * Trunc(cm[a].lvl / 2.0)
    cm[a].lay = cm[a].lay - 1
    AddLog(CName(a) + " k{a}ytt{a}{a} Lay on Hands: " + CName(t))
    HealCmb(t, amt)
endfunction

function DoPotion(a as integer)
    miss as integer
    amt as integer
    miss = cm[a].hpMax - cm[a].hp
    if cm[a].pot1 > 0 and (miss <= 8 or (cm[a].pot2 = 0 and cm[a].pot3 = 0))
        cm[a].pot1 = cm[a].pot1 - 1
        amt = Roll(ptDn[0], ptDd[0]) + ptFl[0]
    elseif cm[a].pot2 > 0 and (miss <= 25 or cm[a].pot3 = 0)
        cm[a].pot2 = cm[a].pot2 - 1
        amt = Roll(ptDn[1], ptDd[1]) + ptFl[1]
    elseif cm[a].pot3 > 0
        cm[a].pot3 = cm[a].pot3 - 1
        amt = Roll(ptDn[2], ptDd[2]) + ptFl[2]
    else
        cm[a].pot1 = cm[a].pot1 - 1
        amt = Roll(ptDn[0], ptDd[0]) + ptFl[0]
    endif
    AddLog(CName(a) + " juo parannusjuoman")
    HealCmb(a, amt)
endfunction

function PotionCount(a as integer)
    r as integer
    r = cm[a].pot1 + cm[a].pot2 + cm[a].pot3
endfunction r

function DoRage(a as integer)
    cm[a].rage = 1
    Sfx(S_RAGE, 85)
    cm[a].ac = cm[a].ac - 1
    cm[a].tmp = cm[a].lvl + ft[cm[a].src].aCon
    if cm[a].tmp < 1
        cm[a].tmp = 1
    endif
    AddLog(CName(a) + " raivostuu! +2 vahinko, " + Str(cm[a].tmp) + " v{a}liaikaista HP")
endfunction

function DoShield(a as integer)
    cm[a].shield = 1
    Sfx(S_SHIELD, 70)
    AddLog(CName(a) + " nostaa kilven (+2 AC)")
endfunction

function DoStand(a as integer)
    cm[a].prone = 0
    Sfx(S_STEP, 50)
    AddLog(CName(a) + " nousee ylos")
endfunction

function NearestEnemyTo(t as integer, maxd as integer)
    i as integer
    best as integer
    bd as integer
    d as integer
    best = -1
    bd = 99
    for i = 0 to cmN - 1
        if cm[i].used = 1 and cm[i].dead = 0 and cm[i].side = cm[t].side and i <> t and cm[i].down = 0
            d = Dist(cm[i].x, cm[i].y, cm[t].x, cm[t].y)
            if d <= maxd and d < bd
                bd = d
                best = i
            endif
        endif
    next i
endfunction best

// Sahkokaari: kaksi toimintoa, perus-refleksi, kaksi kohdetta
function CastArc(a as integer, t as integer)
    dmg as integer
    nd as integer
    u as integer
    nd = IMax(1, Trunc((cm[a].lvl + 1) / 2.0))
    dmg = Roll(nd, 4) + cm[a].spMod
    Sfx(S_ARC, 80)
    AddLog(CName(a) + " loitsii S{a}hk{o}kaaren (" + Str(nd) + "d4)")
    BasicSave(t, a, cm[a].spDC - cm[a].fright, dmg, "Refleksi")
    u = NearestEnemyTo(t, 2)
    if u >= 0
        BasicSave(u, a, cm[a].spDC - cm[a].fright, dmg, "Refleksi")
    endif
endfunction

// Voimasarja: kaksi toimintoa, automaattiosuma
function CastBarrage(a as integer, t as integer)
    n as integer
    i as integer
    dmg as integer
    n = 2 + 2 * Trunc((cm[a].sRank - 1) / 2.0)
    dmg = 0
    for i = 1 to n
        dmg = dmg + Roll(1, 4) + 1
    next i
    cm[a].slots = cm[a].slots - 1
    Sfx(S_BARR, 80)
    AddLog(CName(a) + " ampuu Voimasarjan: " + Str(n) + " ammusta, " + Str(dmg))
    DamageCmb(t, dmg, 0, a)
endfunction

// Tulipallo: aste 3+, sade 4 ruutua, osuu myos omiin
function CastFireball(a as integer, t as integer)
    i as integer
    dmg as integer
    cx as integer
    cy as integer
    cx = cm[t].x
    cy = cm[t].y
    dmg = Roll(cm[a].sRank * 2, 6)
    cm[a].slots = cm[a].slots - 1
    Sfx(S_FIRE, 100)
    AddLog(CName(a) + " heitt{a}{a} Tulipallon! (" + Str(cm[a].sRank * 2) + "d6)")
    for i = 0 to cmN - 1
        if cm[i].used = 1 and cm[i].dead = 0 and i <> a
            if Dist(cm[i].x, cm[i].y, cx, cy) <= 4
                BasicSave(i, a, cm[a].spDC - cm[a].fright, dmg, "Refleksi")
            endif
        endif
    next i
endfunction

function EnemyBolt(a as integer, t as integer)
    dmg as integer
    dmg = Roll(cm[a].dice, cm[a].die) + cm[a].flat
    Sfx(S_ARC, 75)
    AddLog(CName(a) + " loitsii taikaiskun")
    BasicSave(t, a, 10 + cm[a].atk - cm[a].fright, dmg, "Refleksi")
endfunction

// ----------------------------------------------------------------------------
//  Liikkuminen
// ----------------------------------------------------------------------------
function ComputeMove(c as integer)
    x as integer
    y as integer
    dx as integer
    dy as integer
    nx as integer
    ny as integer
    cost as integer
    ch as integer
    lim as integer
    for x = 0 to GRIDW - 1
        for y = 0 to GRIDH - 1
            bMv[x,y] = -1
        next y
    next x
    bMv[cm[c].x,cm[c].y] = 0
    lim = cm[c].speed * 2
    ch = 1
    while ch = 1
        ch = 0
        for x = 0 to GRIDW - 1
            for y = 0 to GRIDH - 1
                if bMv[x,y] >= 0
                    for dx = -1 to 1
                        for dy = -1 to 1
                            if dx <> 0 or dy <> 0
                                nx = x + dx
                                ny = y + dy
                                if nx >= 0 and nx < GRIDW and ny >= 0 and ny < GRIDH
                                    if bBlocked[nx,ny] = 0 and CmbAt(nx, ny) = -1
                                        cost = bMv[x,y] + 2
                                        if dx <> 0 and dy <> 0
                                            cost = cost + 1
                                        endif
                                        if cost <= lim
                                            if bMv[nx,ny] < 0 or cost < bMv[nx,ny]
                                                bMv[nx,ny] = cost
                                                ch = 1
                                            endif
                                        endif
                                    endif
                                endif
                            endif
                        next dy
                    next dx
                endif
            next y
        next x
    endwhile
endfunction

function DoMove(a as integer, x as integer, y as integer)
    cm[a].x = x
    cm[a].y = y
    Sfx(S_STEP, 45)
endfunction

// ----------------------------------------------------------------------------
//  Vuorot
// ----------------------------------------------------------------------------
function CheckEnd()
    c as integer
    p as integer
    e as integer
    p = 0
    e = 0
    for c = 0 to cmN - 1
        if cm[c].used = 1
            if cm[c].side = 0
                if cm[c].down = 0
                    p = p + 1
                endif
            elseif cm[c].dead = 0
                e = e + 1
            endif
        endif
    next c
    if bOver = 0
        if e = 0
            bOver = 1
            bEndT = 1.2
        elseif p = 0
            bOver = 2
            bEndT = 1.2
        endif
    endif
endfunction

function RecoveryCheck(c as integer)
    nat as integer
    dc as integer
    d as integer
    if cm[c].dying <= 0
        exitfunction
    endif
    nat = D20()
    dc = 10 + cm[c].dying
    d = Degree(nat, dc, nat)
    if d = 3
        cm[c].dying = cm[c].dying - 2
    elseif d = 2
        cm[c].dying = cm[c].dying - 1
    elseif d = 1
        cm[c].dying = cm[c].dying + 1
    else
        cm[c].dying = cm[c].dying + 2
    endif
    if cm[c].dying >= 4
        cm[c].dead = 1
        AddLog(CName(c) + " kuolee! (toipumisheitto " + Str(nat) + ")")
        Sfx(S_DEATH, 80)
    elseif cm[c].dying <= 0
        cm[c].dying = 0
        cm[c].wounded = cm[c].wounded + 1
        AddLog(CName(c) + " vakiintuu (toipumisheitto " + Str(nat) + ")")
    else
        AddLog(CName(c) + " horjuu kuoleman rajalla: dying " + Str(cm[c].dying))
    endif
endfunction

function StartTurn(c as integer)
    i as integer
    cm[c].acts = 3
    cm[c].mapN = 0
    cm[c].react = 0
    cm[c].shield = 0
    for i = 0 to cmN - 1
        if cm[i].off = c + 1
            cm[i].off = 0
        endif
    next i
    if (cm[c].flags && FL_REGEN) <> 0 and cm[c].hp < cm[c].hpMax
        cm[c].hp = IMin(cm[c].hpMax, cm[c].hp + 5)
        AddLog("  " + CName(c) + " uudistuu (+5)")
    endif
    bCur = c
    bMode = MD_NONE
    bTimer = 0.6
endfunction

function NextTurn()
    tries as integer
    c as integer
    for tries = 1 to bOrderN + 1
        bPos = bPos + 1
        if bPos >= bOrderN
            bPos = 0
            bRound = bRound + 1
        endif
        c = bOrder[bPos]
        if cm[c].used = 1 and cm[c].dead = 0
            if cm[c].down = 1
                RecoveryCheck(c)
                CheckEnd()
            else
                StartTurn(c)
                exitfunction
            endif
        endif
    next tries
endfunction

function EndTurn()
    c as integer
    c = bCur
    if cm[c].fright > 0
        cm[c].fright = cm[c].fright - 1
    endif
    CheckEnd()
    if bOver = 0
        NextTurn()
    endif
endfunction
