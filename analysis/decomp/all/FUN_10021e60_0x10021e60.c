
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10021e60(int *param_1)

{
  undefined4 unaff_r28;
  short sVar1;
  int *local_28 [5];
  
  if (DAT_10039494 != '\0') {
    unaff_r28 = *(undefined4 *)*_DAT_10039498;
    .glue::DisposeHandle(_DAT_10039498);
  }
  local_28[0] = param_1;
  .glue::HandToHand(local_28);
  _DAT_10039498 = param_1;
  .glue::HandToHand(&DAT_10039498);
  .glue::MoveHHi(_DAT_10039498);
  .glue::HLock(_DAT_10039498);
  sVar1 = 0;
  *(undefined4 *)*_DAT_10039498 = unaff_r28;
  while( true ) {
    if (*(short *)(*_DAT_10039498 + 6) < sVar1) break;
    *(short *)(*_DAT_10039498 + 8 + sVar1 * 8) = sVar1;
    sVar1 = sVar1 + 1;
  }
  .glue::HUnlock(_DAT_10039498);
  *(undefined4 *)*local_28[0] =
       *(undefined4 *)**(undefined4 **)(**(int **)(*_DAT_1003b6dc + 0x16) + 0x2a);
  .glue::DisposeHandle(*(undefined4 *)(**(int **)(*_DAT_1003b6dc + 0x16) + 0x2a));
  *(int **)(**(int **)(*_DAT_1003b6dc + 0x16) + 0x2a) = local_28[0];
  .glue::MakeITable(*(undefined4 *)(**(int **)(*_DAT_1003b6dc + 0x16) + 0x2a),
                    *(undefined4 *)(*_DAT_1003b6dc + 6),(int)*(short *)(*_DAT_1003b6dc + 10));
  return;
}

