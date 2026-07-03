
void .glue::GetProcessInformation(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10031dbc. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::GetProcessInformation)();
  return;
}

