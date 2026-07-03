
undefined4 FUN_10000fd8(int *param_1,undefined4 *param_2)

{
  int *piVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  int iVar4;
  undefined4 uVar5;
  int iVar6;
  undefined4 *puStack0000001c;
  
  uVar5 = 0;
  iVar6 = 0;
  puStack0000001c = param_2;
  piVar1 = (int *).glue::NewHandle(0x3e);
  if (piVar1 == (int *)0x0) {
    uVar5 = .glue::MemError();
  }
  else {
    iVar6 = .glue::NewHandleClear(2);
    if (iVar6 == 0) {
      uVar5 = .glue::MemError();
    }
    else {
      uVar2 = *(undefined4 *)(*param_1 + 6);
      uVar3 = *(undefined4 *)(*param_1 + 10);
      *(undefined2 *)*piVar1 = 0;
      *(undefined2 *)(*piVar1 + 2) = 0;
      if (*(short *)(*param_1 + 0x20) < 9) {
        *(undefined2 *)(*piVar1 + 4) = 0;
      }
      else {
        *(undefined2 *)(*piVar1 + 4) = 2;
      }
      *(int *)(*piVar1 + 6) = iVar6;
      *(undefined2 *)(*piVar1 + 10) = 4;
      *(undefined4 *)(*piVar1 + 0xc) = 0;
      *(undefined4 *)(*piVar1 + 0x10) = 0;
      *(undefined2 *)(*piVar1 + 0x14) = 0;
      *(int **)(*piVar1 + 0x16) = param_1;
      *(undefined4 *)(*piVar1 + 0x1a) = 0;
      *(undefined4 *)(*piVar1 + 0x1e) = 0;
      iVar4 = *piVar1;
      *(undefined4 *)(iVar4 + 0x22) = uVar2;
      *(undefined4 *)(iVar4 + 0x26) = uVar3;
      *(undefined4 *)(*piVar1 + 0x2a) = 0xffffffff;
      *(undefined2 *)(*piVar1 + 0x2e) = 0;
      *(undefined2 *)(*piVar1 + 0x30) = 0;
      *(undefined4 *)(*piVar1 + 0x32) = 0;
      *(undefined4 *)(*piVar1 + 0x36) = 0;
      *(undefined4 *)(*piVar1 + 0x3a) = 0;
      if (1 < *(short *)(*param_1 + 0x20)) {
        .glue::SetDeviceAttribute(piVar1,0,1);
      }
      .glue::SetDeviceAttribute(piVar1,0xe,1);
      if (*(short *)(*param_1 + 0x20) < 9) {
        .glue::MakeITable(*(undefined4 *)(*param_1 + 0x2a),*(undefined4 *)(*piVar1 + 6),
                          (int)*(short *)(*piVar1 + 10));
        uVar5 = .glue::QDError();
      }
    }
  }
  if ((short)uVar5 == 0) {
    *puStack0000001c = piVar1;
  }
  else {
    if (iVar6 != 0) {
      .glue::DisposeHandle(iVar6);
    }
    if (piVar1 != (int *)0x0) {
      .glue::DisposeHandle(piVar1);
    }
  }
  return uVar5;
}

