#!/usr/bin/env python3
"""Maximize/restore exactly one visible title-bar window with a single toggle."""
import fcntl,json,os,pathlib,subprocess,sys,time
root=pathlib.Path(__file__).resolve().parent
lock=open(pathlib.Path(os.environ.get('XDG_RUNTIME_DIR','/tmp'))/'hypr-maximize-button.lock','a+')
try:fcntl.flock(lock,fcntl.LOCK_EX|fcntl.LOCK_NB)
except BlockingIOError:sys.exit(0)
address=sys.argv[1] if len(sys.argv)>1 else subprocess.check_output([str(root/'_ventana-cursor.sh')],text=True).strip()
if not address.startswith('0x') or any(c not in '0123456789abcdefABCDEF' for c in address[2:]):sys.exit(1)
def current():
    return next((w for w in json.loads(subprocess.check_output(['hyprctl','clients','-j'],text=True)) if w['address']==address),None)
def dispatch(expression):
    result=subprocess.run(['hyprctl','dispatch',expression],capture_output=True,text=True,check=True)
    if 'error' in result.stdout.lower():raise RuntimeError(result.stdout)
w=current()
if not w:sys.exit(1)
expected=0 if w.get('fullscreen',0)==1 else 1
selector=json.dumps('address:'+address)
dispatch('hl.dsp.focus({window = '+selector+'})')
active=json.loads(subprocess.check_output(['hyprctl','activewindow','-j'],text=True))
if active.get('address')!=address:sys.exit('No se pudo enfocar la ventana; no se maximiza otra.')
dispatch('hl.dsp.window.fullscreen({window = '+selector+', mode = "maximized", action = "toggle"})')
for _ in range(15):
    w=current()
    if w and w.get('fullscreen',0)==expected:sys.exit(0)
    time.sleep(0.06)
sys.exit('Hyprland no confirmo el cambio de maximizado.')
