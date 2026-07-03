
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

bool FUN_1002168c(void)

{
  short sVar1;
  int local_ac;
  undefined4 local_74 [4];
  char local_64 [6];
  undefined1 auStack_5e [90];
  
  sVar1 = _DAT_1003ad0c;
  local_74[0] = 0x53734264;
  .glue::CustomGetFile(0,1,local_74,local_64,0x1a4,0xffffffff,0,0);
  if (local_64[0] != '\0') {
    FUN_10021748(auStack_5e);
  }
  return sVar1 != *(short *)(local_ac + 0x6b9c);
}

