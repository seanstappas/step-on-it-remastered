
void FUN_1001bab8(int param_1)

{
  short sVar1;
  int local_4c;
  undefined1 auStack_28 [24];
  
  sVar1 = .glue::FindWindow(*(undefined4 *)(param_1 + 10),auStack_28);
  if ((uint)(int)sVar1 < 9) {
                    /* WARNING: Could not recover jumptable at 0x1001bb08. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    (**(code **)(local_4c + 0xb68 + sVar1 * 4))();
    return;
  }
  return;
}

