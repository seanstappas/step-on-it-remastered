
undefined4 FUN_10000d90(short param_1,short *param_2,int *param_3,ushort param_4,int *param_5)

{
  undefined4 uVar1;
  int iVar2;
  undefined4 uVar3;
  int *piStack00000020;
  int *local_28 [4];
  
  local_28[0] = (int *)0x0;
  piStack00000020 = param_3;
  if (param_1 < 9) {
    local_28[0] = param_3;
    uVar1 = .glue::HandToHand(local_28);
  }
  else {
    local_28[0] = (int *).glue::NewHandle(8);
    uVar1 = .glue::MemError();
  }
  if ((short)uVar1 == 0) {
    iVar2 = .glue::NewPtr(((int)param_2[2] - (int)*param_2) * (int)(short)param_4);
    if (iVar2 == 0) {
      uVar1 = .glue::MemError();
    }
    else {
      *(int *)*param_5 = iVar2;
      *(ushort *)(*param_5 + 4) = param_4 | 0x8000;
      iVar2 = *param_5;
      uVar3 = *(undefined4 *)(param_2 + 2);
      *(undefined4 *)(iVar2 + 6) = *(undefined4 *)param_2;
      *(undefined4 *)(iVar2 + 10) = uVar3;
      *(undefined2 *)(*param_5 + 0xe) = 0;
      *(undefined2 *)(*param_5 + 0x10) = 0;
      *(undefined4 *)(*param_5 + 0x12) = 0;
      *(undefined4 *)(*param_5 + 0x16) = 0x480000;
      *(undefined4 *)(*param_5 + 0x1a) = 0x480000;
      *(short *)(*param_5 + 0x20) = param_1;
      *(undefined4 *)(*param_5 + 0x26) = 0;
      *(undefined4 *)(*param_5 + 0x2e) = 0;
      if (param_1 < 9) {
        *(undefined2 *)(*param_5 + 0x1e) = 0;
        *(undefined2 *)(*param_5 + 0x22) = 1;
        *(short *)(*param_5 + 0x24) = param_1;
        *(int **)(*param_5 + 0x2a) = local_28[0];
      }
      else {
        *(undefined2 *)(*param_5 + 0x1e) = 0x10;
        *(undefined2 *)(*param_5 + 0x22) = 3;
        if (param_1 == 0x10) {
          *(undefined2 *)(*param_5 + 0x24) = 5;
        }
        else {
          *(undefined2 *)(*param_5 + 0x24) = 8;
        }
        *(int *)*local_28[0] = *(short *)(*param_5 + 0x24) * 3;
        *(undefined2 *)(*local_28[0] + 4) = 0;
        *(undefined2 *)(*local_28[0] + 6) = 0;
        *(int **)(*param_5 + 0x2a) = local_28[0];
      }
    }
  }
  else {
    local_28[0] = (int *)0x0;
  }
  if (((short)uVar1 != 0) && (local_28[0] != (int *)0x0)) {
    .glue::DisposeCTable(local_28[0]);
  }
  return uVar1;
}

