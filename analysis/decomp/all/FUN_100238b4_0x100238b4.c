
void FUN_100238b4(short param_1)

{
  undefined4 uVar1;
  int local_4c;
  undefined4 local_28;
  undefined1 auStack_24 [24];
  
  .glue::GetPort(&local_28);
  .glue::SetPort(*(undefined4 *)(local_4c + 30000));
  if (*(char *)(param_1 * 0x14 + 0x10039514) == '\0') {
    uVar1 = *(undefined4 *)(param_1 * 0x14 + 0x10039518);
  }
  else {
    uVar1 = *(undefined4 *)(param_1 * 0x14 + 0x1003951c);
  }
  .glue::SetRect(auStack_24,(int)*(short *)(&DAT_1003950c + param_1 * 0x14),
                 (int)*(short *)(param_1 * 0x14 + 0x1003950e),
                 (int)*(short *)(param_1 * 0x14 + 0x10039510),
                 (int)*(short *)(param_1 * 0x14 + 0x10039512));
  .glue::PlotCIcon(auStack_24,uVar1);
  .glue::SetPort(local_28);
  return;
}

