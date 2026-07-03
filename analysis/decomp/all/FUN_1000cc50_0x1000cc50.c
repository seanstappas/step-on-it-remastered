
undefined4 FUN_1000cc50(short param_1,short param_2)

{
  undefined4 uVar1;
  
  if ((*(int *)(&DAT_1003ad68 + (param_1 + -1) * 0x3c + param_2 * 4) == 0x40d) ||
     (*(int *)(&DAT_1003ad68 + (param_1 + -1) * 0x3c + param_2 * 4) == 0x40e)) {
    uVar1 = 0;
  }
  else if ((*(int *)(&DAT_1003ad68 + (param_1 + 1) * 0x3c + param_2 * 4) == 0x40d) ||
          (*(int *)(&DAT_1003ad68 + (param_1 + 1) * 0x3c + param_2 * 4) == 0x40e)) {
    uVar1 = 0;
  }
  else if ((*(int *)(&DAT_1003ad68 + (param_1 + -1) * 0x3c + (param_2 + 1) * 4) == 0x40d) ||
          (*(int *)(&DAT_1003ad68 + (param_1 + -1) * 0x3c + (param_2 + 1) * 4) == 0x40e)) {
    uVar1 = 0;
  }
  else if ((*(int *)(&DAT_1003ad68 + param_1 * 0x3c + (param_2 + 1) * 4) == 0x40d) ||
          (*(int *)(&DAT_1003ad68 + param_1 * 0x3c + (param_2 + 1) * 4) == 0x40e)) {
    uVar1 = 0;
  }
  else if ((*(int *)(&DAT_1003ad68 + (param_1 + 1) * 0x3c + (param_2 + 1) * 4) == 0x40d) ||
          (*(int *)(&DAT_1003ad68 + (param_1 + 1) * 0x3c + (param_2 + 1) * 4) == 0x40e)) {
    uVar1 = 0;
  }
  else if ((*(int *)(&DAT_1003ad68 + (param_1 + -1) * 0x3c + (param_2 + 2) * 4) == 0x40d) ||
          (*(int *)(&DAT_1003ad68 + (param_1 + -1) * 0x3c + (param_2 + 2) * 4) == 0x40e)) {
    uVar1 = 0;
  }
  else if ((*(int *)(&DAT_1003ad68 + param_1 * 0x3c + (param_2 + 2) * 4) == 0x40d) ||
          (*(int *)(&DAT_1003ad68 + param_1 * 0x3c + (param_2 + 2) * 4) == 0x40e)) {
    uVar1 = 0;
  }
  else if ((*(int *)(&DAT_1003ad68 + (param_1 + 1) * 0x3c + (param_2 + 2) * 4) == 0x40d) ||
          (*(int *)(&DAT_1003ad68 + (param_1 + 1) * 0x3c + (param_2 + 2) * 4) == 0x40e)) {
    uVar1 = 0;
  }
  else {
    uVar1 = 1;
  }
  return uVar1;
}

