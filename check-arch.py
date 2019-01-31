#!/usr/bin/env python

import os
import struct
import sys

def arch_of(dll_file):
    with open(dll_file, 'rb') as f:
        doshdr = f.read(64)
        magic, padding, offset = struct.unpack('2s58si', doshdr)
        if magic != b'MZ':
            return None
        f.seek(offset, os.SEEK_SET)
        pehdr = f.read(6)
        magic, padding, machine = struct.unpack('2s2sH', pehdr) 
        if magic != b'PE':
            return None
        if machine == 0x014c:
            return 'i386'
        if machine == 0x0200:
            return 'IA64'
        if machine == 0x8664:
            return 'x64'
        return 'unknown'

if __name__ == '__main__':
	print(arch_of(sys.argv[1]))