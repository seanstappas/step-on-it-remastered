
void .glue::GetMainDevice(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10032614. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::GetMainDevice)();
  return;
}

