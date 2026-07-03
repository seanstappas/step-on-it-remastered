
void .glue::InitMenus(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10030f1c. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::InitMenus)();
  return;
}

