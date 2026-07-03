
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10003bbc(void)

{
  short sVar1;
  short sVar2;
  int iVar3;
  undefined4 uVar4;
  short sVar5;
  short *psVar6;
  
  sVar5 = _DAT_1003a36a;
  while (sVar5 != 0) {
    iVar3 = sVar5 * 0x46;
    if ((((*(char *)(iVar3 + 0x10037e67) == '\0') && (*(int *)(iVar3 + 0x10037e52) != 0)) &&
        (*(char *)(iVar3 + 0x10037e7d) == '\0')) && (*(short *)(iVar3 + 0x10037e56) != 0)) {
      sVar1 = FUN_1002e6cc((int)*(short *)(iVar3 + 0x10037e58));
      sVar2 = FUN_100038c8();
      *(short *)(&DAT_1003789e + sVar2 * 0x14) = sVar5;
      *(undefined2 *)(sVar2 * 0x14 + 0x100378a0) = *(undefined2 *)(&DAT_10037874 + sVar1 * 2);
      *(short *)(&DAT_10037874 + sVar1 * 2) = sVar2;
      psVar6 = (short *)**(undefined4 **)(iVar3 + 0x10037e52);
      if (*psVar6 < *(short *)(iVar3 + 0x10037e56)) {
        *(undefined2 *)(iVar3 + 0x10037e56) = 1;
      }
      if (*(short *)(iVar3 + 0x10037e56) == 0) {
        *(undefined2 *)(iVar3 + 0x10037e56) = 1;
      }
      psVar6 = (short *)(**(int **)(iVar3 + 0x10037e52) +
                        *(int *)(psVar6 + *(short *)(iVar3 + 0x10037e56) * 2 + 4));
      sVar5 = *psVar6;
      sVar1 = psVar6[1];
      *(undefined2 *)(sVar2 * 0x14 + 0x100378a4) = *(undefined2 *)(iVar3 + 0x10037e58);
      *(undefined2 *)(sVar2 * 0x14 + 0x100378a2) = *(undefined2 *)(iVar3 + 0x10037e5a);
      *(short *)(sVar2 * 0x14 + 0x100378a8) = *(short *)(iVar3 + 0x10037e58) + sVar5 + -1;
      *(short *)(sVar2 * 0x14 + 0x100378a6) = *(short *)(iVar3 + 0x10037e5a) + sVar1 + -1;
      if (*(int *)(iVar3 + 0x10037e5c) == 0) {
        uVar4 = *(undefined4 *)(sVar2 * 0x14 + 0x100378a6);
        *(undefined4 *)(sVar2 * 0x14 + 0x100378aa) = *(undefined4 *)(sVar2 * 0x14 + 0x100378a2);
        *(undefined4 *)(sVar2 * 0x14 + 0x100378ae) = uVar4;
      }
      else {
        psVar6 = (short *)(**(int **)(iVar3 + 0x10037e5c) +
                          *(int *)(**(int **)(iVar3 + 0x10037e5c) +
                                  *(short *)(iVar3 + 0x10037e60) * 4 + 8));
        sVar5 = *psVar6;
        sVar1 = psVar6[1];
        *(undefined2 *)(sVar2 * 0x14 + 0x100378ac) = *(undefined2 *)(iVar3 + 0x10037e62);
        *(undefined2 *)(sVar2 * 0x14 + 0x100378aa) = *(undefined2 *)(iVar3 + 0x10037e64);
        *(short *)(sVar2 * 0x14 + 0x100378b0) = *(short *)(iVar3 + 0x10037e62) + sVar5 + -1;
        *(short *)(sVar2 * 0x14 + 0x100378ae) = *(short *)(iVar3 + 0x10037e64) + sVar1 + -1;
        if (*(short *)(sVar2 * 0x14 + 0x100378a4) < *(short *)(sVar2 * 0x14 + 0x100378ac)) {
          *(undefined2 *)(sVar2 * 0x14 + 0x100378ac) = *(undefined2 *)(sVar2 * 0x14 + 0x100378a4);
        }
        if (*(short *)(sVar2 * 0x14 + 0x100378a2) < *(short *)(sVar2 * 0x14 + 0x100378aa)) {
          *(undefined2 *)(sVar2 * 0x14 + 0x100378aa) = *(undefined2 *)(sVar2 * 0x14 + 0x100378a2);
        }
        if (*(short *)(sVar2 * 0x14 + 0x100378b0) < *(short *)(sVar2 * 0x14 + 0x100378a8)) {
          *(undefined2 *)(sVar2 * 0x14 + 0x100378b0) = *(undefined2 *)(sVar2 * 0x14 + 0x100378a8);
        }
        if (*(short *)(sVar2 * 0x14 + 0x100378ae) < *(short *)(sVar2 * 0x14 + 0x100378a6)) {
          *(undefined2 *)(sVar2 * 0x14 + 0x100378ae) = *(undefined2 *)(sVar2 * 0x14 + 0x100378a6);
        }
      }
    }
    sVar5 = *(short *)(iVar3 + 0x10037e86);
  }
  return;
}

