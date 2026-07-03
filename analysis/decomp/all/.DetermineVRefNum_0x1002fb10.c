
undefined4 .debug::_DetermineVRefNum(undefined4 param_1,short param_2,undefined2 *param_3)

{
  undefined4 uVar1;
  undefined4 uStack00000018;
  short sStack0000001e;
  undefined2 *puStack00000020;
  undefined1 auStack_88 [22];
  undefined2 local_72;
  
  uStack00000018 = param_1;
  sStack0000001e = param_2;
  puStack00000020 = param_3;
  uVar1 = _GetVolumeInfoNoName(param_1,(int)param_2,auStack_88);
  *puStack00000020 = local_72;
  return uVar1;
}

