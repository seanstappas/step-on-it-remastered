
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10026344(undefined2 *param_1)

{
  uint uVar1;
  
  uRam100394a8 = param_1[1];
  _DAT_100394a6 = *param_1;
  uRam100394ac = param_1[3];
  uRam100394aa = param_1[2];
  uVar1 = (int)sRam1003b6ba - (int)(short)param_1[3];
  sRam100394b0 = (short)((int)uVar1 >> 1) + (ushort)((int)uVar1 < 0 && (uVar1 & 1) != 0);
  uVar1 = (int)sRam1003b6b8 - (int)(short)param_1[2];
  _DAT_100394ae = (short)((int)uVar1 >> 1) + (ushort)((int)uVar1 < 0 && (uVar1 & 1) != 0);
  sRam100394b4 = sRam100394b0 + param_1[3];
  sRam100394b2 = _DAT_100394ae + param_1[2];
  return;
}

