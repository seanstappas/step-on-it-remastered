
void .glue::HGetState(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x100319e4. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::HGetState)();
  return;
}

