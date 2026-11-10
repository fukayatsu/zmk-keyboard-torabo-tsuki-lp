for p in projL projR; do openscad -D "part=\"$p\"" -D "x_off=$1" -o $p.svg lap_kit.scad 2>&1 | grep -i -E 'error'; done
python3 -I - <<'PY'
import re,math
def pts(f):
    s=open(f).read(); out=[]
    for d in re.findall(r'd="([^"]+)"',s):
        out+= [(float(a),-float(b)) for a,b in re.findall(r'(-?[\d.]+),(-?[\d.]+)',d)]
    return out
L=pts('projL.svg'); R=pts('projR.svg')
Lc=[p for p in L if p[0]>-25]; Rc=[p for p in R if p[0]<25]
best=min(((math.dist(a,b),a,b) for a in Lc for b in Rc))
print('min gap %.2f at'%best[0], best[1], best[2])
PY
