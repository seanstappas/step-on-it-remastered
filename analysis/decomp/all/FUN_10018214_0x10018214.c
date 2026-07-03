
void FUN_10018214(short param_1)

{
  undefined4 uVar1;
  
  uVar1 = FUN_10019894((int)*(short *)(&DAT_10034a00 + param_1 * 2),0x2a);
  *(undefined4 *)(&DAT_1003abec + param_1 * 4) = uVar1;
  if (*(int *)(&DAT_1003abec + param_1 * 4) == 0) {
    FUN_10018180();
    uVar1 = FUN_10019894((int)*(short *)(&DAT_10034a00 + param_1 * 2),0x2a);
    *(undefined4 *)(&DAT_1003abec + param_1 * 4) = uVar1;
    if (*(int *)(&DAT_1003abec + param_1 * 4) == 0) {
      FUN_100192f8(6);
    }
  }
  return;
}

