// ============================================================================
//  fighters.agc  -  taistelijat: luonti, johdetut arvot ja tasonnousu
//  Laskut noudattavat PF2E:n kaavoja: AC = 10 + dex + ammattitaito + panssari,
//  isku = ominaisuus + ammattitaito + riimu, HP = esi-isa + taso*(luokka+Con).
// ============================================================================

function AbMod(i as integer, k as integer)
    r as integer
    r = 0
    if k = 0
        r = ft[i].aStr
    elseif k = 1
        r = ft[i].aDex
    elseif k = 2
        r = ft[i].aCon
    elseif k = 3
        r = ft[i].aInt
    elseif k = 4
        r = ft[i].aWis
    else
        r = ft[i].aCha
    endif
endfunction r

function SetAb(i as integer, k as integer, v as integer)
    if k = 0
        ft[i].aStr = v
    elseif k = 1
        ft[i].aDex = v
    elseif k = 2
        ft[i].aCon = v
    elseif k = 3
        ft[i].aInt = v
    elseif k = 4
        ft[i].aWis = v
    else
        ft[i].aCha = v
    endif
endfunction

function MaxHPf(i as integer)
    r as integer
    r = anHP[ft[i].anc] + ft[i].level * (clHP[ft[i].cls] + ft[i].aCon)
    if r < 1
        r = 1
    endif
endfunction r

function WepRank(i as integer)
    w as integer
    r as integer
    w = ft[i].weapon
    r = WeaponRank(ft[i].cls, ft[i].level)
    if ft[i].cls = CL_WIZ and (wpF[w] && WF_MARTIAL) <> 0
        r = 0
    endif
endfunction r

function FAtk(i as integer)
    w as integer
    ab as integer
    r as integer
    w = ft[i].weapon
    if (wpF[w] && WF_RANGED) <> 0
        ab = ft[i].aDex
    elseif (wpF[w] && WF_FINESSE) <> 0
        ab = IMax(ft[i].aStr, ft[i].aDex)
    else
        ab = ft[i].aStr
    endif
    r = ab + ProfB(WepRank(i), ft[i].level) + ft[i].wPot
endfunction r

function FDmgMod(i as integer)
    r as integer
    r = ft[i].aStr
    if (wpF[ft[i].weapon] && WF_RANGED) <> 0
        r = 0
    endif
endfunction r

function FAC(i as integer)
    a as integer
    r as integer
    a = ft[i].armor
    r = 10 + IMin(ft[i].aDex, arCap[a]) + ProfB(ArmorRank(ft[i].cls, ft[i].level), ft[i].level) + arAC[a] + ft[i].aPot
endfunction r

// k: 0 kestavyys (Con), 1 refleksit (Dex), 2 tahto (Wis)
function FSave(i as integer, k as integer)
    ab as integer
    r as integer
    if k = 0
        ab = ft[i].aCon
    elseif k = 1
        ab = ft[i].aDex
    else
        ab = ft[i].aWis
    endif
    r = ab + ProfB(SaveRank(ft[i].cls, k, ft[i].level), ft[i].level) + ft[i].aRes
endfunction r

function FPerc(i as integer)
    r as integer
    r = ft[i].aWis + ProfB(PercRank(ft[i].cls), ft[i].level)
endfunction r

function FSpeed(i as integer)
    r as integer
    r = anSp[ft[i].anc] - arSp[ft[i].armor]
    if r < 3
        r = 3
    endif
endfunction r

function FSpellMod(i as integer)
    r as integer
    r = ft[i].aInt
endfunction r

function FSpellDC(i as integer)
    r as integer
    r = 10 + ft[i].aInt + ProfB(SpellRank(ft[i].level), ft[i].level)
endfunction r

function FreeSlot()
    i as integer
    r as integer
    r = -1
    for i = 0 to MAXFT - 1
        if ft[i].used = 0
            r = i
            exit
        endif
    next i
endfunction r

function RosterCount()
    i as integer
    n as integer
    n = 0
    for i = 0 to MAXFT - 1
        if ft[i].used = 1
            n = n + 1
        endif
    next i
endfunction n

function HealthyCount()
    i as integer
    n as integer
    n = 0
    for i = 0 to MAXFT - 1
        if ft[i].used = 1 and ft[i].injury = 0 and ft[i].fought = 0
            n = n + 1
        endif
    next i
endfunction n

function RefLevel()
    i as integer
    n as integer
    s as integer
    r as integer
    n = 0
    s = 0
    for i = 0 to MAXFT - 1
        if ft[i].used = 1
            n = n + 1
            s = s + ft[i].level
        endif
    next i
    r = 1
    if n > 0
        r = IMax(1, Trunc(s / (n * 1.0) + 0.5))
    endif
endfunction r

function BarracksCap()
    r as integer
    r = 4 + 2 * facB
endfunction r

function AutoGear(s as integer)
    c as integer
    l as integer
    c = ft[s].cls
    l = ft[s].level
    ft[s].shield = 0
    if c = CL_FIGHTER
        if RI(0, 1) = 0
            ft[s].weapon = 7
        else
            ft[s].weapon = 3
            ft[s].shield = 1
        endif
        ft[s].armor = 3
        if l >= 7
            ft[s].armor = 5
        endif
    elseif c = CL_BARB
        ft[s].weapon = 7
        ft[s].armor = 2
        if l >= 5
            ft[s].armor = 3
        endif
    elseif c = CL_ROGUE
        if RI(0, 2) = 0
            ft[s].weapon = 11
        else
            ft[s].weapon = 4
        endif
        ft[s].armor = 2
    elseif c = CL_CHAMP
        ft[s].weapon = 3
        ft[s].shield = 1
        if l >= 3
            ft[s].shield = 2
        endif
        ft[s].armor = 5
        if l >= 6
            ft[s].armor = 6
        endif
    else
        ft[s].weapon = 9
        ft[s].armor = 0
    endif
    ft[s].wPot = 0
    ft[s].wStrk = 0
    ft[s].aPot = 0
    ft[s].aRes = 0
    if l >= 2
        ft[s].wPot = 1
    endif
    if l >= 4
        ft[s].wStrk = 1
    endif
    if l >= 5
        ft[s].aPot = 1
    endif
    if l >= 8
        ft[s].aRes = 1
    endif
    if l >= 10
        ft[s].wPot = 2
    endif
    ft[s].pot1 = 1
    ft[s].pot2 = 0
    ft[s].pot3 = 0
endfunction

function SetWage(s as integer)
    f as float
    f = WageGp(ft[s].level) * 100.0 * mkt[IX_TALENT] * RF(0.9, 1.15)
    ft[s].wage = Trunc(f)
endfunction

function LevelUpOnce(s as integer)
    j as integer
    k as integer
    cap as integer
    ft[s].level = ft[s].level + 1
    if ft[s].level = 5 or ft[s].level = 10
        for j = 0 to 3
            k = clPr[ft[s].cls,j]
            cap = 4
            if j = 0
                cap = 5
            endif
            if AbMod(s, k) < cap
                SetAb(s, k, AbMod(s, k) + 1)
            endif
        next j
    endif
endfunction

function MakeFighter(s as integer, cls as integer, anc as integer, lvl as integer)
    k as integer
    L as integer
    ft[s] = gBlankFt
    ft[s].used = 1
    ft[s].name = RandName()
    ft[s].anc = anc
    ft[s].cls = cls
    ft[s].level = 1
    ft[s].xp = 0
    for k = 0 to 5
        SetAb(s, k, clT[cls,k])
    next k
    if anB1[anc] >= 0
        SetAb(s, anB1[anc], IMin(4, AbMod(s, anB1[anc]) + 1))
        SetAb(s, anB2[anc], IMin(4, AbMod(s, anB2[anc]) + 1))
    endif
    k = RI(0, 5)
    if k <> clPr[cls,0]
        SetAb(s, k, Clampi(AbMod(s, k) + RI(-1, 1), -2, 4))
    endif
    for L = 2 to lvl
        LevelUpOnce(s)
    next L
    AutoGear(s)
    ft[s].hp = MaxHPf(s)
    ft[s].pop = RI(5, 20)
    SetWage(s)
endfunction
