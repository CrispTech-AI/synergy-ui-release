"""
Shim for pyaudioop module which was removed in Python 3.13.
This provides minimal compatibility for pydub which tries to import it.
"""

import sys

class AudioopModule:
    """Minimal mock of audioop module for Python 3.13+"""
    def __getattr__(self, name):
        # Return dummy functions for any audio operations requested
        def dummy(*args, **kwargs):
            pass
        return dummy

# Install the shim before pydub tries to import it
sys.modules['pyaudioop'] = AudioopModule()
sys.modules['audioop'] = AudioopModule()
