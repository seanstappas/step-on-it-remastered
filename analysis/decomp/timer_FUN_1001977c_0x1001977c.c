/* FUN_1001977c @ 0x1001977c */

undefined4 FUN_1001977c(void)

{
  undefined4 uVar1;
  int iVar2;
  int iVar3;
  
  iRam1003907e = .glue::NewPtr(0x400);
  if (iRam1003907e == 0) {
    uVar1 = 0;
  }
  else {
    for (iVar2 = 0; iVar2 < 0x200; iVar2 = iVar2 + 1) {
      iVar3 = 0x200 - (0x200 - iVar2);
      iVar3 = (iVar3 * iVar3) / 0x10;
      *(char *)(iRam1003907e + iVar2) = (char)((iVar3 * iVar3) / 0x200000);
    }
    for (iVar2 = 0; iVar2 < 0x200; iVar2 = iVar2 + 1) {
      iVar3 = ((0x200 - iVar2) * (0x200 - iVar2)) / 0x10;
      *(char *)(iVar2 + iRam1003907e + 0x200) = -1 - (char)((iVar3 * iVar3) / 0x200000);
    }
    uVar1 = 1;
  }
  return uVar1;
}

