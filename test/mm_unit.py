import os
import numpy as np

def main():
  path_root = '../test_file/matrix_multiple'
  os.makedirs(path_root, exist_ok=True)
  path_A = os.path.join(path_root, 'matrix_a.txt')
  path_B = os.path.join(path_root, 'matrix_b.txt')
  path_S = os.path.join(path_root, 'matrix_s.txt')

  m = 16
  k = 16
  n = 16
  A = np.random.randint(-128, 128, (m, k))
  B = np.random.randint(-128, 128, (k, n))
  S = np.dot(A, B)
  BT = B.T

  print(A)
  print(B)
  print(S)

  A.tofile(path_A, sep='\n', format='%d')
  BT.tofile(path_B, sep='\n', format='%d')
  S.tofile(path_S, sep='\n', format='%d')

if __name__ == '__main__':
  main()
