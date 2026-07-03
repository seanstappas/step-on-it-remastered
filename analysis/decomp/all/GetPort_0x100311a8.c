
void .glue::GetPort(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x100311bc. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::GetPort)();
  return;
}

