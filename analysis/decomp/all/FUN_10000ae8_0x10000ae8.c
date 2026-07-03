
undefined4
FUN_10000ae8(undefined4 *param_1,undefined4 param_2,int param_3,int *param_4,undefined4 *param_5)

{
  int iVar1;
  undefined4 unaff_r24;
  int *piVar2;
  short sVar3;
  undefined4 uVar4;
  int iVar5;
  int *piStack00000024;
  undefined4 *puStack00000028;
  undefined4 local_38;
  uint local_34;
  int *local_30 [4];
  
  iVar5 = 0;
  piVar2 = (int *)0x0;
  local_30[0] = (int *)0x0;
  uVar4 = 0;
  piStack00000024 = param_4;
  puStack00000028 = param_5;
  if (param_3 != 0) {
    unaff_r24 = .glue::HGetState(param_3);
    .glue::HNoPurge(param_3);
  }
  sVar3 = (short)param_2;
  iVar1 = (((int)*(short *)((int)param_1 + 6) - (int)*(short *)((int)param_1 + 2)) * (int)sVar3 +
           0x1f >> 5) << 2;
  .glue::Gestalt(0x71642020,&local_34);
  if (((((sVar3 == 1) || (sVar3 == 2)) || (sVar3 == 4)) || (sVar3 == 8)) ||
     (((sVar3 == 0x10 || (sVar3 == 0x20)) && (0x1ff < local_34)))) {
    if ((short)iVar1 < 0x3fff) {
      if ((sVar3 < 9) && (param_3 == 0)) {
        uVar4 = 0xffffffce;
      }
    }
    else {
      uVar4 = 0xffffffce;
    }
  }
  else {
    uVar4 = 0xffffffce;
  }
  if ((short)uVar4 == 0) {
    iVar5 = .glue::NewPtr(0x6c);
    if (iVar5 == 0) {
      uVar4 = .glue::MemError();
    }
    else {
      .glue::GetPort(&local_38);
      .glue::OpenCPort(iVar5);
      uVar4 = param_1[1];
      *(undefined4 *)(iVar5 + 0x10) = *param_1;
      *(undefined4 *)(iVar5 + 0x14) = uVar4;
      .glue::RectRgn(*(undefined4 *)(iVar5 + 0x18),param_1);
      .glue::ClipRect(param_1);
      uVar4 = FUN_10000d90(param_2,param_1,param_3,iVar1,*(undefined4 *)(iVar5 + 2));
      if ((short)uVar4 == 0) {
        piVar2 = *(int **)(iVar5 + 2);
        uVar4 = FUN_10000fd8(piVar2,local_30);
      }
      .glue::SetPort(local_38);
    }
  }
  if (param_3 != 0) {
    .glue::HSetState(param_3,unaff_r24);
  }
  if ((short)uVar4 == 0) {
    *piStack00000024 = iVar5;
    *puStack00000028 = local_30[0];
  }
  else {
    if (piVar2 != (int *)0x0) {
      .glue::DisposeCTable(*(undefined4 *)(*piVar2 + 0x2a));
      .glue::DisposePtr(*(undefined4 *)*piVar2);
    }
    if (local_30[0] != (int *)0x0) {
      .glue::DisposeHandle(*(undefined4 *)(*local_30[0] + 6));
      .glue::DisposeHandle(local_30[0]);
    }
    if (iVar5 != 0) {
      .glue::CloseCPort(iVar5);
      .glue::DisposePtr(iVar5);
    }
  }
  return uVar4;
}

