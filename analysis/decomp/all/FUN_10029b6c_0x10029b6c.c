
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10029b6c(void)

{
  int iVar1;
  undefined4 uVar2;
  
  iVar1 = _DAT_1003b6cc - *_DAT_1003b6d0;
  .glue::HUnlock(_DAT_1003b6d0);
  .glue::SetHandleSize(_DAT_1003b6d0,iVar1 + 4);
  uVar2 = .glue::UniqueID(0x444d4b59);
  .glue::AddResource(_DAT_1003b6d0,0x444d4b59,uVar2,0);
  return;
}

