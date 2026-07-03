
undefined4 FUN_1002ef44(undefined4 param_1,undefined4 param_2,short *param_3,int param_4)

{
  undefined4 uVar1;
  int iVar2;
  undefined4 uVar3;
  uint uVar4;
  int iVar5;
  short sVar6;
  int iVar7;
  int local_6c;
  int local_48 [5];
  
  if (((short)param_1 == -1) || (param_4 == 0)) {
    return 0xffffffce;
  }
  local_48[0] = param_4;
  uVar1 = .glue::HandToHand(local_48);
  if ((short)uVar1 != 0) {
    return uVar1;
  }
  iVar7 = 0;
  iVar2 = .glue::GetHandleSize(local_48[0]);
  uVar1 = FUN_1002f640(param_1);
  uVar3 = .glue::CurResFile();
  uVar4 = FUN_1002f6d4(uVar1);
  .glue::UseResFile(param_1);
  uVar1 = .glue::ResError();
  if ((short)uVar1 != 0) {
    return uVar1;
  }
  if ((param_3 != (short *)0x0) && (*param_3 != 0)) {
    iVar7 = .glue::Get1Resource(param_2,(int)*param_3);
  }
  if (iVar7 != 0) {
    iVar5 = .glue::GetHandleSize(iVar7);
    if (iVar5 < iVar2) {
      uVar1 = FUN_1002f640(param_1);
      iVar5 = FUN_1002f748(uVar1);
      if (uVar4 < (uint)(iVar2 + iVar5)) {
        uVar1 = 0xffffffde;
        goto LAB_1002f0c4;
      }
    }
    .glue::RemoveResource(iVar7);
    sVar6 = .glue::ResError();
    if (sVar6 == 0) {
      .glue::UpdateResFile(param_1);
      .glue::ResError();
    }
    .glue::DisposeHandle(iVar7);
    uVar1 = .glue::MemError();
  }
LAB_1002f0c4:
  if ((short)uVar1 == 0) {
    uVar1 = FUN_1002f640(param_1);
    iVar7 = FUN_1002f748(uVar1);
    if ((uint)(iVar2 + iVar7) <= uVar4) {
      if (param_3 == (short *)0x0) {
        iVar2 = .glue::Unique1ID(param_2);
      }
      else if (*param_3 == 0) {
        iVar2 = .glue::Unique1ID(param_2);
        *param_3 = (short)iVar2;
      }
      else {
        iVar2 = (int)*param_3;
      }
      .glue::AddResource(local_48[0],param_2,iVar2,local_6c + -0x16);
      sVar6 = .glue::ResError();
      if (sVar6 == 0) {
        .glue::WriteResource(local_48[0]);
        .glue::ReleaseResource(local_48[0]);
      }
    }
  }
  .glue::UseResFile(uVar3);
  uVar1 = .glue::ResError();
  return uVar1;
}

