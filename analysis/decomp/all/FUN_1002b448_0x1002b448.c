
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002b448(int param_1)

{
  int iVar1;
  int local_4c;
  
  _DAT_1003b292 = (short)param_1;
  if (_DAT_1003b292 == -100) {
    .glue::UseResFile((int)_DAT_10039360);
    iVar1 = .glue::Get1Resource(0x424f5244,param_1 + 400);
    .glue::UseResFile((int)*(short *)(local_4c + 0x6b9c));
  }
  else {
    .glue::UseResFile((int)_DAT_1003ad0c);
    if (*(char *)(local_4c + 0x69fc) == '\0') {
      iVar1 = .glue::Get1Resource(0x424f5244,param_1 + 400);
    }
    else {
      iVar1 = .glue::Get1Resource(0x424f5244,param_1 + 1000);
    }
  }
  if (iVar1 == 0) {
    FUN_100192f8(5);
  }
  .glue::MoveHHi(iVar1);
  .glue::HLock(iVar1);
  FUN_1001a348(iVar1,&DAT_1003b2a4);
  *(undefined4 *)(local_4c + 0x61f4) = **(undefined4 **)(local_4c + 0x61f0);
  uRam1003aa56 = uRam1003b2a6;
  uRam1003aac6 = uRam1003b2a8;
  uRam1003aa20 = FUN_1002e6ac(sRam1003b2aa + 1);
  sRam1003aa24 = FUN_1002e6bc(sRam1003b2ac + 1);
  sRam1003aa24 = sRam1003aa24 + 1;
  uRam1003aa90 = FUN_1002e6ac(sRam1003b2ae + 1);
  sRam1003aa94 = FUN_1002e6bc(sRam1003b2b0 + 1);
  sRam1003aa94 = sRam1003aa94 + 1;
  uRam1003aa60 = uRam1003b2b2;
  uRam1003aad0 = uRam1003b2b2;
  if (sRam1003b2ba == 0x3a20) {
    sRam1003b2ba = 5000;
  }
  sRam1003aa62 = sRam1003b2ba;
  if (sRam1003b2ba < 1) {
    sRam1003aa62 = 5000;
  }
  sRam1003aad2 = sRam1003b2ba;
  if (sRam1003b2ba < 1) {
    sRam1003aad2 = 5000;
  }
  _DAT_1003b290 = sRam1003b2b4;
  _DAT_1003b28e = sRam1003b2b6;
  _DAT_1003b28c = sRam1003b2b8;
  if (100 < sRam1003b2b4) {
    _DAT_1003b290 = 0;
  }
  if (_DAT_1003b290 < 0) {
    _DAT_1003b290 = 0;
  }
  if (0x14 < sRam1003b2b6) {
    _DAT_1003b28e = 0;
  }
  if (_DAT_1003b28e < 0) {
    _DAT_1003b28e = 0;
  }
  if (100 < sRam1003b2b8) {
    _DAT_1003b28c = 0;
  }
  if (_DAT_1003b28c < 0) {
    _DAT_1003b28c = 0;
  }
  if (_DAT_1003b28e == 0) {
    _DAT_1003b28c = 0;
  }
  if (_DAT_1003b28c == 0) {
    _DAT_1003b28e = 0;
  }
  FUN_1002b708();
  .glue::HUnlock(iVar1);
  return;
}

