
void FUN_10023cec(short param_1,undefined4 param_2,int param_3)

{
  short sVar1;
  
  sVar1 = FUN_10023ad0(param_2,param_3);
  *(int *)(&DAT_1003a2b0 + param_1 * 0x1c) = (int)sVar1;
  sVar1 = FUN_10023ad0(param_2,param_3 + 0xc);
  *(int *)(param_1 * 0x1c + 0x1003a2b4) = (int)sVar1;
  sVar1 = FUN_10023ad0(param_2,param_3 + 0x18);
  *(int *)(param_1 * 0x1c + 0x1003a2b8) = (int)sVar1;
  sVar1 = FUN_10023ad0(param_2,param_3 + 0x24);
  *(int *)(param_1 * 0x1c + 0x1003a2bc) = (int)sVar1;
  sVar1 = FUN_10023ad0(param_2,param_3 + 0x30);
  *(int *)(param_1 * 0x1c + 0x1003a2c0) = (int)sVar1;
  sVar1 = FUN_10023ad0(param_2,param_3 + 0x3c);
  *(int *)(param_1 * 0x1c + 0x1003a2c4) = (int)sVar1;
  sVar1 = FUN_10023ad0(param_2,param_3 + 0x48);
  *(int *)(param_1 * 0x1c + 0x1003a2c8) = (int)sVar1;
  return;
}

