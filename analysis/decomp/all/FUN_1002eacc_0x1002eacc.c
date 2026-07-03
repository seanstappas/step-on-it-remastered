
undefined4 FUN_1002eacc(undefined4 param_1,undefined4 param_2)

{
  undefined4 uVar1;
  undefined4 uStack00000018;
  undefined4 uStack0000001c;
  undefined1 auStack_58 [84];
  
  uStack00000018 = param_1;
  uStack0000001c = param_2;
  uVar1 = FUN_1002f338(param_1,param_2,auStack_58);
  if ((short)uVar1 == 0) {
    uVar1 = .debug::_FSpDeleteCompat(auStack_58);
  }
  return uVar1;
}

