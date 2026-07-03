
void .glue::OpenCPort(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10031a14. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::OpenCPort)();
  return;
}

