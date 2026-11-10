// ============================================================================
//  save_load.agc  -  tallennus ja lataus (hopeavirta.sav)
// ============================================================================

function SaveGame()
    f as integer
    i as integer
    k as integer
    f = OpenToWrite("hopeavirta.sav")
    if f = 0
        exitfunction
    endif
    WriteInteger(f, 1)
    WriteString(f, guildName)
    WriteInteger(f, gold)
    WriteInteger(f, debt)
    WriteInteger(f, week)
    WriteInteger(f, fame)
    WriteInteger(f, ticketLv)
    WriteInteger(f, sponsor)
    WriteInteger(f, sponsorIdle)
    WriteInteger(f, facB)
    WriteInteger(f, facT)
    WriteInteger(f, facI)
    WriteInteger(f, facS)
    WriteInteger(f, facW)
    WriteInteger(f, wkIn)
    WriteInteger(f, wkOut)
    WriteInteger(f, lastIn)
    WriteInteger(f, lastOut)
    WriteInteger(f, Trunc(demand * 1000))
    for k = 0 to 4
        WriteInteger(f, Trunc(mkt[k] * 1000))
    next k
    for k = 0 to 7
        WriteInteger(f, histNet[k])
    next k
    for i = 0 to MAXFT - 1
        WriteInteger(f, ft[i].used)
        if ft[i].used = 1
            WriteString(f, ft[i].name)
            WriteInteger(f, ft[i].anc)
            WriteInteger(f, ft[i].cls)
            WriteInteger(f, ft[i].level)
            WriteInteger(f, ft[i].xp)
            WriteInteger(f, ft[i].aStr)
            WriteInteger(f, ft[i].aDex)
            WriteInteger(f, ft[i].aCon)
            WriteInteger(f, ft[i].aInt)
            WriteInteger(f, ft[i].aWis)
            WriteInteger(f, ft[i].aCha)
            WriteInteger(f, ft[i].weapon)
            WriteInteger(f, ft[i].armor)
            WriteInteger(f, ft[i].shield)
            WriteInteger(f, ft[i].wPot)
            WriteInteger(f, ft[i].wStrk)
            WriteInteger(f, ft[i].aPot)
            WriteInteger(f, ft[i].aRes)
            WriteInteger(f, ft[i].pot1)
            WriteInteger(f, ft[i].pot2)
            WriteInteger(f, ft[i].pot3)
            WriteInteger(f, ft[i].hp)
            WriteInteger(f, ft[i].injury)
            WriteInteger(f, ft[i].wounded)
            WriteInteger(f, ft[i].wage)
            WriteInteger(f, ft[i].pop)
            WriteInteger(f, ft[i].wins)
            WriteInteger(f, ft[i].losses)
            WriteInteger(f, ft[i].trained)
            WriteInteger(f, ft[i].fought)
        endif
    next i
    CloseFile(f)
endfunction

// palauttaa 1 jos onnistui
function LoadGame()
    f as integer
    i as integer
    k as integer
    ver as integer
    r as integer
    r = 0
    f = OpenToRead("hopeavirta.sav")
    if f = 0
        exitfunction r
    endif
    ver = ReadInteger(f)
    if ver <> 1
        CloseFile(f)
        exitfunction r
    endif
    NewGuild()
    guildName = ReadString(f)
    gold = ReadInteger(f)
    debt = ReadInteger(f)
    week = ReadInteger(f)
    fame = ReadInteger(f)
    ticketLv = ReadInteger(f)
    sponsor = ReadInteger(f)
    sponsorIdle = ReadInteger(f)
    facB = ReadInteger(f)
    facT = ReadInteger(f)
    facI = ReadInteger(f)
    facS = ReadInteger(f)
    facW = ReadInteger(f)
    wkIn = ReadInteger(f)
    wkOut = ReadInteger(f)
    lastIn = ReadInteger(f)
    lastOut = ReadInteger(f)
    demand = ReadInteger(f) / 1000.0
    for k = 0 to 4
        mkt[k] = ReadInteger(f) / 1000.0
    next k
    for k = 0 to 7
        histNet[k] = ReadInteger(f)
    next k
    for i = 0 to MAXFT - 1
        ft[i] = gBlankFt
        ft[i].used = ReadInteger(f)
        if ft[i].used = 1
            ft[i].name = ReadString(f)
            ft[i].anc = ReadInteger(f)
            ft[i].cls = ReadInteger(f)
            ft[i].level = ReadInteger(f)
            ft[i].xp = ReadInteger(f)
            ft[i].aStr = ReadInteger(f)
            ft[i].aDex = ReadInteger(f)
            ft[i].aCon = ReadInteger(f)
            ft[i].aInt = ReadInteger(f)
            ft[i].aWis = ReadInteger(f)
            ft[i].aCha = ReadInteger(f)
            ft[i].weapon = ReadInteger(f)
            ft[i].armor = ReadInteger(f)
            ft[i].shield = ReadInteger(f)
            ft[i].wPot = ReadInteger(f)
            ft[i].wStrk = ReadInteger(f)
            ft[i].aPot = ReadInteger(f)
            ft[i].aRes = ReadInteger(f)
            ft[i].pot1 = ReadInteger(f)
            ft[i].pot2 = ReadInteger(f)
            ft[i].pot3 = ReadInteger(f)
            ft[i].hp = ReadInteger(f)
            ft[i].injury = ReadInteger(f)
            ft[i].wounded = ReadInteger(f)
            ft[i].wage = ReadInteger(f)
            ft[i].pop = ReadInteger(f)
            ft[i].wins = ReadInteger(f)
            ft[i].losses = ReadInteger(f)
            ft[i].trained = ReadInteger(f)
            ft[i].fought = ReadInteger(f)
        endif
    next i
    CloseFile(f)
    RefreshRecruits()
    GenerateCards()
    news[0] = "Tervetuloa takaisin, Kilta-Mestari."
    r = 1
endfunction r
