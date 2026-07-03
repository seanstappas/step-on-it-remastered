
undefined4 FUN_10022628(undefined4 param_1,short param_2)

{
  undefined4 uVar1;
  short sStack00000018;
  short sStack0000001a;
  
  sStack0000001a = (short)param_1;
  if ((((*(short *)(&DAT_1003950c + param_2 * 0x14) < sStack0000001a) &&
       (sStack0000001a < *(short *)(param_2 * 0x14 + 0x10039510))) &&
      (sStack00000018 = (short)((uint)param_1 >> 0x10),
      *(short *)(param_2 * 0x14 + 0x1003950e) < sStack00000018)) &&
     (sStack00000018 < *(short *)(param_2 * 0x14 + 0x10039512))) {
    uVar1 = 1;
  }
  else {
    uVar1 = 0;
  }
  return uVar1;
}

