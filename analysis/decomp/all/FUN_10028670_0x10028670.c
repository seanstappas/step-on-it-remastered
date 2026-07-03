
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10028670(void)

{
  short sVar1;
  undefined2 uVar2;
  int local_2c;
  
  sVar1 = .glue::OpenResFile(&DAT_10037100);
  if (sVar1 == -1) {
    FUN_100192f8(9);
  }
  sVar1 = .glue::OpenResFile(local_2c + 0x2f9b);
  if (sVar1 == -1) {
    FUN_100192f8(9);
  }
  _DAT_1003ad0c = .glue::OpenResFile(local_2c + 0x2fa8);
  if (_DAT_1003ad0c == -1) {
    .glue::Alert(0x19b,0);
    *(undefined2 *)(local_2c + 0x712a) = 0;
    *(undefined2 *)(local_2c + 0x712c) = 0;
    *(undefined1 *)(local_2c + 0x52dc) = 1;
  }
  else {
    uVar2 = FUN_10028788((int)_DAT_1003ad0c,0x191);
    *(undefined2 *)(local_2c + 0x712c) = uVar2;
    uVar2 = FUN_10028788((int)_DAT_1003ad0c,0x3e9);
    *(undefined2 *)(local_2c + 0x712a) = uVar2;
    FUN_10026fd8(local_2c + 0x2fa8,local_2c + 0x6b5c);
    *(undefined1 *)(local_2c + 0x52dc) = 1;
  }
  return;
}

