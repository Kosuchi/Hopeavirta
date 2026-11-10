// ============================================================================
//  data_gear.agc  -  aseet, panssarit, kilvet, juomat ja riimut
//  Hinnat kuparia (100 k = 1 kr), pohjana PF2E:n hinnat.
// ============================================================================

function SetWeapon(i as integer, nm as string, die as integer, fl as integer, dd as integer, rng as integer, price as integer)
    wpN[i] = nm
    wpD[i] = die
    wpF[i] = fl
    wpDd[i] = dd
    wpR[i] = rng
    wpP[i] = price
endfunction

function SetArmor(i as integer, nm as string, ac as integer, cap as integer, sp as integer, price as integer)
    arN[i] = nm
    arAC[i] = ac
    arCap[i] = cap
    arSp[i] = sp
    arP[i] = price
endfunction

function InitGear()
    //        id  nimi              noppa liput                              deadly kantama hinta
    SetWeapon(0, "Nyrkki",          4, WF_AGILE + WF_FINESSE,                 0, 0, 0)
    SetWeapon(1, "Tikari",          4, WF_AGILE + WF_FINESSE,                 0, 0, 20)
    SetWeapon(2, "Lyhytmiekka",     6, WF_AGILE + WF_FINESSE + WF_MARTIAL,    0, 0, 90)
    SetWeapon(3, "Pitk{a}miekka",   8, WF_MARTIAL,                            0, 0, 100)
    SetWeapon(4, "Rapiiri",         6, WF_FINESSE + WF_MARTIAL,               8, 0, 200)
    SetWeapon(5, "Taistelukirves",  8, WF_MARTIAL,                            0, 0, 100)
    SetWeapon(6, "Sotavasara",      8, WF_MARTIAL,                            0, 0, 100)
    SetWeapon(7, "Suurmiekka",     12, WF_MARTIAL + WF_TWOH,                  0, 0, 200)
    SetWeapon(8, "Keih{a}s",        6, 0,                                     0, 0, 10)
    SetWeapon(9, "Sauva",           4, WF_TWOH,                               0, 0, 0)
    SetWeapon(10, "Glaivi",         8, WF_MARTIAL + WF_REACH + WF_TWOH,       8, 0, 800)
    SetWeapon(11, "Lyhytjousi",     6, WF_MARTIAL + WF_RANGED + WF_TWOH,     10, 12, 300)
    SetWeapon(12, "Pitk{a}jousi",   8, WF_MARTIAL + WF_RANGED + WF_TWOH,     10, 14, 600)

    //         id  nimi                  AC  dexcap hidastus hinta
    SetArmor(0, "Ei panssaria",          0,  99,    0,       0)
    SetArmor(1, "Pehmustettu",           1,  3,     0,       20)
    SetArmor(2, "Nahkapanssari",         1,  4,     0,       200)
    SetArmor(3, "Nauhattu nahka",        2,  3,     0,       300)
    SetArmor(4, "Rengaspaita",           2,  3,     0,       500)
    SetArmor(5, "Rengashaarniska",       4,  1,     1,       600)
    SetArmor(6, "Rintapanssari",         4,  1,     1,       800)
    SetArmor(7, "Levyhaarniska",         6,  0,     2,       3000)

    shN[0] = "Ei kilpe{a}"
    shH[0] = 0
    shP[0] = 0
    shN[1] = "Puukilpi"
    shH[1] = 3
    shP[1] = 100
    shN[2] = "Ter{a}skilpi"
    shH[2] = 5
    shP[2] = 200

    // parannusjuomat: Heikko 1d8, Lievempi 2d8+5, Kohtalainen 3d8+10
    ptN[0] = "Heikko parannusjuoma"
    ptDn[0] = 1
    ptDd[0] = 8
    ptFl[0] = 0
    ptP[0] = 400
    ptN[1] = "Parannusjuoma"
    ptDn[1] = 2
    ptDd[1] = 8
    ptFl[1] = 5
    ptP[1] = 1200
    ptN[2] = "Vahva parannusjuoma"
    ptDn[2] = 3
    ptDd[2] = 8
    ptFl[2] = 10
    ptP[2] = 5000

    // riimut: kumulatiiviset hinnat tasoille 0..3 (PF2E:n hinnat)
    rnW[0] = 0
    rnW[1] = 3500
    rnW[2] = 93500
    rnW[3] = 893500
    rnS[0] = 0
    rnS[1] = 6500
    rnS[2] = 106500
    rnS[3] = 3106500
    rnA[0] = 0
    rnA[1] = 16000
    rnA[2] = 106000
    rnA[3] = 2056000
    rnR[0] = 0
    rnR[1] = 34000
    rnR[2] = 344000
    rnR[3] = 4944000
endfunction

// markkinahinta: indeksi k, sepan alennus 5 % / taso
function Pr(base as integer, k as integer)
    r as integer
    f as float
    f = base * mkt[k] * (1.0 - 0.05 * facW)
    r = Trunc(f)
    if r < 1 and base > 0
        r = 1
    endif
endfunction r
