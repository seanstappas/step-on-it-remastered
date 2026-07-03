
uint FUN_1001ff30(void)

{
  short sVar1;
  undefined1 auStack_18 [20];
  
  sVar1 = .glue::Gestalt(0x7174696d,auStack_18);
  return ((uint)(byte)((sVar1 == 0) << 1) << 0x1c) >> 0x1d;
}

