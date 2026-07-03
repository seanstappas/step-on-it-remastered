
void .glue::DisposeGDevice(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x1003262c. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::DisposeGDevice)();
  return;
}

