
undefined4 FUN_1002f7b4(byte *param_1,byte *param_2,int param_3)

{
  uint uVar1;
  ushort uVar2;
  undefined4 uVar3;
  char local_228;
  undefined1 auStack_227 [255];
  byte local_128;
  undefined1 auStack_127 [267];
  
  uVar3 = 0;
  if (((param_1 == (byte *)0x0) || (param_2 == (byte *)0x0)) || (param_3 == 0)) {
    uVar3 = 0xffffffce;
  }
  else {
    uVar2 = (ushort)*param_2;
    if (0xff < (ushort)((ushort)*param_1 + (ushort)*param_2)) {
      uVar2 = 0xff - *param_1;
    }
    .glue::BlockMoveData(param_1,&local_128,*param_1 + 1);
    .glue::BlockMoveData(param_2,&local_228,(short)uVar2 + 1);
    uVar1 = (uint)local_128;
    local_128 = local_128 + local_228;
    .glue::BlockMoveData(auStack_227,auStack_127 + uVar1,local_228);
    .glue::BlockMoveData(&local_128,param_3,local_128 + 1);
  }
  return uVar3;
}

