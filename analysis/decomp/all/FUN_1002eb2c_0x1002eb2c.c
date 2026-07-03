
uint FUN_1002eb2c(undefined4 param_1,undefined4 param_2)

{
  short sVar1;
  undefined4 uStack00000018;
  undefined4 uStack0000001c;
  undefined1 auStack_58 [84];
  
  uStack00000018 = param_1;
  uStack0000001c = param_2;
  sVar1 = FUN_1002f338(param_1,param_2,auStack_58);
  return ((uint)(byte)((sVar1 == 0) << 1) << 0x1c) >> 0x1d;
}

