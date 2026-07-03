/* InitCursor @ 0x10030f50  depth=2 */

void .glue::InitCursor(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10030f64. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::InitCursor)();
  return;
}

