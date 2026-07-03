/* GetKeys @ 0x100321c8  calls: GetKeys */

void .glue::GetKeys(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x100321dc. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::GetKeys)();
  return;
}

