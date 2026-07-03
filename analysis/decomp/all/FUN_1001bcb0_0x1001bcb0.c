
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001bcb0(int param_1)

{
  bool bVar1;
  bool bVar2;
  uint uVar3;
  int local_3c;
  
  uVar3 = *(uint *)(param_1 + 2) >> 0x18;
  if (((uVar3 != 0xfa) && (uVar3 < 0xfa)) && (uVar3 == 1)) {
    bVar1 = (*(uint *)(param_1 + 2) & 1) == 0;
    if (bVar1) {
      DAT_100393d1 = bVar1;
      FUN_1001873c(0x1e);
      .glue::HideWindow(_DAT_1003b6a4);
      .glue::SetDefaultOutputVolume(*(undefined4 *)(local_3c + 0x753c));
    }
    else {
      bVar2 = DAT_100393d1 != '\0';
      DAT_100393d1 = bVar1;
      if (bVar2) {
        FUN_1001bdd4();
        .glue::ShowWindow(_DAT_1003b6a4);
        .glue::GetDefaultOutputVolume(local_3c + 0x753c);
        .glue::SetDefaultOutputVolume(0x1000100);
        if (*(char *)(local_3c + 0x4fe5) != '\0') {
          FUN_10018414(5);
          FUN_1001882c(1);
        }
      }
    }
    .glue::FrontWindow();
  }
  return;
}

