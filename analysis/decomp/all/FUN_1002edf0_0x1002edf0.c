
undefined4 FUN_1002edf0(undefined4 param_1,undefined4 param_2,short *param_3,int *param_4)

{
  undefined4 uVar1;
  undefined4 uVar2;
  int iVar3;
  short sVar4;
  undefined1 auStack_128 [4];
  undefined1 auStack_124 [268];
  
  if (((short)param_1 == -1) || (param_4 == (int *)0x0)) {
    uVar2 = 0xffffffce;
  }
  else {
    uVar1 = .glue::CurResFile();
    .glue::UseResFile(param_1);
    uVar2 = .glue::ResError();
    if ((short)uVar2 == 0) {
      if ((param_3 == (short *)0x0) || (*param_3 == 0)) {
        iVar3 = .glue::Get1IndResource(param_2,1);
        *param_4 = iVar3;
        if ((*param_4 != 0) && (param_3 != (short *)0x0)) {
          .glue::GetResInfo(*param_4,param_3,auStack_128,auStack_124);
        }
      }
      else {
        iVar3 = .glue::Get1Resource(param_2,(int)*param_3);
        *param_4 = iVar3;
      }
      sVar4 = .glue::ResError();
      if ((sVar4 == 0) && (*param_4 != 0)) {
        .glue::DetachResource(*param_4);
        .glue::ResError();
      }
      .glue::UseResFile(uVar1);
      uVar2 = .glue::ResError();
    }
  }
  return uVar2;
}

