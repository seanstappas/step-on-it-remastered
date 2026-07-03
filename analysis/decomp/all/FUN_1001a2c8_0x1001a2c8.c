
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001a2c8(short param_1)

{
  int local_3c;
  undefined2 local_16;
  short local_14;
  undefined4 local_12;
  
  if ((param_1 < 8) && (-1 < param_1)) {
    local_14 = param_1 * 0x24;
    local_16 = 0x2b;
    local_12 = 0;
    .glue::SndDoImmediate(_DAT_1003905c,&local_16);
    *(int *)(local_3c + 0x4f4c) = (int)param_1;
  }
  return;
}

