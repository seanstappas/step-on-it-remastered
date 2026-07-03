
void FUN_10000884(undefined4 param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4,
                 undefined4 param_5,undefined4 param_6,uint *param_7,uint *param_8)

{
  byte bVar1;
  short sVar2;
  
  for (sVar2 = 0; sVar2 < 4; sVar2 = sVar2 + 1) {
    bVar1 = FUN_10000944(param_1,param_2,param_3,param_4,param_5,param_6);
    *param_7 = *param_7 << 8 | (uint)bVar1;
    if (bVar1 == 0) {
      *param_8 = *param_8 << 8 | 0xff;
    }
    else {
      *param_8 = *param_8 << 8;
    }
  }
  return;
}

