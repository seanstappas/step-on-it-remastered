
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001b780(void)

{
  char cVar2;
  uint uVar1;
  undefined1 auStack_38 [24];
  
  while (DAT_100393d3 == '\0') {
    cVar2 = .glue::WaitNextEvent(0xffff,auStack_38,0x3c,0);
    if (cVar2 != '\0') {
      FUN_1001b8b0(auStack_38);
    }
    if ((DAT_100393d1 == '\0') && ((_DAT_1003a2ae == 2 || (_DAT_1003a2ae == 3)))) {
      uVar1 = .glue::TickCount();
      if (_DAT_1003949c < uVar1) {
        if (_DAT_1003a2ae == 2) {
          FUN_10024c58();
        }
        else {
          FUN_10024bb0();
        }
      }
    }
    FUN_10018b98();
    if (((DAT_100393d3 != '\0') && (DAT_100393d0 != '\0')) && (DAT_100393e4 == '\0')) {
      DAT_100393d3 = FUN_1001d9dc();
      if (DAT_100393d3 == '\0') {
        FUN_10023a64(8);
      }
    }
  }
  return;
}

