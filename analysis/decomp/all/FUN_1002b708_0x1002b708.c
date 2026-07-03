
void FUN_1002b708(void)

{
  short sVar1;
  short sVar2;
  
  for (sVar1 = 1; sVar1 < 0xe; sVar1 = sVar1 + 1) {
    for (sVar2 = 1; sVar2 < 0x14; sVar2 = sVar2 + 1) {
      *(undefined4 *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar1 * 4) =
           *(undefined4 *)((sVar2 + -1) * 0x34 + (sVar1 + -1) * 4 + 0x1003b2bc);
    }
  }
  for (sVar1 = 0; sVar1 < 0xf; sVar1 = sVar1 + 1) {
    *(undefined4 *)(sVar1 * 4 + 0x1003b218) = 0x300;
    *(undefined4 *)(&DAT_1003ad68 + sVar1 * 4) = 0x300;
  }
  for (sVar1 = 1; sVar1 < 0x14; sVar1 = sVar1 + 1) {
    *(undefined4 *)(sVar1 * 0x3c + 0x1003ada0) = 0x300;
    *(undefined4 *)(&DAT_1003ad68 + sVar1 * 0x3c) = 0x300;
  }
  return;
}

