
undefined4
FUN_1002eb80(undefined4 param_1,short param_2,undefined4 *param_3,undefined2 *param_4,byte *param_5,
            undefined4 param_6)

{
  undefined4 uVar1;
  undefined4 uStack0000002c;
  short local_28;
  int *local_26 [3];
  
  if ((((short)param_1 == -1) ||
      (((param_2 != 1 && (param_2 != 2)) || (param_3 == (undefined4 *)0x0)))) ||
     (param_4 == (undefined2 *)0x0)) {
    uVar1 = 0xffffffce;
  }
  else {
    uStack0000002c = param_6;
    local_28 = param_2;
    uVar1 = FUN_1002edf0(param_1,0x76657273,&local_28,local_26);
    if (((short)uVar1 == 0) && (local_26[0] != (int *)0x0)) {
      *param_3 = *(undefined4 *)*local_26[0];
      *param_4 = *(undefined2 *)(*local_26[0] + 4);
      .glue::BlockMoveData(*local_26[0] + 6,param_5,*(byte *)(*local_26[0] + 6) + 1);
      .glue::BlockMoveData
                ((uint)*param_5 + *local_26[0] + 7,uStack0000002c,
                 *(byte *)((uint)*param_5 + *local_26[0] + 7) + 1);
      .glue::DisposeHandle(local_26[0]);
      uVar1 = .glue::MemError();
    }
  }
  return uVar1;
}

