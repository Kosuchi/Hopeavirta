// ============================================================================
//  combat_ai.agc  -  vihollisten vuorot: kohteen valinta, liikkuminen, iskut
//  Yksi toiminto kerrallaan, jotta pelaaja nakee mita tapahtuu.
// ============================================================================

function PickTarget(c as integer)
    i as integer
    best as integer
    bd as integer
    d as integer
    sc as integer
    low as integer
    best = -1
    bd = 9999
    low = -1
    for i = 0 to cmN - 1
        if cm[i].used = 1 and cm[i].side <> cm[c].side and cm[i].down = 0 and cm[i].dead = 0
            d = Dist(cm[c].x, cm[c].y, cm[i].x, cm[i].y)
            sc = d * 10 + Trunc(cm[i].hp / 8.0)
            if sc < bd
                bd = sc
                best = i
            endif
            if low < 0
                low = i
            elseif cm[i].hp < cm[low].hp
                low = i
            endif
        endif
    next i
    if best >= 0 and low >= 0 and RI(1, 100) <= 25
        best = low
    endif
endfunction best

// liikkuu kohti kohdetta; palauttaa 1 jos liikkui
function MoveToward(c as integer, t as integer)
    x as integer
    y as integer
    d as integer
    cur as integer
    bestD as integer
    bestC as integer
    bx as integer
    by as integer
    want as integer
    moved as integer
    moved = 0
    ComputeMove(c)
    want = cm[c].reach
    cur = IMax(0, Dist(cm[c].x, cm[c].y, cm[t].x, cm[t].y) - want)
    bestD = 999
    bestC = 999
    bx = -1
    by = -1
    for x = 0 to GRIDW - 1
        for y = 0 to GRIDH - 1
            if bMv[x,y] > 0
                d = IMax(0, Dist(x, y, cm[t].x, cm[t].y) - want)
                if d < bestD or (d = bestD and bMv[x,y] < bestC)
                    bestD = d
                    bestC = bMv[x,y]
                    bx = x
                    by = y
                endif
            endif
        next y
    next x
    if bx >= 0 and bestD < cur
        DoMove(c, bx, by)
        moved = 1
        AddLog(CName(c) + " liikkuu")
    endif
endfunction moved

function AIStep()
    c as integer
    t as integer
    d as integer
    c = bCur
    if cm[c].acts <= 0
        EndTurn()
        exitfunction
    endif
    if cm[c].prone = 1
        cm[c].acts = cm[c].acts - 1
        DoStand(c)
        exitfunction
    endif
    t = PickTarget(c)
    if t < 0
        EndTurn()
        exitfunction
    endif
    d = Dist(cm[c].x, cm[c].y, cm[t].x, cm[t].y)
    if (cm[c].flags && FL_CASTER) <> 0 and cm[c].acts >= 2 and d <= 12
        cm[c].acts = cm[c].acts - 2
        EnemyBolt(c, t)
    elseif d <= cm[c].reach
        cm[c].acts = cm[c].acts - 1
        DoStrike(c, t, 0)
    else
        cm[c].acts = cm[c].acts - 1
        if MoveToward(c, t) = 0
            cm[c].acts = 0
        endif
    endif
    CheckEnd()
endfunction
