
undefined4 .debug::_CheckVol(undefined4 param_1,short param_2,short *param_3,int *param_4)

{
  undefined4 uVar1;
  undefined4 uStack00000018;
  short sStack0000001e;
  short *psStack00000020;
  int *piStack00000024;
  undefined1 auStack_88 [22];
  short local_72;
  int local_6a;
  ushort local_5a;
  int local_58;
  short local_42;
  
  uStack00000018 = param_1;
  sStack0000001e = param_2;
  psStack00000020 = param_3;
  piStack00000024 = param_4;
  uVar1 = _GetVolumeInfoNoName(param_1,(int)param_2,auStack_88);
  if ((short)uVar1 == 0) {
    *psStack00000020 = local_72;
    *piStack00000024 = local_6a + (int)local_72 + (uint)local_5a + local_58 + (int)local_42;
  }
  return uVar1;
}

