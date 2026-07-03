
undefined4 FUN_1002e990(undefined4 param_1,undefined4 param_2,undefined2 *param_3)

{
  undefined4 uVar1;
  undefined4 uVar2;
  undefined2 uVar3;
  undefined4 uStack00000018;
  undefined4 uStack0000001c;
  undefined1 auStack_58 [72];
  
  if (param_3 == (undefined2 *)0x0) {
    uVar2 = 0xffffffce;
  }
  else {
    uStack00000018 = param_1;
    uStack0000001c = param_2;
    uVar1 = .glue::CurResFile();
    uVar2 = FUN_1002f338(uStack00000018,uStack0000001c,auStack_58);
    if ((short)uVar2 == 0) {
      uVar3 = .debug::_FSpOpenResFileCompat(auStack_58,3);
      uVar2 = .glue::ResError();
      if ((short)uVar2 == 0) {
        *param_3 = uVar3;
        .glue::UseResFile(uVar1);
        uVar2 = .glue::ResError();
      }
    }
  }
  return uVar2;
}

