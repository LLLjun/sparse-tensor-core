import os
import numpy as np

def main():
  path_root = '../test_file/mm_adder'
  os.makedirs(path_root, exist_ok=True)
  path_A = os.path.join(path_root, 'matrix_a.txt')
  path_B = os.path.join(path_root, 'matrix_b.txt')
  path_S = os.path.join(path_root, 'matrix_s.txt')

  m = 4
  n = 4
  A = np.random.randint(-128, 128, (m, n))
  B = np.random.randint(-128, 128, (m, n))
  S = A + B

  print(A)
  print(B)
  print(S)

  A.tofile(path_A, sep='\n', format='%d')
  B.tofile(path_B, sep='\n', format='%d')
  S.tofile(path_S, sep='\n', format='%d')

if __name__ == '__main__':
  main()
