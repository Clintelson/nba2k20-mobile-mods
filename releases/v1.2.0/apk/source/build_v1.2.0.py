"""Build NBA2K20 mod v1.2.0 (test): team practice choice + equipment unlock, on top of v1.1.0."""
import copy, struct, sys, zipfile, json
json_fix = json.loads(sys.argv[4]) if len(sys.argv) > 4 else {}   # e.g. {"C": 1250295808}
BASE, OUT, ICONS = sys.argv[1], sys.argv[2], sys.argv[3]   # ICONS: rotate (diagnostic) | fix
HERE = __import__('os').path.dirname(__import__('os').path.abspath(__file__))
LIB = 'lib/arm64-v8a/libnba2k20_clean_opt.so'
CAVE = 0x1755400            # dead tail of CareerMode_Badges_UpdateAvailability (entry reused by v0.4 badges)
TARGETS = {'dialog_yesno':0xb67b30,'rich_presence':0xb83970,'drills_status':0xb68ac0,'drills_setmode':0xbc9130,
           'drills_allai':0xb905a0,'set_start_type':0xbb8250,'import_schedule':0xb69c20,'set_autoload':0xb61d20,
           'autosave':0xbbb5d0,'abort_pending':0xb80ad0,'roster_player':0xbc8260,'run_single_drill':0xbaab10,
           'shootaround_resume':0x199f380, 'decrypt_resume':0x19fe968}
PRICES = 0x1755500          # after the practice routine
# Store menu animation tiles: (movz/movn, movk) addresses loading each category's icon texture into w3
ICON_SITES = {'A':(0x19e3a80,0x19e3a90),'B':(0x19e3acc,0x19e3adc),'C':(0x19e3af0,0x19e3b00),'D':(0x19e3b14,0x19e3b24),'E':(0x19e3b38,0x19e3b48)}
ICON_TEX = {'A':0xa3e5c325,'B':0xd4e2f3b3,'C':0x3d815686,'D':0x4a866610,'E':0xd38f37aa}
def load_w3(v):
    return struct.pack('<II', 0x52800000 | ((v & 0xffff) << 5) | 3, 0x72a00000 | ((v >> 16) << 5) | 3)

def off(b, a):
    h = struct.unpack_from('<16sHHIQQQIHHHHHH', b)
    for i in range(h[10]):
        k, f, p, va, pa, sz, ms, al = struct.unpack_from('<IIQQQQQQ', b, h[5]+i*h[9])
        if k == 1 and va <= a < va+sz: return p+a-va
    raise ValueError(hex(a))

def branch(at, target, call=False):
    delta = target-at
    assert delta % 4 == 0 and -(1 << 27) <= delta < (1 << 27)
    return struct.pack('<I', (0x94000000 if call else 0x14000000) | ((delta//4) & 0x3ffffff))

def routine(path, name, base):
    b = open(path, 'rb').read(); h = struct.unpack_from('<16sHHIQQQIHHHHHH', b)
    ss = [struct.unpack_from('<IIQQQQIIQQ', b, h[6]+i*h[11]) for i in range(h[12])]
    names = b[ss[h[13]][4]:]; s = lambda d, i: d[i:d.index(0, i)].decode()
    sec = {s(names, x[0]): x for x in ss}
    st = ss[sec['.symtab'][6]]; strs = b[st[4]:st[4]+st[5]]
    syms = [struct.unpack_from('<IBBHQQ', b, p) for p in range(sec['.symtab'][4], sec['.symtab'][4]+sec['.symtab'][5], 24)]
    syms = [(s(strs, n), v, sz) for n, i, o, x, v, sz in syms]
    _, start, size = next(x for x in syms if x[0] == name)
    text = sec['.text']; code = bytearray(b[text[4]+start:text[4]+start+size])
    rel = sec['.rela.text']
    for p in range(rel[4], rel[4]+rel[5], 24):
        at, info, add = struct.unpack_from('<QQq', b, p)
        kind = info & 0xffffffff; assert kind in (282, 283), kind
        code[at-start:at-start+4] = branch(base+at-start, TARGETS[syms[info >> 32][0]]+add, kind == 283)
    return bytes(code)

with zipfile.ZipFile(BASE) as z:
    lib = z.read(LIB); infos = z.infolist(); data = {i.filename: z.read(i.filename) for i in infos}
new = bytearray(lib)
def put(va, payload, expect=None):
    p = off(lib, va)
    if expect is not None: assert lib[p:p+len(expect)] == expect, f'unexpected original at {va:#x}'
    new[p:p+len(payload)] = payload

code = routine(HERE+'/team_practice.o', 'practice_choice', CAVE)
assert CAVE + len(code) <= PRICES
put(CAVE, code, lib[off(lib, CAVE):off(lib, CAVE)+len(code)])
pcode = routine(HERE+'/store_prices.o', 'decrypt_hook', PRICES)
assert PRICES + len(pcode) <= 0x17559dc   # end of the dead UpdateAvailability body
put(PRICES, pcode, lib[off(lib, PRICES):off(lib, PRICES)+len(pcode)])
put(0x19fe964, branch(0x19fe964, PRICES), bytes.fromhex('fd7b44a9'))        # ITEM::Decrypt epilogue ldp x29,x30 -> price fix
def tex_at(lo_hi):
    a, b2 = (struct.unpack_from('<I', lib, off(lib, x))[0] for x in lo_hi)
    hi = (~(a >> 5) & 0xffff) if (a & 0x7f800000) == 0x12800000 else ((a >> 5) & 0xffff)   # movn or movz, lsl #16
    return (hi << 16) | ((b2 >> 5) & 0xffff)
for k, s in ICON_SITES.items(): assert tex_at(s) == ICON_TEX[k], (k, hex(tex_at(s)))
order = 'ABCDE'
ICON_MAP = {k: ICON_TEX[order[(i+1) % 5]] for i, k in enumerate(order)} if ICONS == 'rotate' else dict(ICON_TEX, **json_fix)
for k, (s1, s2) in ICON_SITES.items():
    if ICON_MAP[k] != ICON_TEX[k]:
        put(s1, load_w3(ICON_MAP[k])[:4]); put(s2, load_w3(ICON_MAP[k])[4:])
put(0x199f37c, branch(0x199f37c, CAVE), bytes.fromhex('f44fbea9'))          # 2K NAV Practice > Shoot Around
put(0x19ede08, bytes.fromhex('e0031f2a'), bytes.fromhex('3a09c697'))         # ValidateRequirement -> 0: LOCKED becomes AVAILABLE
# self-check: only the three intended ranges changed
changed = [i for i in range(len(lib)) if lib[i] != new[i]]
allowed = set(range(off(lib, CAVE), off(lib, CAVE)+len(code))) | set(range(off(lib, PRICES), off(lib, PRICES)+len(pcode)))
for va in [0x199f37c, 0x19ede08, 0x19fe964] + [x for s in ICON_SITES.values() for x in s]: allowed |= set(range(off(lib, va), off(lib, va)+4))
assert changed and set(changed) <= allowed
with zipfile.ZipFile(OUT, 'w') as d:
    for i in infos:
        if i.filename.startswith('META-INF/'): continue
        d.writestr(copy.copy(i), bytes(new) if i.filename == LIB else data[i.filename])
with zipfile.ZipFile(OUT) as z:
    assert z.testzip() is None and z.read(LIB) == bytes(new)
    for n in data:
        if not n.startswith('META-INF/') and n != LIB: assert z.read(n) == data[n]
print('built', OUT, 'practice', len(code), 'prices', len(pcode), 'changed bytes', len(changed), 'icons', ICONS)
