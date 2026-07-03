
undefined4 FUN_100182d0(undefined4 param_1,undefined4 param_2)

{
  undefined4 uVar1;
  undefined4 uStack00000018;
  undefined4 uStack0000001c;
  undefined1 auStack_d8 [8];
  undefined1 auStack_d0 [64];
  short local_90;
  undefined4 local_8e;
  undefined4 local_4a;
  undefined1 *local_46;
  short *local_12;
  
  local_4a = 0x3c;
  local_46 = auStack_d0;
  local_12 = &local_90;
  uStack00000018 = param_1;
  uStack0000001c = param_2;
  uVar1 = .glue::GetCurrentProcess(auStack_d8);
  if ((((short)uVar1 == 0) &&
      (uVar1 = .glue::GetProcessInformation(auStack_d8,&local_4a), (short)uVar1 == 0)) &&
     (uVar1 = .glue::FSMakeFSSpec((int)local_90,local_8e,uStack00000018,uStack0000001c),
     (short)uVar1 == 0)) {
    uVar1 = 0;
  }
  return uVar1;
}

