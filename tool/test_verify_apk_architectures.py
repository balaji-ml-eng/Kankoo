import tempfile
import unittest
import zipfile
from pathlib import Path

from verify_apk_architectures import verify


class ApkArchitectureTest(unittest.TestCase):
    def apk(self, names):
        directory = tempfile.TemporaryDirectory()
        self.addCleanup(directory.cleanup)
        path = Path(directory.name) / 'fixture.apk'
        with zipfile.ZipFile(path, 'w') as archive:
            for name in names:
                archive.writestr(name, b'test')
        return path

    def test_aot_requires_app_for_every_advertised_abi(self):
        names = [f'lib/arm64-v8a/{lib}' for lib in ('libflutter.so', 'libapp.so', 'libsqlcipher.so')]
        verify(self.apk(names))
        with self.assertRaisesRegex(ValueError, 'x86_64: missing'):
            verify(self.apk(names + ['lib/x86_64/libsqlcipher.so']))

    def test_debug_requires_kernel_and_cipher_but_not_aot(self):
        names = ['lib/x86_64/libflutter.so', 'lib/x86_64/libsqlcipher.so', 'assets/flutter_assets/kernel_blob.bin']
        verify(self.apk(names), debug=True)
        with self.assertRaisesRegex(ValueError, 'kernel snapshot'):
            verify(self.apk(names[:-1]), debug=True)
        with self.assertRaisesRegex(ValueError, 'libsqlcipher.so'):
            verify(self.apk([names[0], names[2]]), debug=True)
        with self.assertRaisesRegex(ValueError, 'libapp.so'):
            verify(self.apk(names))


if __name__ == '__main__':
    unittest.main()
