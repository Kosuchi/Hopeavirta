// ============================================================================
//  core_ui.agc  -  "immediate mode" -kayttoliittyma AGK:n omalla moottorilla
//
//  Suorakulmiot ovat varillisia sprite-laattoja (ei kuvia) ja tekstit AGK:n
//  tekstiobjekteja. Kaikki ne haetaan poolista joka ruudunpaivityksella, ja
//  jarjestys (z) on piirtojarjestys: myohemmin piirretty on ylempana.
//  Vain muuttuneet arvot kirjoitetaan moottorille (valimuisti).
// ============================================================================

#constant UI_MAXR   520
#constant UI_MAXT   520
#constant UI_RID    1000
#constant UI_TID    2000

global uiRN as integer
global uiTN as integer
global uiRP as integer
global uiTP as integer
global uiZ as integer
global uiBlock as integer
global uiClick as integer
global uiMX as float
global uiMY as float
global uiTip as string

global uiRX as float[520]
global uiRY as float[520]
global uiRW as float[520]
global uiRH as float[520]
global uiRC as integer[520]
global uiRA as integer[520]
global uiRV as integer[520]
global uiTX as float[520]
global uiTY as float[520]
global uiTS as float[520]
global uiTC as integer[520]
global uiTA as integer[520]
global uiTL as integer[520]
global uiTV as integer[520]
global uiTStr as string[520]

function UiInit()
    i as integer
    for i = 0 to UI_MAXR - 1
        CreateSprite(UI_RID + i, 0)
        SetSpriteVisible(UI_RID + i, 0)
        uiRX[i] = -9999
        uiRY[i] = -9999
        uiRW[i] = 0
        uiRH[i] = 0
        uiRC[i] = -1
        uiRA[i] = -1
        uiRV[i] = 0
    next i
    for i = 0 to UI_MAXT - 1
        CreateText(UI_TID + i, "")
        SetTextVisible(UI_TID + i, 0)
        uiTX[i] = -9999
        uiTY[i] = -9999
        uiTS[i] = 0
        uiTC[i] = -1
        uiTA[i] = -1
        uiTL[i] = -1
        uiTV[i] = 0
        uiTStr[i] = ""
    next i
    uiRP = 0
    uiTP = 0
endfunction

function UiBegin()
    uiRN = 0
    uiTN = 0
    uiZ = 0
    uiBlock = 0
    uiTip = ""
    uiMX = GetPointerX()
    uiMY = GetPointerY()
    uiClick = GetPointerPressed()
endfunction

function UiEnd()
    i as integer
    if uiTip <> ""
        UiRect(SCRW / 2 - 330, 694, 660, 24, 8, 6, 4, 235)
        UiText(SCRW / 2, 697, 16, uiTip, 245, 215, 130, 1)
    endif
    for i = uiRN to uiRP - 1
        SetSpriteVisible(UI_RID + i, 0)
        uiRV[i] = 0
    next i
    for i = uiTN to uiTP - 1
        SetTextVisible(UI_TID + i, 0)
        uiTV[i] = 0
    next i
    uiRP = uiRN
    uiTP = uiTN
endfunction

function UiRect(x as float, y as float, w as float, h as float, r as integer, g as integer, b as integer, a as integer)
    id as integer
    c as integer
    if uiRN >= UI_MAXR
        exitfunction
    endif
    id = UI_RID + uiRN
    c = r * 65536 + g * 256 + b
    if uiRV[uiRN] = 0
        SetSpriteVisible(id, 1)
        uiRV[uiRN] = 1
    endif
    if uiRX[uiRN] <> x or uiRY[uiRN] <> y
        SetSpritePosition(id, x, y)
        uiRX[uiRN] = x
        uiRY[uiRN] = y
    endif
    if uiRW[uiRN] <> w or uiRH[uiRN] <> h
        SetSpriteSize(id, w, h)
        uiRW[uiRN] = w
        uiRH[uiRN] = h
    endif
    if uiRC[uiRN] <> c or uiRA[uiRN] <> a
        SetSpriteColor(id, r, g, b, a)
        uiRC[uiRN] = c
        uiRA[uiRN] = a
    endif
    SetSpriteDepth(id, 9500 - uiZ * 9)
    uiRN = uiRN + 1
    uiZ = uiZ + 1
endfunction

// al: 0 vasen, 1 keski, 2 oikea
function UiText(x as float, y as float, size as float, s as string, r as integer, g as integer, b as integer, al as integer)
    id as integer
    c as integer
    if uiTN >= UI_MAXT
        exitfunction
    endif
    id = UI_TID + uiTN
    c = r * 65536 + g * 256 + b
    if uiTV[uiTN] = 0
        SetTextVisible(id, 1)
        uiTV[uiTN] = 1
    endif
    if uiTStr[uiTN] <> s
        SetTextString(id, Tx(s))
        uiTStr[uiTN] = s
    endif
    if uiTS[uiTN] <> size
        SetTextSize(id, size)
        uiTS[uiTN] = size
    endif
    if uiTL[uiTN] <> al
        SetTextAlignment(id, al)
        uiTL[uiTN] = al
    endif
    if uiTX[uiTN] <> x or uiTY[uiTN] <> y
        SetTextPosition(id, x, y)
        uiTX[uiTN] = x
        uiTY[uiTN] = y
    endif
    if uiTC[uiTN] <> c
        SetTextColor(id, r, g, b, 255)
        uiTC[uiTN] = c
    endif
    SetTextDepth(id, 9500 - uiZ * 9)
    uiTN = uiTN + 1
    uiZ = uiZ + 1
endfunction

function UiPanel(x as float, y as float, w as float, h as float)
    UiRect(x - 2, y - 2, w + 4, h + 4, 96, 76, 48, 255)
    UiRect(x, y, w, h, 36, 29, 24, 250)
endfunction

function UiBar(x as float, y as float, w as float, h as float, frac as float, r as integer, g as integer, b as integer)
    f as float
    f = Clampf(frac, 0, 1)
    UiRect(x, y, w, h, 14, 10, 8, 255)
    if f > 0
        UiRect(x + 1, y + 1, (w - 2) * f, h - 2, r, g, b, 255)
    endif
endfunction

// en: 0 pois kaytosta, 1 normaali, 2 valittu/korostettu
function UiBtn(x as float, y as float, w as float, h as float, label as string, en as integer, tip as string)
    hov as integer
    res as integer
    r as integer
    g as integer
    b as integer
    fs as float
    res = 0
    hov = 0
    if uiMX >= x and uiMX <= x + w and uiMY >= y and uiMY <= y + h
        hov = 1
    endif
    if en = 0
        r = 50
        g = 46
        b = 42
    else
        if en = 2
            r = 150
            g = 116
            b = 46
        else
            r = 82
            g = 64
            b = 38
        endif
        if hov = 1 and uiBlock = 0
            r = r + 40
            g = g + 30
            b = b + 14
            if tip <> ""
                uiTip = tip
            endif
            if uiClick = 1
                res = 1
                uiClick = 0
                Sfx(S_CLICK, 40)
            endif
        endif
    endif
    UiRect(x - 2, y - 2, w + 4, h + 4, 20, 15, 10, 255)
    UiRect(x, y, w, h, r, g, b, 255)
    fs = 17
    if h < 30
        fs = 14
    endif
    if en = 0
        UiText(x + w / 2, y + (h - fs) / 2 - 1, fs, label, 128, 118, 108, 1)
    else
        UiText(x + w / 2, y + (h - fs) / 2 - 1, fs, label, 245, 235, 210, 1)
    endif
endfunction res

function UiButton(x as float, y as float, w as float, h as float, label as string)
    r as integer
    r = UiBtn(x, y, w, h, label, 1, "")
endfunction r

function UiHeader(title as string)
    UiRect(0, 0, SCRW, SCRH, 24, 19, 16, 255)
    UiRect(0, 0, SCRW, 56, 52, 41, 30, 255)
    UiRect(0, 56, SCRW, 3, 130, 100, 55, 255)
    UiText(20, 12, 30, title, 235, 195, 95, 0)
    UiText(SCRW - 20, 8, 17, "Kassa: " + Money(gold), 245, 235, 200, 2)
    UiText(SCRW - 20, 31, 15, "Viikko " + Str(week) + "   Maine " + Str(fame), 200, 185, 150, 2)
    if msgT > 0
        UiRect(SCRW / 2 - 330, 664, 660, 26, 70, 20, 16, 240)
        UiText(SCRW / 2, 668, 17, msg, 255, 225, 170, 1)
    endif
endfunction
