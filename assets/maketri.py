import struct

class Vec3:
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z

    def pack(self):
        return struct.pack('<hhh', self.x, self.y, self.z)

class Tri:
    def __init__(self, a, b, c):
        self.a = a
        self.b = b
        self.c = c

    def pack(self):
        return self.a.pack() + self.b.pack() + self.c.pack()

if __name__ == '__main__':
    v1 = Vec3(44, 128, 100)
    v2 = Vec3(104, 28, 100)
    v3 = Vec3(156, 87, 100)

    tri = Tri(v1, v2, v3)

    with open('triangle.bin', 'wb') as f:
        f.write(tri.pack())
