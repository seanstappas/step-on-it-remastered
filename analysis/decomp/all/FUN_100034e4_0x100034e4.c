
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100034e4(void)

{
  uint uVar1;
  short sVar2;
  int *piVar3;
  short sVar4;
  int *piVar5;
  int iVar6;
  
  FUN_10028958();
  uVar1 = (uint)_DAT_1003ad40;
  piVar3 = _DAT_1003ad44;
  for (sVar2 = 0; sVar2 < 0x1e0; sVar2 = sVar2 + 1) {
    piVar5 = piVar3;
    for (sVar4 = 0; sVar4 < 0xa0; sVar4 = sVar4 + 1) {
      iVar6 = *piVar5;
      *piVar5 = (((*(uint *)(&DAT_10037124 + (short)((ushort)iVar6 & 0xff) * 4) >> 8) +
                  *(int *)(&DAT_10037124 + (short)((ushort)((uint)iVar6 >> 8) & 0xff) * 4) >> 8) +
                 *(int *)(&DAT_10037124 + (short)((ushort)((uint)iVar6 >> 0x10) & 0xff) * 4) >> 8) +
                *(int *)(&DAT_10037124 + (short)(ushort)(byte)((uint)iVar6 >> 0x18) * 4);
      piVar5 = piVar5 + 1;
    }
    piVar3 = piVar3 + ((int)uVar1 >> 2) + (uint)((int)uVar1 < 0 && (uVar1 & 3) != 0);
  }
  FUN_100289c0();
  return;
}

