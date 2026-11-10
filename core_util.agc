// ============================================================================
//  core_util.agc  -  satunnaisuus, matematiikka, merkkijonot
// ============================================================================

function RF(lo as float, hi as float)
    v as float
    v = lo + (hi - lo) * Random(0, 10000) / 10000.0
endfunction v

function RI(lo as integer, hi as integer)
    v as integer
    v = lo
    if hi > lo
        v = Random(lo, hi)
    endif
endfunction v

function IAbs(v as integer)
    r as integer
    r = v
    if v < 0
        r = -v
    endif
endfunction r

function IMin(a as integer, b as integer)
    r as integer
    r = a
    if b < a
        r = b
    endif
endfunction r

function IMax(a as integer, b as integer)
    r as integer
    r = a
    if b > a
        r = b
    endif
endfunction r

function FMin(a as float, b as float)
    r as float
    r = a
    if b < a
        r = b
    endif
endfunction r

function FMax(a as float, b as float)
    r as float
    r = a
    if b > a
        r = b
    endif
endfunction r

function Clampi(v as integer, lo as integer, hi as integer)
    r as integer
    r = v
    if r < lo
        r = lo
    endif
    if r > hi
        r = hi
    endif
endfunction r

function Clampf(v as float, lo as float, hi as float)
    r as float
    r = v
    if r < lo
        r = lo
    endif
    if r > hi
        r = hi
    endif
endfunction r

function SignStr(n as integer)
    s as string
    if n >= 0
        s = "+" + Str(n)
    else
        s = Str(n)
    endif
endfunction s

// nopanheitto: n kpl d-sivuista
function Roll(n as integer, d as integer)
    i as integer
    s as integer
    s = 0
    for i = 1 to n
        s = s + RI(1, d)
    next i
endfunction s

function D20()
    v as integer
    v = RI(1, 20)
endfunction v

// PF2E-etaisyys ruutuina: vinottain joka toinen ruutu maksaa 2
function Dist(x1 as integer, y1 as integer, x2 as integer, y2 as integer)
    dx as integer
    dy as integer
    r as integer
    dx = IAbs(x1 - x2)
    dy = IAbs(y1 - y2)
    r = IMax(dx, dy) + Trunc(IMin(dx, dy) / 2.0)
endfunction r

// lukee kiintealevyisen luvun taulukkomerkkijonosta
function TblVal(s as string, i as integer, w as integer)
    v as float
    r as integer
    v = Val(Mid(s, i * w + 1, w))
    r = Trunc(v)
endfunction r

// {a} -> a-umlaut, {o} -> o-umlaut, {A} -> A-umlaut, {O} -> O-umlaut (Chr 228/246/196/214)
function Tx(s as string)
    out as string
    ch as string
    tg as string
    rep as string
    i as integer
    n as integer
    n = Len(s)
    out = ""
    i = 1
    while i <= n
        ch = Mid(s, i, 1)
        rep = ""
        if ch = "{" and i + 2 <= n
            if Mid(s, i + 2, 1) = "}"
                tg = Mid(s, i + 1, 1)
                if tg = "a"
                    rep = Chr(228)
                elseif tg = "o"
                    rep = Chr(246)
                elseif tg = "A"
                    rep = Chr(196)
                elseif tg = "O"
                    rep = Chr(214)
                endif
            endif
        endif
        if rep <> ""
            out = out + rep
            i = i + 3
        else
            out = out + ch
            i = i + 1
        endif
    endwhile
endfunction out

// kolikot: 1 kruunu (kr) = 10 hopeaa (h) = 100 kuparia (k)
function Money(cp as integer)
    s as string
    g as integer
    sv as integer
    c as integer
    neg as integer
    neg = 0
    if cp < 0
        neg = 1
        cp = -cp
    endif
    g = Trunc(cp / 100.0)
    sv = Trunc((cp - g * 100) / 10.0)
    c = cp - g * 100 - sv * 10
    s = ""
    if g > 0
        s = Str(g) + " kr"
    endif
    if sv > 0
        if s <> ""
            s = s + " "
        endif
        s = s + Str(sv) + " h"
    endif
    if c > 0 or s = ""
        if s <> ""
            s = s + " "
        endif
        s = s + Str(c) + " k"
    endif
    if neg = 1
        s = "-" + s
    endif
endfunction s

function FirstWord(s as string)
    out as string
    i as integer
    ch as string
    out = ""
    for i = 1 to Len(s)
        ch = Mid(s, i, 1)
        if ch = " "
            exit
        endif
        out = out + ch
    next i
endfunction out

function SetMsg(s as string)
    msg = s
    msgT = 3.5
endfunction

// ABGR-vari alfakanavalla piirtokomentoja varten
function Col(r as integer, g as integer, b as integer, a as integer)
    c as integer
    if a < 0
        a = 0
    endif
    if a > 255
        a = 255
    endif
    c = (a << 24) || (b << 16) || (g << 8) || r
endfunction c

// taytetty kolmio viuhkana viivoja
function FTri(x1 as float, y1 as float, x2 as float, y2 as float, x3 as float, y3 as float, c as integer)
    dx as float
    dy as float
    n as integer
    i as integer
    dx = x3 - x2
    dy = y3 - y2
    n = Trunc(Sqrt(dx * dx + dy * dy)) + 2
    for i = 0 to n
        DrawLine(x1, y1, x2 + dx * i / n, y2 + dy * i / n, c, c)
    next i
endfunction
