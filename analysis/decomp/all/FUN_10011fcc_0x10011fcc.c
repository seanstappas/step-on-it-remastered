
void FUN_10011fcc(short param_1)

{
  uint uVar1;
  short sVar2;
  
  if (*(char *)(param_1 * 0x70 + 0x1003a9d8) == '\x01') {
    *(undefined4 *)(param_1 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + param_1 * 4);
    *(short *)(param_1 * 0x70 + 0x1003a9e2) = *(short *)(param_1 * 0x70 + 0x1003a9e2) + 1;
    *(undefined1 *)(param_1 * 0x70 + 0x1003a9d2) = 0;
    *(undefined1 *)(param_1 * 0x70 + 0x1003a9d1) = 0;
    *(short *)(param_1 * 0x70 + 0x1003a9be) =
         *(short *)(param_1 * 0x70 + 0x1003a9be) + *(short *)(param_1 * 0x70 + 0x1003a9de);
    if (*(short *)(param_1 * 0x70 + 0x1003a9be) < 0x7e) {
      if (*(short *)(param_1 * 0x70 + 0x1003a9be) < 0x75) {
        *(undefined2 *)(param_1 * 0x70 + 0x1003a9be) = 0x76;
        *(undefined2 *)(param_1 * 0x70 + 0x1003a9de) = 1;
      }
    }
    else {
      *(undefined2 *)(param_1 * 0x70 + 0x1003a9be) = 0x7c;
      *(undefined2 *)(param_1 * 0x70 + 0x1003a9de) = 0xffff;
    }
    uVar1 = (int)*(short *)(param_1 * 0x70 + 0x1003a9e2) *
            (int)*(short *)(param_1 * 0x70 + 0x1003a9e2);
    sVar2 = (short)((int)(*(short *)(param_1 * 0x70 + 0x1003a9e4) * 10 +
                         *(short *)(param_1 * 0x70 + 0x1003a9e2) * -0x1e +
                         ((int)uVar1 >> 1) + (uint)((int)uVar1 < 0 && (uVar1 & 1) != 0)) / 10);
    if (sVar2 < 0x30) {
      sVar2 = 0x30;
    }
    if (sVar2 < 0x1be) {
      *(short *)(param_1 * 0x70 + 0x1003a9b4) = sVar2;
    }
    else {
      *(undefined1 *)(param_1 * 0x70 + 0x1003a9ea) = 1;
      FUN_10028958();
      FUN_10004cb0(*(undefined4 *)(param_1 * 0x70 + 0x1003a9ba),
                   (int)*(short *)(param_1 * 0x70 + 0x1003a9c8),
                   (int)*(short *)(param_1 * 0x70 + 0x1003a9c4),
                   (int)*(short *)(param_1 * 0x70 + 0x1003a9c6));
      FUN_100289c0();
    }
  }
  return;
}

