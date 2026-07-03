
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10023770(short param_1)

{
  undefined4 uVar1;
  int local_4c;
  undefined4 local_28;
  undefined1 auStack_24 [20];
  
  .glue::GetPort(&local_28);
  .glue::SetPort(*(undefined4 *)(local_4c + 0x7570));
  .glue::SetGDevice(*(undefined4 *)(local_4c + 0x756c));
  if (*(char *)(param_1 * 0x14 + 0x10039514) == '\0') {
    uVar1 = *(undefined4 *)(param_1 * 0x14 + 0x10039518);
  }
  else {
    uVar1 = *(undefined4 *)(param_1 * 0x14 + 0x1003951c);
  }
  .glue::SetRect(auStack_24,(int)sRam100394a8 + (int)*(short *)(&DAT_1003950c + param_1 * 0x14),
                 (int)_DAT_100394a6 + (int)*(short *)(param_1 * 0x14 + 0x1003950e),
                 (int)sRam100394a8 + (int)*(short *)(param_1 * 0x14 + 0x10039510),
                 (int)_DAT_100394a6 + (int)*(short *)(param_1 * 0x14 + 0x10039512));
  .glue::PlotCIcon(auStack_24,uVar1);
  .glue::SetPort(local_28);
  .glue::SetGDevice(*(undefined4 *)(local_4c + 0x7564));
  return;
}

