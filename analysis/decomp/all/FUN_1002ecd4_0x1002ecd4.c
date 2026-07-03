
undefined4
FUN_1002ecd4(undefined4 param_1,short param_2,undefined4 *param_3,undefined2 param_4,byte *param_5,
            byte *param_6)

{
  int *piVar1;
  undefined4 uVar2;
  undefined2 uStack00000026;
  short local_28 [6];
  
  if (((short)param_1 == -1) ||
     (((param_2 != 1 && (param_2 != 2)) || (param_3 == (undefined4 *)0x0)))) {
    uVar2 = 0xffffffce;
  }
  else {
    uStack00000026 = param_4;
    piVar1 = (int *).glue::NewHandleClear(0x206);
    if (piVar1 == (int *)0x0) {
      uVar2 = .glue::MemError();
    }
    else {
      *(undefined4 *)*piVar1 = *param_3;
      *(undefined2 *)(*piVar1 + 4) = uStack00000026;
      local_28[0] = param_2;
      .glue::BlockMoveData(param_5,*piVar1 + 6,*param_5 + 1);
      .glue::BlockMoveData(param_6,(uint)*param_5 + *piVar1 + 7,*param_6 + 1);
      uVar2 = FUN_1002ef44(param_1,0x76657273,local_28,piVar1);
    }
  }
  return uVar2;
}

