
uint FUN_100055c8(short param_1,short param_2)

{
  short sVar1;
  short sVar2;
  short sStack0000001a;
  short sStack0000001e;
  
  sStack0000001a = param_1;
  sStack0000001e = param_2;
  sVar1 = FUN_1002e6f8((int)param_2);
  sVar2 = FUN_1002e6cc((int)sStack0000001a);
  return *(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar1 * 4) & 0xffff;
}

