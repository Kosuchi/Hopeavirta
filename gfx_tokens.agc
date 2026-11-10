// ============================================================================
//  gfx_tokens.agc  -  taistelijoiden ja hirvioiden tokenit AGK:n piirtokomennoilla
//  (DrawEllipse / DrawBox / DrawLine). Piirtokomennot ovat aina UI-laattojen
//  ja tekstien paalla, joten figuurit pysyvat ruudun sisalla eika niiden
//  alla ole tekstia.
// ============================================================================

function SkinCol(sk as integer)
    c as integer
    if sk = 1
        c = Col(120, 172, 92, 255)
    elseif sk = 2
        c = Col(205, 160, 112, 255)
    elseif sk = 3
        c = Col(110, 140, 96, 255)
    elseif sk = 4
        c = Col(150, 152, 165, 255)
    else
        c = Col(232, 190, 150, 255)
    endif
endfunction c

// aseen kuvakoodi: 1 miekka 2 suurmiekka 3 sauva 4 jousi 5 vasara/nuija 6 tikari/rapiiri 7 keihas 8 kirves
function WpnGfx(w as integer)
    r as integer
    r = 1
    if w <= 1 or w = 4
        r = 6
    elseif w = 5
        r = 8
    elseif w = 6
        r = 5
    elseif w = 7
        r = 2
    elseif w = 8 or w = 10
        r = 7
    elseif w = 9
        r = 3
    elseif w >= 11
        r = 4
    endif
endfunction r

function DrawHuman(cx as float, by as float, f as integer, sc as float, br as integer, bg as integer, bb as integer, sk as integer, hat as integer, wpn as integer, shd as integer, up as integer)
    cT as integer
    cB as integer
    cS as integer
    cD as integer
    cSt as integer
    cWd as integer
    cSh1 as integer
    cSh2 as integer
    hx as float
    hy as float
    cT = Col(br, bg, bb, 255)
    cB = Col(Trunc(br * 0.5), Trunc(bg * 0.5), Trunc(bb * 0.5), 255)
    cS = SkinCol(sk)
    cD = Col(40, 34, 30, 255)
    cSt = Col(222, 228, 236, 255)
    cWd = Col(120, 84, 50, 255)
    if shd = 1
        cSh1 = Col(160, 112, 64, 255)
        cSh2 = Col(96, 66, 38, 255)
    else
        cSh1 = Col(200, 206, 215, 255)
        cSh2 = Col(108, 116, 130, 255)
    endif

    DrawLine(cx - 4 * sc, by - 13 * sc, cx - 5 * sc, by, cD, cD)
    DrawLine(cx - 3 * sc, by - 13 * sc, cx - 4 * sc, by, cD, cD)
    DrawLine(cx + 4 * sc, by - 13 * sc, cx + 5 * sc, by, cD, cD)
    DrawLine(cx + 3 * sc, by - 13 * sc, cx + 4 * sc, by, cD, cD)
    if shd > 0 and up = 0
        DrawEllipse(cx - f * 8 * sc, by - 21 * sc, 4.5 * sc, 8 * sc, cSh1, cSh2, 1)
    endif
    DrawBox(cx - 8 * sc, by - 30 * sc, cx + 8 * sc, by - 12 * sc, cT, cT, cB, cB, 1)
    DrawLine(cx - 8 * sc, by - 18 * sc, cx + 8 * sc, by - 18 * sc, cD, cD)
    DrawEllipse(cx, by - 37 * sc, 6 * sc, 6 * sc, cS, cS, 1)
    DrawEllipse(cx + f * 2.5 * sc, by - 38 * sc, 1, 1, cD, cD, 1)

    if hat = 0
        DrawEllipse(cx, by - 41 * sc, 6 * sc, 3 * sc, Col(96, 64, 40, 255), Col(96, 64, 40, 255), 1)
    elseif hat = 1 or hat = 4
        DrawEllipse(cx, by - 40 * sc, 6.5 * sc, 4.5 * sc, cSt, Col(120, 128, 142, 255), 1)
        DrawLine(cx + f * 3 * sc, by - 40 * sc, cx + f * 3 * sc, by - 35 * sc, Col(120, 128, 142, 255), Col(120, 128, 142, 255))
        if hat = 4
            DrawLine(cx, by - 44 * sc, cx - f * 8 * sc, by - 48 * sc, Col(200, 40, 40, 255), Col(200, 40, 40, 255))
            DrawLine(cx, by - 45 * sc, cx - f * 8 * sc, by - 50 * sc, Col(200, 40, 40, 255), Col(200, 40, 40, 255))
        endif
    elseif hat = 2
        DrawEllipse(cx, by - 41 * sc, 9 * sc, 2.5 * sc, Col(80, 50, 130, 255), Col(60, 36, 100, 255), 1)
        FTri(cx - 6 * sc, by - 41 * sc, cx + 6 * sc, by - 41 * sc, cx - f * 3 * sc, by - 55 * sc, Col(90, 56, 150, 255))
    elseif hat = 3
        DrawEllipse(cx - f * 1 * sc, by - 38 * sc, 7.5 * sc, 7.5 * sc, Col(70, 76, 70, 255), Col(40, 44, 40, 255), 1)
        DrawEllipse(cx + f * 2 * sc, by - 37 * sc, 4 * sc, 4.5 * sc, cS, cS, 1)
        DrawEllipse(cx + f * 3 * sc, by - 38 * sc, 1, 1, cD, cD, 1)
    elseif hat = 5
        DrawEllipse(cx, by - 41 * sc, 7 * sc, 3.5 * sc, Col(190, 50, 30, 255), Col(190, 50, 30, 255), 1)
        DrawLine(cx - 4 * sc, by - 43 * sc, cx - 6 * sc, by - 48 * sc, Col(190, 50, 30, 255), Col(190, 50, 30, 255))
        DrawLine(cx + 2 * sc, by - 44 * sc, cx + 3 * sc, by - 49 * sc, Col(190, 50, 30, 255), Col(190, 50, 30, 255))
    endif

    hx = cx + f * 13 * sc
    hy = by - 21 * sc
    DrawLine(cx + f * 7 * sc, by - 27 * sc, hx, hy, cS, cS)
    DrawLine(cx + f * 7 * sc, by - 26 * sc, hx, hy + 1, cS, cS)
    if wpn = 1
        DrawLine(hx, hy, hx + f * 4 * sc, hy - 18 * sc, cSt, cSt)
        DrawLine(hx + 1, hy, hx + f * 4 * sc + 1, hy - 18 * sc, cSt, cSt)
        DrawLine(hx - 3 * sc, hy - 2 * sc, hx + 3 * sc, hy - 2 * sc, cD, cD)
    elseif wpn = 2
        DrawLine(hx, hy + 4 * sc, hx + f * 6 * sc, hy - 28 * sc, cSt, cSt)
        DrawLine(hx + 1, hy + 4 * sc, hx + f * 6 * sc + 1, hy - 28 * sc, cSt, cSt)
        DrawLine(hx + 2, hy + 4 * sc, hx + f * 6 * sc + 2, hy - 28 * sc, cSt, cSt)
    elseif wpn = 3
        DrawLine(hx, hy + 10 * sc, hx + f * 2 * sc, hy - 26 * sc, cWd, cWd)
        DrawLine(hx + 1, hy + 10 * sc, hx + f * 2 * sc + 1, hy - 26 * sc, cWd, cWd)
        DrawEllipse(hx + f * 2 * sc, hy - 29 * sc, 3.5 * sc, 3.5 * sc, Col(160, 220, 255, 255), Col(60, 120, 230, 255), 1)
    elseif wpn = 4
        DrawEllipse(hx + f * 2 * sc, hy - 6 * sc, 3 * sc, 13 * sc, cWd, cWd, 0)
        DrawLine(hx + f * 1 * sc, hy - 19 * sc, hx + f * 1 * sc, hy + 7 * sc, Col(230, 230, 220, 255), Col(230, 230, 220, 255))
    elseif wpn = 5
        DrawLine(hx, hy + 4 * sc, hx + f * 4 * sc, hy - 16 * sc, cWd, cWd)
        DrawLine(hx + 1, hy + 4 * sc, hx + f * 4 * sc + 1, hy - 16 * sc, cWd, cWd)
        DrawBox(hx + f * 4 * sc - 4 * sc, hy - 21 * sc, hx + f * 4 * sc + 4 * sc, hy - 13 * sc, Col(120, 120, 130, 255), Col(120, 120, 130, 255), Col(70, 70, 80, 255), Col(70, 70, 80, 255), 1)
    elseif wpn = 6
        DrawLine(hx, hy, hx + f * 10 * sc, hy - 10 * sc, cSt, cSt)
        DrawLine(hx, hy - 3 * sc, hx + 2 * sc, hy + 1 * sc, cD, cD)
    elseif wpn = 7
        DrawLine(hx - f * 2 * sc, hy + 10 * sc, hx + f * 5 * sc, hy - 30 * sc, cWd, cWd)
        DrawLine(hx - f * 2 * sc + 1, hy + 10 * sc, hx + f * 5 * sc + 1, hy - 30 * sc, cWd, cWd)
        FTri(hx + f * 5 * sc - 2, hy - 28 * sc, hx + f * 5 * sc + 3, hy - 28 * sc, hx + f * 5 * sc, hy - 38 * sc, cSt)
    elseif wpn = 8
        DrawLine(hx, hy + 2 * sc, hx + f * 3 * sc, hy - 18 * sc, cWd, cWd)
        DrawLine(hx + 1, hy + 2 * sc, hx + f * 3 * sc + 1, hy - 18 * sc, cWd, cWd)
        FTri(hx + f * 3 * sc, hy - 19 * sc, hx + f * 11 * sc, hy - 15 * sc, hx + f * 3 * sc, hy - 8 * sc, Col(160, 166, 176, 255))
    endif

    if shd > 0 and up = 1
        DrawEllipse(cx + f * 11 * sc, by - 24 * sc, 5.5 * sc, 11 * sc, cSh1, cSh2, 1)
        DrawEllipse(cx + f * 11 * sc, by - 24 * sc, 2, 2, cD, cD, 1)
    endif
endfunction

function DrawQuad(cx as float, by as float, f as integer, sc as float, r as integer, g as integer, b as integer, kind as integer)
    cT as integer
    cB as integer
    cD as integer
    sw as float
    cT = Col(r, g, b, 255)
    cB = Col(Trunc(r * 0.55), Trunc(g * 0.55), Trunc(b * 0.55), 255)
    cD = Col(36, 30, 26, 255)
    sw = Sin(animT * 300) * 2
    DrawLine(cx - 9 * sc, by - 9 * sc, cx - 9 * sc + sw, by, cD, cD)
    DrawLine(cx - 5 * sc, by - 9 * sc, cx - 5 * sc - sw, by, cD, cD)
    DrawLine(cx + 5 * sc, by - 9 * sc, cx + 5 * sc + sw, by, cD, cD)
    DrawLine(cx + 9 * sc, by - 9 * sc, cx + 9 * sc - sw, by, cD, cD)
    if kind = 2
        DrawLine(cx - f * 12 * sc, by - 12 * sc, cx - f * 24 * sc, by - 4 * sc, Col(210, 150, 150, 255), Col(210, 150, 150, 255))
    else
        DrawLine(cx - f * 13 * sc, by - 14 * sc, cx - f * 19 * sc, by - 19 * sc, cT, cT)
    endif
    DrawEllipse(cx, by - 13 * sc, 14 * sc, 8 * sc, cT, cB, 1)
    DrawEllipse(cx + f * 14 * sc, by - 17 * sc, 6 * sc, 5 * sc, cT, cB, 1)
    FTri(cx + f * 11 * sc, by - 21 * sc, cx + f * 14.5 * sc, by - 21 * sc, cx + f * 12 * sc, by - 27 * sc, cT)
    DrawEllipse(cx + f * 16 * sc, by - 18 * sc, 1, 1, Col(255, 220, 120, 255), Col(255, 220, 120, 255), 1)
    if kind = 1
        DrawLine(cx + f * 18 * sc, by - 15 * sc, cx + f * 21 * sc, by - 21 * sc, Col(240, 236, 220, 255), Col(240, 236, 220, 255))
    elseif kind = 4
        FTri(cx + f * 19 * sc, by - 19 * sc, cx + f * 19 * sc, by - 14 * sc, cx + f * 26 * sc, by - 16 * sc, Col(240, 200, 60, 255))
    endif
endfunction

function DrawSpider(cx as float, by as float, sc as float, r as integer, g as integer, b as integer)
    cT as integer
    cD as integer
    i as integer
    s as integer
    cT = Col(r, g, b, 255)
    cD = Col(24, 20, 22, 255)
    for s = -1 to 1 step 2
        for i = 0 to 3
            DrawLine(cx + s * (3 + i * 2) * sc, by - 14 * sc, cx + s * (7 + i * 5) * sc, by - 24 * sc, cD, cD)
            DrawLine(cx + s * (7 + i * 5) * sc, by - 24 * sc, cx + s * (10 + i * 6) * sc, by, cD, cD)
        next i
    next s
    DrawEllipse(cx - 7 * sc, by - 14 * sc, 8 * sc, 7 * sc, cT, cD, 1)
    DrawEllipse(cx + 4 * sc, by - 14 * sc, 6 * sc, 5 * sc, cT, cD, 1)
    DrawEllipse(cx + 6 * sc, by - 16 * sc, 1, 1, Col(255, 40, 40, 255), Col(255, 40, 40, 255), 1)
    DrawEllipse(cx + 8 * sc, by - 15 * sc, 1, 1, Col(255, 40, 40, 255), Col(255, 40, 40, 255), 1)
endfunction

function DrawWinged(cx as float, by as float, f as integer, sc as float, r as integer, g as integer, b as integer)
    cT as integer
    cB as integer
    cD as integer
    fl as float
    cT = Col(r, g, b, 255)
    cB = Col(Trunc(r * 0.55), Trunc(g * 0.55), Trunc(b * 0.55), 255)
    cD = Col(36, 30, 26, 255)
    fl = Sin(animT * 400) * 6 * sc
    DrawLine(cx - 4 * sc, by - 10 * sc, cx - 5 * sc, by, cD, cD)
    DrawLine(cx + 4 * sc, by - 10 * sc, cx + 5 * sc, by, cD, cD)
    FTri(cx, by - 22 * sc, cx - f * 16 * sc, by - 40 * sc - fl, cx - f * 3 * sc, by - 38 * sc, cB)
    DrawLine(cx - f * 11 * sc, by - 16 * sc, cx - f * 26 * sc, by - 8 * sc, cT, cT)
    DrawLine(cx - f * 11 * sc, by - 17 * sc, cx - f * 26 * sc, by - 9 * sc, cT, cT)
    DrawEllipse(cx, by - 18 * sc, 12 * sc, 7 * sc, cT, cB, 1)
    DrawLine(cx + f * 9 * sc, by - 20 * sc, cx + f * 15 * sc, by - 30 * sc, cT, cT)
    DrawLine(cx + f * 9 * sc, by - 21 * sc, cx + f * 15 * sc, by - 31 * sc, cT, cT)
    DrawEllipse(cx + f * 17 * sc, by - 31 * sc, 5 * sc, 3.5 * sc, cT, cB, 1)
    DrawEllipse(cx + f * 18 * sc, by - 32 * sc, 1, 1, Col(255, 220, 120, 255), Col(255, 220, 120, 255), 1)
endfunction

function DrawLying(cx as float, by as float, f as integer, r as integer, g as integer, b as integer)
    cT as integer
    cB as integer
    cD as integer
    cT = Col(r, g, b, 255)
    cB = Col(Trunc(r * 0.5), Trunc(g * 0.5), Trunc(b * 0.5), 255)
    cD = Col(40, 34, 30, 255)
    DrawLine(cx + f * 12, by - 3, cx + f * 20, by - 1, cD, cD)
    DrawEllipse(cx, by - 5, 15, 5, cT, cB, 1)
    DrawEllipse(cx - f * 16, by - 7, 5, 5, Col(232, 190, 150, 255), Col(180, 140, 110, 255), 1)
endfunction

function DrawFigure(c as integer, px as float, py as float)
    cx as float
    by as float
    f as integer
    m as integer
    s as integer
    i as integer
    n as integer
    r as integer
    g as integer
    b as integer
    cl as integer
    cx = px + CELL / 2.0
    by = py + CELL - 14 + Sin(animT * 160 + c * 57) * 1.2
    f = 1
    if cm[c].side = 1
        f = -1
    endif
    cl = cm[c].cls
    if cm[c].side = 0
        s = cm[c].src
        if cl = CL_FIGHTER
            r = 80
            g = 120
            b = 200
        elseif cl = CL_BARB
            r = 210
            g = 110
            b = 50
        elseif cl = CL_ROGUE
            r = 100
            g = 160
            b = 90
        elseif cl = CL_CHAMP
            r = 220
            g = 200
            b = 110
        else
            r = 160
            g = 100
            b = 200
        endif
        if cm[c].down = 1
            DrawLying(cx, by, f, 90, 90, 100)
        elseif cm[c].prone = 1
            DrawLying(cx, by, f, r, g, b)
        else
            if cl = CL_FIGHTER
                n = 1
            elseif cl = CL_BARB
                n = 5
            elseif cl = CL_ROGUE
                n = 3
            elseif cl = CL_CHAMP
                n = 4
            else
                n = 2
            endif
            DrawHuman(cx, by, f, 1.0, r, g, b, 0, n, WpnGfx(ft[s].weapon), ft[s].shield, cm[c].shield)
        endif
    else
        m = cm[c].mon
        if cm[c].prone = 1
            DrawLying(cx, by, f, 130, 70, 60)
        elseif m = 0
            DrawQuad(cx, by, f, 0.6, 110, 95, 85, 2)
        elseif m = 1
            DrawHuman(cx, by, f, 0.8, 110, 90, 60, 1, 1, 1, 0, 0)
        elseif m = 2
            DrawQuad(cx, by, f, 0.95, 120, 120, 132, 0)
        elseif m = 3
            DrawHuman(cx, by, f, 1.0, 130, 70, 60, 0, 1, 1, 1, 0)
        elseif m = 4
            DrawSpider(cx, by, 1.0, 60, 48, 56)
        elseif m = 5
            DrawQuad(cx, by, f, 1.0, 95, 65, 50, 1)
        elseif m = 6
            DrawQuad(cx, by, f, 1.3, 90, 60, 40, 3)
        elseif m = 7
            DrawHuman(cx, by, f, 1.0, 80, 110, 70, 0, 3, 4, 0, 0)
        elseif m = 8
            DrawHuman(cx, by, f, 1.2, 110, 80, 50, 2, 0, 5, 0, 0)
        elseif m = 9
            DrawHuman(cx, by, f, 1.0, 90, 60, 140, 0, 2, 3, 0, 0)
        elseif m = 10
            DrawQuad(cx, by, f, 1.4, 110, 85, 60, 4)
        elseif m = 11
            DrawHuman(cx, by, f, 1.0, 150, 50, 100, 0, 4, 6, 0, 0)
        elseif m = 12
            DrawHuman(cx, by, f, 1.25, 80, 100, 70, 3, 0, 5, 0, 0)
        elseif m = 13
            DrawWinged(cx, by, f, 1.2, 70, 120, 80)
        elseif m = 14
            DrawHuman(cx, by, f, 1.3, 100, 100, 112, 4, 0, 5, 0, 0)
        elseif m = 15
            DrawHuman(cx, by, f, 1.1, 170, 40, 40, 0, 4, 2, 0, 0)
        elseif m = 16
            DrawWinged(cx, by, f, 1.3, 170, 60, 50)
        else
            DrawHuman(cx, by, f, 1.1, 200, 170, 60, 0, 4, 1, 2, 0)
        endif
    endif

    n = 0
    if cm[c].fright > 0
        DrawEllipse(px + 7 + n * 8, py + 6, 3, 3, Col(240, 220, 60, 255), Col(240, 220, 60, 255), 1)
        n = n + 1
    endif
    if cm[c].rage = 1
        DrawEllipse(px + 7 + n * 8, py + 6, 3, 3, Col(230, 60, 40, 255), Col(230, 60, 40, 255), 1)
        n = n + 1
    endif
    if cm[c].shield = 1
        DrawEllipse(px + 7 + n * 8, py + 6, 3, 3, Col(90, 160, 255, 255), Col(90, 160, 255, 255), 1)
        n = n + 1
    endif
    if cm[c].off > 0
        DrawEllipse(px + 7 + n * 8, py + 6, 3, 3, Col(210, 90, 230, 255), Col(210, 90, 230, 255), 1)
        n = n + 1
    endif
    if cm[c].down = 1
        for i = 1 to cm[c].dying
            DrawEllipse(px + CELL - 8 - (i - 1) * 7, py + 6, 3, 3, Col(255, 40, 40, 255), Col(255, 40, 40, 255), 1)
        next i
    endif
endfunction

function DrawToken(c as integer)
    px as float
    py as float
    px = BOARDX + cm[c].x * CELL
    py = BOARDY + cm[c].y * CELL
    if c = bCur and bOver = 0
        UiRect(px + 2, py + 2, CELL - 4, CELL - 4, 250, 220, 90, 255)
    endif
    if cm[c].side = 0
        UiRect(px + 4, py + 4, CELL - 8, CELL - 8, 52, 78, 120, 255)
    else
        UiRect(px + 4, py + 4, CELL - 8, CELL - 8, 112, 50, 44, 255)
    endif
    UiBar(px + 5, py + CELL - 9, CELL - 10, 6, cm[c].hp / (cm[c].hpMax * 1.0), 70 + cm[c].side * 120, 190 - cm[c].side * 120, 60)
    if bOver = 0 or bEndT > 0
        DrawFigure(c, px, py)
    endif
endfunction
