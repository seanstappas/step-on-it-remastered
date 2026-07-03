
void FUN_1002b174(short param_1)

{
  *(undefined2 *)(param_1 * 0x70 + 0x1003a9fe) = 0;
  *(undefined2 *)(param_1 * 0x70 + 0x1003a9be) = 0x38;
  *(undefined2 *)(param_1 * 0x70 + 0x1003a9c2) = *(undefined2 *)(&DAT_1003a9b0 + param_1 * 0x70);
  *(undefined2 *)(param_1 * 0x70 + 0x1003a9b2) = *(undefined2 *)(&DAT_1003a9b0 + param_1 * 0x70);
  *(undefined2 *)(param_1 * 0x70 + 0x1003a9c4) = *(undefined2 *)(param_1 * 0x70 + 0x1003a9b2);
  *(undefined2 *)(param_1 * 0x70 + 0x1003a9cc) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9d6) = 0;
  *(undefined2 *)(param_1 * 0x70 + 0x1003a9c6) = *(undefined2 *)(param_1 * 0x70 + 0x1003a9b4);
  *(undefined2 *)(param_1 * 0x70 + 0x1003a9c8) = 0x22;
  *(undefined4 *)(param_1 * 0x70 + 0x1003a9ba) = *(undefined4 *)(&DAT_1003ad34 + param_1 * 4);
  *(undefined2 *)(param_1 * 0x70 + 0x1003aa0c) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9d5) = 0;
  *(undefined2 *)(param_1 * 0x70 + 0x1003a9e4) = 1;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9ce) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9cf) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9d0) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9d1) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9d2) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9d3) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9d4) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9d7) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9ea) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9d8) = 0;
  *(undefined1 *)(param_1 * 0x70 + 0x1003a9d9) = 0;
  *(undefined2 *)(param_1 * 0x70 + 0x1003a9f4) = 1;
  if (*(char *)(param_1 * 0x70 + 0x1003a9f8) == '\0') {
    if (DAT_100370e4 == '\0') {
      if (0 < sRam1003aa66) {
        *(undefined1 *)(param_1 * 0x70 + 0x1003a9f8) = 1;
        sRam1003aa66 = sRam1003aa66 + -1;
      }
    }
    else if (0 < *(short *)(param_1 * 0x70 + 0x1003a9f6)) {
      *(undefined1 *)(param_1 * 0x70 + 0x1003a9f8) = 1;
      *(short *)(param_1 * 0x70 + 0x1003a9f6) = *(short *)(param_1 * 0x70 + 0x1003a9f6) + -1;
    }
  }
  return;
}

