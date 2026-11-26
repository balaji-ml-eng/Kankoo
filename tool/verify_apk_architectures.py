"""Reject Kankoo APKs that advertise an ABI without its core native libraries."""
import sys
import zipfile


def verify(path, debug=False):
    with zipfile.ZipFile(path) as apk:
        names = set(apk.namelist())
    abis = sorted({name.split('/')[1] for name in names
                   if name.startswith('lib/') and name.endswith('.so')})
    if not abis:
        raise ValueError('No Android native libraries found')
    errors = []
    if debug and 'assets/flutter_assets/kernel_blob.bin' not in names:
        errors.append('Debug APK is missing its Dart kernel snapshot')
    for abi in abis:
        required = ('libflutter.so', 'libsqlcipher.so') if debug else ('libflutter.so', 'libapp.so', 'libsqlcipher.so')
        missing = [lib for lib in required
                   if f'lib/{abi}/{lib}' not in names]
        if missing:
            errors.append(f'{abi}: missing {", ".join(missing)}')
        else:
            print(f'{abi}: Flutter engine, {"JIT kernel" if debug else "AOT app"} and SQLCipher present')
    if errors:
        raise ValueError('\n'.join(errors))


if __name__ == '__main__':
    try:
        verify(sys.argv[1], debug='--debug' in sys.argv[2:])
    except (ValueError, IndexError, OSError, zipfile.BadZipFile) as error:
        print(f'APK architecture validation failed: {error}', file=sys.stderr)
        sys.exit(1)
