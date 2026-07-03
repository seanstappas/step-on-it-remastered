
undefined4
FUN_1002e724(undefined4 param_1,undefined4 param_2,int param_3,undefined4 param_4,int param_5)

{
  undefined4 uVar1;
  short sVar2;
  undefined4 uStack00000024;
  undefined2 local_238;
  undefined4 local_236;
  short local_232;
  undefined1 auStack_230 [256];
  byte local_130 [256];
  undefined4 local_30;
  undefined4 local_2c;
  ushort local_28;
  short local_20;
  undefined4 local_1e;
  
  if (param_3 == 0) {
    uVar1 = 0xffffffce;
  }
  else {
    uStack00000024 = param_4;
    uVar1 = FUN_1002f1c8(param_4,1,&local_20,&local_1e);
    if ((short)uVar1 == 0) {
      uVar1 = .glue::CurResFile();
      .glue::HCreateResFile((int)local_20,local_1e,param_3);
      sVar2 = .glue::ResError();
      if ((sVar2 == 0) &&
         (sVar2 = .glue::HGetFInfo((int)local_20,local_1e,param_3,&local_30), sVar2 == 0)) {
        local_28 = local_28 | 0x1000;
        local_30 = param_2;
        local_2c = param_1;
        sVar2 = .glue::HSetFInfo((int)local_20,local_1e,param_3,&local_30);
        if ((sVar2 == 0) && (param_5 != 0)) {
          .glue::GetIndString(local_130,400,1);
          .glue::GetIndString(auStack_230,400,2);
          if ((((&stack0x00000000 != (undefined1 *)0x130) &&
               (&stack0x00000000 != (undefined1 *)0x230)) &&
              (sVar2 = FUN_1002f7b4(local_130,param_5,local_130), sVar2 == 0)) &&
             ((sVar2 = FUN_1002f7b4(local_130,auStack_230,local_130), sVar2 == 0 &&
              (sVar2 = FUN_1002e990(param_1,param_2,&local_232), sVar2 == 0)))) {
            .glue::PtrToHand(local_130,&local_236,local_130[0] + 1);
            sVar2 = .glue::MemError();
            if (sVar2 == 0) {
              local_238 = 0xbff3;
              FUN_1002ef44((int)local_232,0x53545220,&local_238,local_236);
              .glue::DisposeHandle(local_236);
              .glue::MemError();
            }
            FUN_1002ea68((int)local_232);
          }
        }
      }
      .glue::UseResFile(uVar1);
      uVar1 = .glue::ResError();
    }
  }
  return uVar1;
}

