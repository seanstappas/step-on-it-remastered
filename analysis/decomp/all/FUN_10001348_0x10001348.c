
void FUN_10001348(undefined4 *param_1,short param_2,ushort *param_3,int *param_4)

{
  ushort uVar1;
  int iVar2;
  short *psVar3;
  
  iVar2 = (int)param_2;
  psVar3 = (short *)*param_1;
  if (iVar2 < 1) {
    return;
  }
  if (*psVar3 < iVar2) {
    return;
  }
  iVar2 = *(int *)(psVar3 + iVar2 * 2 + 4);
  if (psVar3[1] == 2) {
    if ((*param_3 & 2) != 0) {
      *param_4 = (int)psVar3 + *(int *)((int)psVar3 + iVar2 + 0x10) + iVar2;
      *param_3 = *param_3 & 0xfffc;
      return;
    }
    *param_4 = (int)psVar3 + iVar2 + 0x18;
    *param_3 = *param_3 & 0xfffc;
    return;
  }
  if (psVar3[1] != 4) {
    *param_4 = (int)psVar3 + iVar2 + 0x18;
    *param_3 = *param_3 + 2 & 0xfffc;
    return;
  }
  uVar1 = *param_3 & 3;
  if (uVar1 == 0) {
    *param_4 = (int)psVar3 + iVar2 + 0x18;
    *param_3 = *param_3 & 0xfffc;
    return;
  }
  if (uVar1 == 1) {
    *param_4 = (int)psVar3 + *(int *)((int)psVar3 + iVar2 + 0xc) + iVar2;
    *param_3 = *param_3 & 0xfffc;
    return;
  }
  if (uVar1 == 2) {
    *param_4 = (int)psVar3 + *(int *)((int)psVar3 + iVar2 + 0x10) + iVar2;
    *param_3 = *param_3 & 0xfffc;
    return;
  }
  *param_4 = (int)psVar3 + *(int *)((int)psVar3 + iVar2 + 0x14) + iVar2;
  *param_3 = *param_3 & 0xfffc;
  return;
}

