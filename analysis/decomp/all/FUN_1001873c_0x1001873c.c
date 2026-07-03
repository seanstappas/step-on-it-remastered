
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001873c(short param_1)

{
  int iVar1;
  int iVar2;
  short sVar3;
  undefined4 local_3c;
  
  if (((DAT_1003904a != '\0') && (_DAT_1003904e != 0)) && (DAT_10039048 != '\0')) {
    if (0xff < param_1) {
      param_1 = 0xff;
    }
    iVar1 = .glue::TickCount();
    for (sVar3 = param_1; 0 < sVar3; sVar3 = sVar3 + -1) {
      FUN_100186b8((sVar3 * 0xff) / (int)param_1);
      do {
        iVar2 = .glue::TickCount();
      } while (iVar1 == iVar2);
      iVar1 = .glue::TickCount();
    }
    FUN_100189ac();
    *(undefined1 *)(local_3c + 0x4ed8) = 0;
  }
  return;
}

