
void FUN_10022cc0(void)

{
  short sVar1;
  
  for (sVar1 = 1; sVar1 < 0xb; sVar1 = sVar1 + 1) {
    (&DAT_10039782)[sVar1 * 0x104] = 0;
    *(undefined4 *)(sVar1 * 0x104 + 0x10039882) = 5000;
  }
  DAT_100393ae = 1;
  return;
}

