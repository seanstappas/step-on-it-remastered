/* ExitToShell @ 0x10031160  depth=2 */

void .glue::ExitToShell(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10031174. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::ExitToShell)();
  return;
}

