python
# set disassembly­flavor intel
# set disassemble­next-line on
import os
gdb.execute('set disassembly intel')
gdb.execute('add-auto-load-safe-path /mnt/lmde/home/dcluna/code/emacs/src/.gdbinit')
if os.environ.get('INSIDE_EMACS') is None:
  gdb.execute('source %s' % '/mnt/lmde/home/dcluna/code/pwndbg/gdbinit.py')
end
