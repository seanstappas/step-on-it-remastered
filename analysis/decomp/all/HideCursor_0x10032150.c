
void .glue::HideCursor(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10032164. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::HideCursor)();
  return;
}

