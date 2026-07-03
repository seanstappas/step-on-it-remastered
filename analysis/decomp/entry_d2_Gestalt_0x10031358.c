/* Gestalt @ 0x10031358  depth=2 */

void .glue::Gestalt(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x1003136c. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::Gestalt)();
  return;
}

