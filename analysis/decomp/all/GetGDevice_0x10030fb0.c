
void .glue::GetGDevice(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10030fc4. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::GetGDevice)();
  return;
}

