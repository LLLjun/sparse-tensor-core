# README

## src

### 代码层级

- core
  - dn_benes
    - dn_router
  - dp_group
    - dp_unit
  - fan_tree
    - fan_adder
      - reduction_mux

### core

实现了Sparse Tensor Core的部分功能，目前已实现：

- 输入

  - 输入稀疏矩阵A（非零元素连续存储），输入列向量B

  - 输入分发网络的控制信号（每个router的输入输出对应关系，2bit）

  - 输入规约网络的控制信号
    - 每个adder的模式控制信号，bypass or add，2bit
    - 每个adder的输入选择信号，根据网络规模而增大，目前设置为每adder 6bit
    - 每个输入的edge信号，用来判断什么时候规约结束进行输出，每个输入2bit

- 输出
  - 每个adder对应的2股bus（考虑到极端情况，其实大部分情况一根就够用）
  - 每个busline都有一个对应的valid信号

### dn_benes

benes分发网络的实现，可以支持多播，但是不确定是否能满足所有情况，可以在研究控制算法的时候证明一下数学上的正确性。

## sim

### tb_core

测试用例说明

- N=8，即运算单元个数为8
- TILE_K=4
- 稀疏矩阵A为一个3*4的稀疏矩阵，col_index = [0,2,0,1,2,0,1,3]，row_index=[0,2,5,8],value=[0,1,2,3,4,5,6,7]
- 列向量B为[1,2,3,4]^T
- benes控制信号为手动生成
- fan控制信号为python生成，代码未整理

运算过程

* 先通过benes分发A，结果应该为[7,6,5,4,3,2,1,0]
* 再通过benes分发B，结果应该为[4,2,1,3,2,1,3,1]
* dp_group计算对应元素的乘积，结果应该为[28,12,5,12,6,2,3,0]
* fan进行规约，结果应该为[45,20,3]，可对照out_valid信号进行查找

## RoadMap

* 进行向量扩展
* fan控制信号模块
* benes控制信号模块（很难）