
void .debug::_FSpOpenResFileCompat(undefined4 param_1,undefined1 param_2)

{
  undefined4 uStack00000018;
  undefined1 uStack0000001f;
  
  uStack00000018 = param_1;
  uStack0000001f = param_2;
  .glue::FSpOpenResFile(param_1,param_2);
  return;
}

