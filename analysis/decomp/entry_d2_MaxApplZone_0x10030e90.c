/* MaxApplZone @ 0x10030e90  depth=2 */

void .glue::MaxApplZone(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10030ea4. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::MaxApplZone)();
  return;
}

