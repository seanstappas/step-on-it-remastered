
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001c01c(void)

{
  undefined4 uVar1;
  undefined4 uVar2;
  char cVar3;
  short sVar4;
  int local_3c;
  
  sVar4 = _DAT_1003b29c;
  if ((DAT_1003ab6e != '\0') && (DAT_100370e4 != '\0')) {
    sVar4 = _DAT_1003b29a;
  }
  uVar1 = .glue::FrontWindow();
  uVar2 = .glue::GetMenuHandle(0x81);
  .glue::EnableItem(uVar2,10);
  .glue::EnableItem(uVar2,3);
  .glue::EnableItem(uVar2,7);
  if (*(char *)(local_3c + 0x5260) == '\0') {
    .glue::DisableItem(uVar2,2);
    .glue::DisableItem(uVar2,4);
    .glue::DisableItem(uVar2,5);
  }
  else {
    .glue::EnableItem(uVar2,2);
    .glue::EnableItem(uVar2,4);
    .glue::EnableItem(uVar2,5);
  }
  if ((*(short *)(local_3c + 0x6b9c) == -1) || (sVar4 < 1)) {
    .glue::DisableItem(uVar2,2);
    .glue::DisableItem(uVar2,8);
    .glue::DisableItem(uVar2,1);
  }
  else {
    .glue::EnableItem(uVar2,8);
    .glue::EnableItem(uVar2,1);
  }
  uVar2 = .glue::GetMenuHandle(0x82);
  cVar3 = FUN_1001ed64(uVar1);
  if (cVar3 == '\0') {
    .glue::DisableItem(uVar2,1);
    .glue::DisableItem(uVar2,3);
    .glue::DisableItem(uVar2,4);
    .glue::DisableItem(uVar2,6);
    .glue::DisableItem(uVar2,5);
  }
  else {
    .glue::EnableItem(uVar2,1);
    .glue::EnableItem(uVar2,3);
    .glue::EnableItem(uVar2,4);
    .glue::EnableItem(uVar2,6);
    .glue::EnableItem(uVar2,5);
  }
  uVar1 = .glue::GetMenuHandle(0x83);
  .glue::EnableItem(uVar1,1);
  if (*(char *)(local_3c + 0x523c) == '\0') {
    .glue::DisableItem(uVar1,2);
  }
  else {
    .glue::EnableItem(uVar1,2);
  }
  uVar1 = .glue::GetMenuHandle(0x68);
  if (*(char *)(local_3c + 0x4ed9) == '\0') {
    .glue::DisableItem(uVar1,1);
    .glue::DisableItem(uVar1,2);
    .glue::DisableItem(uVar1,3);
    uVar1 = .glue::GetMenuHandle(0x85);
    .glue::DisableItem(uVar1,1);
  }
  else {
    .glue::EnableItem(uVar1,1);
    .glue::EnableItem(uVar1,2);
    .glue::EnableItem(uVar1,3);
    uVar1 = .glue::GetMenuHandle(0x85);
    .glue::EnableItem(uVar1,1);
  }
  return;
}

