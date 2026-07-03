
void .glue::GetNewDialog(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x100311a4. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::GetNewDialog)();
  return;
}

