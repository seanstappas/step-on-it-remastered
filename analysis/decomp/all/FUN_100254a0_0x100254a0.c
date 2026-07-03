
void FUN_100254a0(void)

{
  int local_3c;
  int local_16 [4];
  
  .glue::Gestalt(0x6b626420,local_16);
  if (local_16[0] - 4U < 0x15) {
                    /* WARNING: Could not recover jumptable at 0x100254ec. Too many branches */
                    /* WARNING: Treating indirect jump as call */
    (**(code **)(local_3c + 0x2eb0 + (local_16[0] - 4U) * 4))();
    return;
  }
  uRam1003a2cc = 0x5300;
  uRam1003a2d0 = 0x5500;
  uRam1003a2d4 = 0x5700;
  uRam1003a2d8 = 0x4700;
  uRam1003a2dc = 0x5900;
  uRam1003a2e0 = 0x5100;
  uRam1003a2e4 = 0x5b00;
  uRam1003a2e8 = 0x300;
  uRam1003a2ec = 0x400;
  uRam1003a2f0 = 0x1100;
  uRam1003a2f4 = 0x3800;
  uRam1003a2f8 = 0x3b00;
  uRam1003a2fc = 0x3a00;
  uRam1003a300 = 0x3700;
  return;
}

