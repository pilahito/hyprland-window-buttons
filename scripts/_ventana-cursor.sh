#!/usr/bin/env python3
"""Select a visible window under the title-bar cursor, excluding hidden workspaces."""
import json,subprocess,sys

def read(*args):return json.loads(subprocess.check_output(['hyprctl',*args],text=True))
def select_window(windows,monitors,x,y):
    monitor=next((m for m in monitors if m['x']<=x<m['x']+m['width']/m.get('scale',1) and m['y']<=y<m['y']+m['height']/m.get('scale',1)),None)
    if not monitor:return None
    special=monitor.get('specialWorkspace',{}).get('name','')
    visible={monitor.get('activeWorkspace',{}).get('name','')}
    if special:visible.add(special)
    candidates=[w for w in windows if w.get('mapped',True) and not w.get('hidden',False) and w.get('monitor')==monitor['id'] and w.get('workspace',{}).get('name') in visible]
    for title_only in (True,False):
        hits=[]
        for w in candidates:
            wx,wy=w['at'];width,height=w['size']
            if wx-4<=x<=wx+width+4 and (wy-42<=y<=wy+8 if title_only else wy-42<=y<=wy+height):hits.append(w)
        if hits:return min(hits,key=lambda w:(w['workspace']['name']!=special,w.get('focusHistoryID',9999)))['address']
    return None
if __name__=='__main__':
    pos=read('cursorpos','-j'); address=select_window(read('clients','-j'),read('monitors','-j'),pos['x'],pos['y'])
    if not address:sys.exit(1)
    print(address)
