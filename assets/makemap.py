import numpy as np

FULLW = 256 // 8
WIDTH = 224 // 8
HEIGHT = 192 // 8
h = HEIGHT

np.set_printoptions(linewidth=180, threshold=2000)

full_screen = np.full([FULLW, FULLW], 0x2ff)

raw_data = []

for i in range(HEIGHT):
  for k in range(WIDTH):
    raw_data.append(h * k + i)

data = np.array(raw_data).reshape(-1, WIDTH)

edge_coordinates = (2,2)
slicer = tuple(slice(edge, edge+i) for edge, i in zip(edge_coordinates, data.shape))
full_screen[slicer] = data

print(full_screen)

import struct

flattened = list(full_screen.ravel().astype(int))

tilemap = []
for i in flattened:
  print(i)
  lsb, msb = struct.pack('<H', i)

  tilemap.append(lsb)
  tilemap.append(msb)

with open('bg1.map', 'wb') as out_file:
    out_file.write(bytearray(tilemap))
