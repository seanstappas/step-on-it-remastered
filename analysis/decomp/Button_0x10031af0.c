/* Button @ 0x10031af0  calls: Button */

void .glue::Button(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10031b04. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::Button)();
  return;
}

