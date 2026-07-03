
undefined4 .debug::_GetVolumeInfoNoName(byte *param_1,undefined2 param_2,int param_3)

{
  undefined4 uVar1;
  undefined2 uStack0000001e;
  undefined1 auStack_118 [268];
  
  if (param_3 == 0) {
    uVar1 = 0xffffffce;
  }
  else {
    *(undefined2 *)(param_3 + 0x16) = param_2;
    uStack0000001e = param_2;
    if (param_1 == (byte *)0x0) {
      *(undefined4 *)(param_3 + 0x12) = 0;
      *(undefined2 *)(param_3 + 0x1c) = 0;
    }
    else {
      .glue::BlockMoveData(param_1,auStack_118,*param_1 + 1);
      *(undefined1 **)(param_3 + 0x12) = auStack_118;
      *(undefined2 *)(param_3 + 0x1c) = 0xffff;
    }
    uVar1 = .glue::PBHGetVInfoSync(param_3);
    *(undefined4 *)(param_3 + 0x12) = 0;
  }
  return uVar1;
}

