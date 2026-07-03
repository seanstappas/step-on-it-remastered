
void .glue::GrowWindow(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x100324dc. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::GrowWindow)();
  return;
}

