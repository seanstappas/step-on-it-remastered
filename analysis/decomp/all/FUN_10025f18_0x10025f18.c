
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10025f18(void)

{
  int local_3c;
  undefined2 local_18;
  undefined2 local_16;
  undefined2 local_14;
  
  local_16 = 0;
  local_18 = 0;
  local_14 = 0;
  .glue::RGBForeColor(&local_18);
  .glue::SetPort(_DAT_1003b6a0);
  .glue::CopyBits(*(int *)(local_3c + 0x7570) + 2,_DAT_1003b6a0 + 2,local_3c + 0x5336,
                  _DAT_1003b6a0 + 0x10,0,*(undefined4 *)(_DAT_1003b6a0 + 0x18));
  if (*(char *)(local_3c + 0x5324) != '\0') {
    FUN_10021c14();
  }
  return;
}

