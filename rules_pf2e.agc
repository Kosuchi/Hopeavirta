// ============================================================================
//  rules_pf2e.agc  -  Pathfinder 2E (Remaster) -saannot, ORC-lisenssi
//  Onnistumisasteet, ammattitaito, taso-pohjaiset vertailuarvot (GM Core,
//  "Building Creatures"), kokemuspisteet ja kohtaamisbudjetit.
//  Taulukot on pakattu kiintealevyisiksi merkkijonoiksi, tasot -1..10.
// ============================================================================

function InitRules()
    // 4 rivia: 0 aaripaa (extreme), 1 korkea, 2 kohtalainen, 3 matala
    tAC[0] = "181919212224252728303133"
    tAC[1] = "151616181921222425272830"
    tAC[2] = "141515171820212324262729"
    tAC[3] = "121313151618192122242527"

    tAtk[0] = "101011131416171920222325"
    tAtk[1] = "080809111214151718202123"
    tAtk[2] = "060607091012131516181921"
    tAtk[3] = "040405070809111213151617"

    tSav[0] = "091011121415171820212324"
    tSav[1] = "080910111214151718192122"
    tSav[2] = "050607080911121415161819"
    tSav[3] = "020304050608091112131516"

    tHP[0] = "009019025038056075094119144169194219"
    tHP[1] = "009019025038056075094119144169194219"
    tHP[2] = "007015020030045060075095115135155175"
    tHP[3] = "005012015023034045056071086101116131"

    // vahinko: nopat(1) noppa(2) kiintea(2)
    tDmg[0] = "106011060310804112041120821007212072121021212212152121721220"
    tDmg[1] = "104011060210603110041100620805208072080921009210112101321213"
    tDmg[2] = "104001040210602108041080620605206062060820808208092081121011"
    tDmg[3] = "104001040110402106031060520404204062040720606206082060920610"

    // XP tason erolla -4..+4
    xpDiff[0] = 10
    xpDiff[1] = 15
    xpDiff[2] = 20
    xpDiff[3] = 30
    xpDiff[4] = 40
    xpDiff[5] = 60
    xpDiff[6] = 80
    xpDiff[7] = 120
    xpDiff[8] = 160

    // kohtaamisbudjetti 4 hahmolle ja korjaus hahmoa kohden (Matala, Kohtalainen, Vakava, Aaarimmainen)
    bdBase[0] = 60
    bdBase[1] = 80
    bdBase[2] = 120
    bdBase[3] = 160
    bdAdj[0] = 15
    bdAdj[1] = 20
    bdAdj[2] = 30
    bdAdj[3] = 40
endfunction

function LvIdx(lvl as integer)
    r as integer
    r = Clampi(lvl + 1, 0, 11)
endfunction r

function MonAC(t as integer, lvl as integer)
    r as integer
    r = TblVal(tAC[t], LvIdx(lvl), 2)
endfunction r

function MonAtk(t as integer, lvl as integer)
    r as integer
    r = TblVal(tAtk[t], LvIdx(lvl), 2)
endfunction r

function MonSave(t as integer, lvl as integer)
    r as integer
    r = TblVal(tSav[t], LvIdx(lvl), 2)
endfunction r

function MonHP(t as integer, lvl as integer)
    r as integer
    r = TblVal(tHP[t], LvIdx(lvl), 3)
endfunction r

function MonDice(t as integer, lvl as integer)
    v as integer
    r as integer
    v = TblVal(tDmg[t], LvIdx(lvl), 5)
    r = Trunc(v / 10000.0)
endfunction r

function MonDie(t as integer, lvl as integer)
    v as integer
    d as integer
    r as integer
    v = TblVal(tDmg[t], LvIdx(lvl), 5)
    d = Trunc(v / 10000.0)
    r = Trunc((v - d * 10000) / 100.0)
endfunction r

function MonFlat(t as integer, lvl as integer)
    v as integer
    d as integer
    e as integer
    r as integer
    v = TblVal(tDmg[t], LvIdx(lvl), 5)
    d = Trunc(v / 10000.0)
    e = Trunc((v - d * 10000) / 100.0)
    r = v - d * 10000 - e * 100
endfunction r

// ammattitaito: 0 kouluttamaton, 1 koulutettu, 2 asiantunteva, 3 mestari, 4 legendaarinen
function ProfB(rank as integer, lvl as integer)
    r as integer
    r = 0
    if rank > 0
        r = 2 * rank + lvl
    endif
endfunction r

// onnistumisaste: 3 kriittinen onnistuminen, 2 onnistuminen, 1 epaonnistuminen, 0 kriittinen epaonnistuminen
function Degree(total as integer, dc as integer, nat as integer)
    d as integer
    if total >= dc + 10
        d = 3
    elseif total >= dc
        d = 2
    elseif total <= dc - 10
        d = 0
    else
        d = 1
    endif
    if nat = 20
        d = IMin(3, d + 1)
    endif
    if nat = 1
        d = IMax(0, d - 1)
    endif
endfunction d

function DegTxt(d as integer)
    s as string
    if d = 3
        s = "KRIITTINEN OSUMA"
    elseif d = 2
        s = "osuma"
    elseif d = 1
        s = "ohi"
    else
        s = "kriittinen ohi"
    endif
endfunction s

function XPDiff(diff as integer)
    r as integer
    if diff < -4
        r = 0
    elseif diff > 4
        r = 160
    else
        r = xpDiff[diff + 4]
    endif
endfunction r

// tier: 0 Matala 1 Kohtalainen 2 Vakava 3 Aaarimmainen
function Budget(tier as integer, n as integer)
    r as integer
    r = bdBase[tier] + (n - 4) * bdAdj[tier]
    if r < 10
        r = 10
    endif
endfunction r

function TierName(t as integer)
    s as string
    if t = 0
        s = "Matala"
    elseif t = 1
        s = "Kohtalainen"
    elseif t = 2
        s = "Vakava"
    else
        s = "{A}{a}rimm{a}inen"
    endif
endfunction s
