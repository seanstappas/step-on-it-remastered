
void FUN_10022d2c(short param_1)

{
  short sVar1;
  
  sVar1 = 10;
  while( true ) {
    if (sVar1 <= param_1) break;
    FUN_10026fd8(&DAT_10039782 + (sVar1 + -1) * 0x104,&DAT_10039782 + sVar1 * 0x104);
    *(undefined4 *)(sVar1 * 0x104 + 0x10039882) = *(undefined4 *)((sVar1 + -1) * 0x104 + 0x10039882)
    ;
    sVar1 = sVar1 + -1;
  }
  *(undefined4 *)(param_1 * 0x104 + 0x10039882) = 0;
  (&DAT_10039782)[param_1 * 0x104] = 0;
  return;
}

