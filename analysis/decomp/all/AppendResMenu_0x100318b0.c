
void .glue::AppendResMenu(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x100318c4. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::AppendResMenu)();
  return;
}

