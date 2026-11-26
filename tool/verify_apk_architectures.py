"""Reject Kankoo APKs that advertise an ABI without its core native libraries."""
import sys
import zipfile


def verify(path):
    with zipfile.ZipFile(path) as apk:
        names = set(apk.namelist())
    abis = sorted({name.split('/')[1] for name in names
                   if name.startswith('lib/') and name.endswith('.so')})
    if not abis:
        raise ValueError('No Android native libraries found')
    errors = []
    for abi in abis:
        missing = [lib for lib in ('libflutter.so', 'libapp.so', 'libsqlcipher.so')
                   if f'lib/{abi}/{lib}' not in names]
        if missing:
            errors.append(f'{abi}: missing {", ".join(missing)}')
        else:
            print(f'{abi}: Flutter engine, app and SQLCipher present')
    if errors:
        raise ValueError('\n'.join(errors))


if __name__ == '__main__':
    try:
        verify(sys.argv[1])
    except (ValueError, IndexError, OSError, zipfile.BadZipFile) as error:
        print(f'APK architecture validation failed: {error}', file=sys.stderr)
        sys.exit(1)
