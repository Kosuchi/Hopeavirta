// ============================================================================
//  audio.agc  -  aaniefektit syntetisoidaan muistilohkoon (ei aaniatiedostoja)
//  MakeSnd: f0/f1 taajuus Hz, dur kesto s, vol 0..1, att nousuaika s,
//  dp vaimenemisen jyrkkyys 0..3, nmix kohinan osuus, nk kohinan kirkkaus,
//  vspd/vdep vibraton nopeus ja syvyys.
// ============================================================================

#constant SNDRATE   16000
#constant S_CLICK   1
#constant S_HIT     2
#constant S_CRIT    3
#constant S_MISS    4
#constant S_BOW     5
#constant S_ARC     6
#constant S_BARR    7
#constant S_FIRE    8
#constant S_HEAL    9
#constant S_TRIP    10
#constant S_SCARE   11
#constant S_RAGE    12
#constant S_SHIELD  13
#constant S_BLOCK   14
#constant S_STEP    15
#constant S_FALL    16
#constant S_DEATH   17
#constant S_COIN    18
#constant S_LEVEL   19
#constant S_WIN     20
#constant S_LOSE    21
#constant S_CROWD   22
#constant S_BELL    23

function MakeSnd(id as integer, f0 as float, f1 as float, dur as float, vol as float, att as float, dp as integer, nmix as float, nk as float, vspd as float, vdep as float)
    n as integer
    i as integer
    mem as integer
    v as integer
    p as float
    e as float
    f as float
    ph as float
    vph as float
    tone as float
    ns as float
    wn as float
    k as float
    nz as float
    smp as float
    env as float
    rel as float
    attN as float

    n = Trunc(dur * SNDRATE)
    mem = CreateMemblock(12 + n * 2)
    SetMemblockShort(mem, 0, 1)
    SetMemblockShort(mem, 2, 16)
    SetMemblockInt(mem, 4, SNDRATE)
    SetMemblockInt(mem, 8, n)
    ph = 0
    vph = 0
    ns = 0
    attN = att * SNDRATE + 1

    for i = 0 to n - 1
        p = i / (n * 1.0)
        e = 1 - p
        f = f0 + (f1 - f0) * (1 - e * e)
        vph = vph + 360.0 * vspd / SNDRATE
        ph = ph + 360.0 * f * (1 + vdep * Sin(vph)) / SNDRATE
        tone = 0.75 * Sin(ph) + 0.25 * Sin(ph * 2)

        nz = 0
        if nmix > 0
            k = nk * (1 - 0.75 * p) + 0.01
            if k > 1
                k = 1
            endif
            wn = Random(-1000, 1000) / 1000.0
            ns = ns + (wn - ns) * k
            nz = ns * Sqrt((2 - k) / k) * 0.7
            if nz > 1
                nz = 1
            endif
            if nz < -1
                nz = -1
            endif
        endif
        smp = (1 - nmix) * tone + nmix * nz

        env = 1
        if dp >= 1
            env = e
        endif
        if dp >= 2
            env = env * e
        endif
        if dp >= 3
            env = env * e
        endif
        if i < attN
            env = env * i / attN
        endif
        rel = e * 12.5
        if rel < 1
            env = env * rel
        endif

        v = Trunc(smp * env * vol * 30000)
        if v > 32000
            v = 32000
        endif
        if v < -32000
            v = -32000
        endif
        SetMemblockShort(mem, 12 + i * 2, v)
    next i

    if GetSoundExists(id) = 1
        DeleteSound(id)
    endif
    CreateSoundFromMemblock(id, mem)
    DeleteMemblock(mem)
endfunction

function InitAudio()
    //       id       f0    f1   dur   vol   att    dp nmix  nk    vspd vdep
    MakeSnd(S_CLICK,  1400,  900, 0.04, 0.25, 0.001, 2, 0.10, 0.70,   0, 0.00)
    MakeSnd(S_HIT,     180,   70, 0.16, 0.80, 0.002, 2, 0.55, 0.35,   0, 0.00)
    MakeSnd(S_CRIT,    140,   40, 0.38, 1.00, 0.002, 2, 0.60, 0.25,   0, 0.00)
    MakeSnd(S_MISS,      0,    0, 0.18, 0.35, 0.060, 1, 1.00, 0.50,   0, 0.00)
    MakeSnd(S_BOW,     520,  180, 0.20, 0.45, 0.001, 2, 0.15, 0.80,  40, 0.10)
    MakeSnd(S_ARC,     900,  200, 0.35, 0.60, 0.001, 1, 0.35, 0.90,  55, 0.50)
    MakeSnd(S_BARR,    400, 1200, 0.40, 0.50, 0.010, 1, 0.15, 0.80,  18, 0.20)
    MakeSnd(S_FIRE,     90,   25, 1.10, 1.00, 0.004, 2, 0.75, 0.15,   0, 0.00)
    MakeSnd(S_HEAL,    660,  990, 0.55, 0.50, 0.010, 2, 0.00, 1.00,   6, 0.02)
    MakeSnd(S_TRIP,    110,   50, 0.20, 0.70, 0.002, 2, 0.40, 0.20,   0, 0.00)
    MakeSnd(S_SCARE,   120,   70, 0.50, 0.60, 0.080, 1, 0.30, 0.15,  22, 0.30)
    MakeSnd(S_RAGE,     90,  160, 0.70, 0.80, 0.100, 1, 0.50, 0.20,  30, 0.25)
    MakeSnd(S_SHIELD,  700,  500, 0.30, 0.50, 0.001, 2, 0.20, 0.90,  70, 0.10)
    MakeSnd(S_BLOCK,   900,  600, 0.22, 0.70, 0.001, 2, 0.25, 0.90,  90, 0.08)
    MakeSnd(S_STEP,     70,   50, 0.08, 0.40, 0.002, 2, 0.50, 0.15,   0, 0.00)
    MakeSnd(S_FALL,     80,   35, 0.45, 0.80, 0.002, 2, 0.50, 0.12,   0, 0.00)
    MakeSnd(S_DEATH,   220,   60, 1.00, 0.60, 0.020, 1, 0.15, 0.30,   4, 0.08)
    MakeSnd(S_COIN,   1400, 1800, 0.25, 0.40, 0.001, 2, 0.00, 1.00,  20, 0.05)
    MakeSnd(S_LEVEL,   400,  900, 0.80, 0.55, 0.020, 1, 0.00, 1.00,   5, 0.03)
    MakeSnd(S_WIN,     523,  784, 1.10, 0.55, 0.020, 1, 0.00, 1.00,   3, 0.02)
    MakeSnd(S_LOSE,    300,  110, 1.20, 0.55, 0.030, 1, 0.00, 1.00,   2, 0.05)
    MakeSnd(S_CROWD,     0,    0, 1.40, 0.50, 0.400, 1, 1.00, 0.25,   0, 0.00)
    MakeSnd(S_BELL,    520,  520, 1.20, 0.50, 0.003, 2, 0.00, 1.00,   0, 0.00)
endfunction

function Sfx(id as integer, vol as integer)
    PlaySound(id, vol, 0)
endfunction

function StrikeSfx(a as integer, deg as integer)
    if deg = 3
        Sfx(S_CRIT, 100)
    elseif deg = 2
        if cm[a].ranged = 1
            Sfx(S_BOW, 70)
        else
            Sfx(S_HIT, 85)
        endif
    else
        if cm[a].ranged = 1
            Sfx(S_BOW, 50)
        else
            Sfx(S_MISS, 60)
        endif
    endif
endfunction
