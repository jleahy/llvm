; RUN: llc -march=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GCN %s

; GCN-LABEL: {{^}}sel_constants_sub_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, 2, 9,
define amdgpu_kernel void @sel_constants_sub_constant_sel_constants(i32 addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, i32 -4, i32 3
  %bo = sub i32 5, %sel
  store i32 %bo, i32 addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}sel_constants_sub_constant_sel_constants_i16:
; TODO: shrink i16 constant. This is correct but suboptimal.
; GCN: v_mov_b32_e32 [[T:v[0-9]+]], 0xffff0009
; GCN: v_cndmask_b32_e32 v{{[0-9]+}}, 2, [[T]],
define amdgpu_kernel void @sel_constants_sub_constant_sel_constants_i16(i16 addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, i16 -4, i16 3
  %bo = sub i16 5, %sel
  store i16 %bo, i16 addrspace(1)* %p, align 2
  ret void
}

; GCN-LABEL: {{^}}sel_constants_sub_constant_sel_constants_i16_neg:
; GCN: v_mov_b32_e32 [[F:v[0-9]+]], 0xfffff449
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, [[F]], -3,
define amdgpu_kernel void @sel_constants_sub_constant_sel_constants_i16_neg(i16 addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, i16 4, i16 3000
  %bo = sub i16 1, %sel
  store i16 %bo, i16 addrspace(1)* %p, align 2
  ret void
}

; GCN-LABEL: {{^}}sel_constants_sub_constant_sel_constants_v2i16:
; GCN-DAG: v_mov_b32_e32 [[F:v[0-9]+]], 0x60002
; GCN-DAG: v_mov_b32_e32 [[T:v[0-9]+]], 0x50009
; GCN:     v_cndmask_b32_e32 v{{[0-9]+}}, [[F]], [[T]],
define amdgpu_kernel void @sel_constants_sub_constant_sel_constants_v2i16(<2 x i16> addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, <2 x i16> <i16 -4, i16 2>, <2 x i16> <i16 3, i16 1>
  %bo = sub <2 x i16> <i16 5, i16 7>, %sel
  store <2 x i16> %bo, <2 x i16> addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}sel_constants_sub_constant_sel_constants_v4i32:
; GCN-DAG: v_cndmask_b32_e64 v{{[0-9]+}}, 2, 9,
; GCN-DAG: v_cndmask_b32_e64 v{{[0-9]+}}, 6, 5,
; GCN-DAG: v_cndmask_b32_e64 v{{[0-9]+}}, 10, 6,
; GCN-DAG: v_cndmask_b32_e64 v{{[0-9]+}}, 14, 7,
define amdgpu_kernel void @sel_constants_sub_constant_sel_constants_v4i32(<4 x i32> addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, <4 x i32> <i32 -4, i32 2, i32 3, i32 4>, <4 x i32> <i32 3, i32 1, i32 -1, i32 -3>
  %bo = sub <4 x i32> <i32 5, i32 7, i32 9, i32 11>, %sel
  store <4 x i32> %bo, <4 x i32> addrspace(1)* %p, align 32
  ret void
}

; GCN-LABEL: {{^}}sdiv_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, 5, 0,
define amdgpu_kernel void @sdiv_constant_sel_constants(i32 addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, i32 121, i32 23
  %bo = sdiv i32 120, %sel
  store i32 %bo, i32 addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}udiv_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, 5, 0,
define amdgpu_kernel void @udiv_constant_sel_constants(i32 addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, i32 -4, i32 23
  %bo = udiv i32 120, %sel
  store i32 %bo, i32 addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}srem_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, 3, 33,
define amdgpu_kernel void @srem_constant_sel_constants(i32 addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, i32 34, i32 15
  %bo = srem i32 33, %sel
  store i32 %bo, i32 addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}urem_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, 3, 33,
define amdgpu_kernel void @urem_constant_sel_constants(i32 addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, i32 34, i32 15
  %bo = urem i32 33, %sel
  store i32 %bo, i32 addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}shl_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, 8, 4,
define amdgpu_kernel void @shl_constant_sel_constants(i32 addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, i32 2, i32 3
  %bo = shl i32 1, %sel
  store i32 %bo, i32 addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}lshr_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, 8, 16,
define amdgpu_kernel void @lshr_constant_sel_constants(i32 addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, i32 2, i32 3
  %bo = lshr i32 64, %sel
  store i32 %bo, i32 addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}ashr_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, 16, 32,
define amdgpu_kernel void @ashr_constant_sel_constants(i32 addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, i32 2, i32 3
  %bo = ashr i32 128, %sel
  store i32 %bo, i32 addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}fsub_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, -4.0, 1.0,
define amdgpu_kernel void @fsub_constant_sel_constants(float addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, float -2.0, float 3.0
  %bo = fsub float -1.0, %sel
  store float %bo, float addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}fsub_constant_sel_constants_f16:
; TODO: it shall be possible to fold constants with OpSel
; GCN-DAG: v_mov_b32_e32 [[T:v[0-9]+]], 0x3c00
; GCN-DAG: v_mov_b32_e32 [[F:v[0-9]+]], 0xc400
; GCN:     v_cndmask_b32_e32 v{{[0-9]+}}, [[F]], [[T]],
define amdgpu_kernel void @fsub_constant_sel_constants_f16(half addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, half -2.0, half 3.0
  %bo = fsub half -1.0, %sel
  store half %bo, half addrspace(1)* %p, align 2
  ret void
}

; GCN-LABEL: {{^}}fsub_constant_sel_constants_v2f16:
; GCN-DAG: v_mov_b32_e32 [[T:v[0-9]+]], 0x45003c00
; GCN:     v_cndmask_b32_e32 v{{[0-9]+}}, -2.0, [[T]],
define amdgpu_kernel void @fsub_constant_sel_constants_v2f16(<2 x half> addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, <2 x half> <half -2.0, half -3.0>, <2 x half> <half -1.0, half 4.0>
  %bo = fsub <2 x half> <half -1.0, half 2.0>, %sel
  store <2 x half> %bo, <2 x half> addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}fsub_constant_sel_constants_v4f32:
; GCN-DAG: v_mov_b32_e32 [[T2:v[0-9]+]], 0x40a00000
; GCN-DAG: v_mov_b32_e32 [[T3:v[0-9]+]], 0x41100000
; GCN-DAG: v_mov_b32_e32 [[T4:v[0-9]+]], 0x41500000
; GCN-DAG: v_mov_b32_e32 [[F4:v[0-9]+]], 0x40c00000
; GCN-DAG: v_cndmask_b32_e64 v{{[0-9]+}}, 0, 1.0,
; GCN-DAG: v_cndmask_b32_e32 v{{[0-9]+}}, 2.0, [[T2]],
; GCN-DAG: v_cndmask_b32_e32 v{{[0-9]+}}, 4.0, [[T3]],
; GCN-DAG: v_cndmask_b32_e32 v{{[0-9]+}}, [[F4]], [[T4]],
define amdgpu_kernel void @fsub_constant_sel_constants_v4f32(<4 x float> addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, <4 x float> <float -2.0, float -3.0, float -4.0, float -5.0>, <4 x float> <float -1.0, float 0.0, float 1.0, float 2.0>
  %bo = fsub <4 x float> <float -1.0, float 2.0, float 5.0, float 8.0>, %sel
  store <4 x float> %bo, <4 x float> addrspace(1)* %p, align 32
  ret void
}

; GCN-LABEL: {{^}}fdiv_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, 4.0, -2.0,
define amdgpu_kernel void @fdiv_constant_sel_constants(float addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, float -4.0, float 2.0
  %bo = fdiv float 8.0, %sel
  store float %bo, float addrspace(1)* %p, align 4
  ret void
}

; GCN-LABEL: {{^}}frem_constant_sel_constants:
; GCN: v_cndmask_b32_e64 v{{[0-9]+}}, 2.0, 1.0,
define amdgpu_kernel void @frem_constant_sel_constants(float addrspace(1)* %p, i1 %cond) {
  %sel = select i1 %cond, float -4.0, float 3.0
  %bo = frem float 5.0, %sel
  store float %bo, float addrspace(1)* %p, align 4
  ret void
}
