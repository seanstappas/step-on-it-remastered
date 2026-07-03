
void FUN_10021fd4(short param_1)

{
  undefined4 uVar1;
  
  if (*(int *)(param_1 * 0x14 + 0x10039518) == 0) {
    uVar1 = .glue::GetCIcon((int)*(short *)(param_1 * 0x14 + 0x10039516));
    *(undefined4 *)(param_1 * 0x14 + 0x10039518) = uVar1;
    uVar1 = .glue::GetCIcon(*(short *)(param_1 * 0x14 + 0x10039516) + 1);
    *(undefined4 *)(param_1 * 0x14 + 0x1003951c) = uVar1;
    *(short *)(&DAT_1003950c + param_1 * 0x14) = *(short *)(&DAT_1003950c + param_1 * 0x14) + 2;
    *(short *)(param_1 * 0x14 + 0x1003950e) = *(short *)(param_1 * 0x14 + 0x1003950e) + -8;
    *(short *)(param_1 * 0x14 + 0x10039510) =
         *(short *)(&DAT_1003950c + param_1 * 0x14) +
         *(short *)(**(int **)(param_1 * 0x14 + 0x10039518) + 0xc);
    *(short *)(param_1 * 0x14 + 0x10039512) =
         *(short *)(param_1 * 0x14 + 0x1003950e) +
         *(short *)(**(int **)(param_1 * 0x14 + 0x10039518) + 10);
  }
  return;
}

