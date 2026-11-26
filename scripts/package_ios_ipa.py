"""Package the unsigned device build for re-signing by an iPhone sideload tool."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import plistlib
import stat
import struct
import zipfile


def verify(ipa):
    with zipfile.ZipFile(ipa) as archive:
        names = archive.namelist()
        prefix = 'Payload/Runner.app/'
        assert names and len(names) == len(set(names)), 'Empty or duplicate IPA entries'
        assert all(n.startswith(prefix) and '..' not in Path(n).parts for n in names), 'Invalid Payload layout'
        info = plistlib.loads(archive.read(prefix + 'Info.plist'))
        assert info['CFBundleIdentifier'] == 'com.kankoo.kankoo'
        assert info['MinimumOSVersion'] == '17.0'
        assert info['DTPlatformName'] == 'iphoneos' and info['CFBundleSupportedPlatforms'] == ['iPhoneOS'], 'Simulator builds cannot be installed on an iPhone'
        binary = archive.read(prefix + info['CFBundleExecutable'])
        assert struct.unpack('<II', binary[:8]) == (0xfeedfacf, 0x100000c), 'Expected arm64 device build'
        assert b'ForwardBankMessageIntent' in archive.read(prefix + 'Metadata.appintents/extract.actionsdata')
        assert archive.getinfo(prefix + 'Frameworks/sqlcipher.framework/sqlcipher').file_size > 0
        assert archive.getinfo(prefix + 'Frameworks/App.framework/App').file_size > 0
        assert prefix + 'embedded.mobileprovision' not in names, 'Expected unsigned package for user re-signing'
        assert archive.testzip() is None, 'IPA CRC verification failed'
    with Path(ipa).open('rb') as package_file:
        digest = hashlib.file_digest(package_file, 'sha256').hexdigest()
    return {'bundle': info['CFBundleIdentifier'], 'version': info['CFBundleShortVersionString'],
            'build': info['CFBundleVersion'], 'minimumIOS': info['MinimumOSVersion'],
            'architecture': 'arm64', 'requiresSigning': True,
            'sha256': digest}


def package(app, output):
    app, output = Path(app).resolve(), Path(output).resolve()
    assert app.name == 'Runner.app' and app.is_dir(), 'Supply the device Runner.app directory'
    assert not output.is_relative_to(app), 'Output must be outside the app bundle'
    assert not output.exists(), 'Choose a new output path rather than overwrite an existing IPA'
    output.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(output, 'x', compression=zipfile.ZIP_DEFLATED) as archive:
        for path in sorted(app.rglob('*')):
            name = 'Payload/Runner.app/' + path.relative_to(app).as_posix()
            if path.is_symlink():
                entry = zipfile.ZipInfo(name)
                entry.create_system = 3
                entry.external_attr = (stat.S_IFLNK | 0o777) << 16
                archive.writestr(entry, os.readlink(path))
            elif path.is_file():
                archive.write(path, name)
    return verify(output)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('app', type=Path)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    metadata = package(args.app, args.output)
    args.output.with_suffix('.ipa.sha256').write_text(metadata['sha256'] + '  ' + args.output.name + '\n', encoding='utf-8')
    print(json.dumps(metadata, indent=2))
