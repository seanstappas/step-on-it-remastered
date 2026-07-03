
void FUN_10005630(short param_1,short param_2,short param_3)

{
  short sVar1;
  short sVar2;
  int iVar3;
  short sStack0000001a;
  short sStack0000001e;
  short sStack00000022;
  
  sStack0000001a = param_1;
  sStack0000001e = param_2;
  sStack00000022 = param_3;
  sVar1 = FUN_1002e6cc((int)param_1);
  sVar2 = FUN_1002e6f8((int)sStack0000001e);
  iVar3 = sVar1 * 0x3c + sVar2 * 4;
  *(uint *)(&DAT_1003ad68 + iVar3) = *(uint *)(&DAT_1003ad68 + iVar3) & 0xffff0000;
  iVar3 = sVar1 * 0x3c + sVar2 * 4;
  *(int *)(&DAT_1003ad68 + iVar3) = *(int *)(&DAT_1003ad68 + iVar3) + (int)sStack00000022;
  return;
}

