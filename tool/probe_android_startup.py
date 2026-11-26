"""Run only on a disposable emulator; capture the exact APK's startup evidence."""
import json
from pathlib import Path
import subprocess
import sys
import time


def adb(*args, binary=False, check=True):
    return subprocess.run(['adb', *args], capture_output=True, text=not binary, check=check, timeout=45).stdout


assert adb('get-serialno').strip().startswith('emulator-'), 'Use a disposable Android emulator only'
out = Path('runtime-probe')
out.mkdir(exist_ok=True)
adb('install', '-r', sys.argv[1])
adb('logcat', '-c')
start = adb('shell', 'am', 'start', '-W', '-n', 'com.kankoo.kankoo/.MainActivity', check=False)
(out / 'launch.txt').write_text(start)
texts = {}
for label, delay in [('early', 5), ('later', 20)]:
    time.sleep(delay)
    (out / (label + '.png')).write_bytes(adb('exec-out', 'screencap', '-p', binary=True))
    adb('shell', 'uiautomator', 'dump', '/sdcard/kankoo-startup.xml', check=False)
    texts[label] = adb('shell', 'cat', '/sdcard/kankoo-startup.xml', check=False)
    (out / (label + '.xml')).write_text(texts[label])
logs = adb('logcat', '-d', '-v', 'threadtime')
(out / 'logcat.txt').write_text(logs)
(out / 'activity.txt').write_text(adb('shell', 'dumpsys', 'activity', 'activities'))
summary = {'api': adb('shell', 'getprop', 'ro.build.version.sdk').strip(),
           'processAlive': bool(adb('shell', 'pidof', 'com.kankoo.kankoo', check=False).strip()),
           'dartEntry': '[kankoo-startup] Dart entry reached' in logs,
           'firstFrame': '[kankoo-startup] first frame painted' in logs,
           'preferencesReady': '[kankoo-startup] saved settings ready' in logs}
(out / 'summary.json').write_text(json.dumps(summary, indent=2))
print(json.dumps(summary, indent=2))
for line in logs.splitlines():
    if any(marker in line for marker in ['kankoo-startup', 'FATAL EXCEPTION', 'E/flutter', 'dlopen failed', 'UnsatisfiedLinkError', 'Impeller', 'Could not load', 'Dart Error']):
        print(line[:1000])
keys = ['kankoo-startup', 'FATAL EXCEPTION', 'E/flutter', 'PlatformException', 'channel-error', 'Error registering plugin', 'GeneratedPluginRegistrant', 'shared_preferences', 'datastore', 'ClassNotFound', 'NoSuchMethod', 'AndroidRuntime']
picked = [l[:400] for l in logs.splitlines() if any(k in l for k in keys)][:60]
msg = '%0A'.join(x.replace('%', '%25') for x in picked)
print('::error title=startup-log-api' + summary['api'] + '::' + msg[:6000])
print('::error title=summary-api' + summary['api'] + '::' + json.dumps(summary))
assert summary['processAlive'] and summary['firstFrame'], 'Published APK did not reach its first Flutter frame; inspect logs and screenshots'
