
undefined4 FUN_1002f1c8(int param_1,char param_2,short *param_3,undefined4 *param_4)

{
  undefined4 uVar1;
  short sVar2;
  char cStack0000001f;
  undefined1 auStack_88 [18];
  int local_76;
  short local_72;
  undefined2 local_6c;
  undefined4 local_58;
  undefined4 local_20 [4];
  
  if ((param_3 == (short *)0x0) || (param_4 == (undefined4 *)0x0)) {
    uVar1 = 0xffffffce;
  }
  else {
    cStack0000001f = param_2;
    uVar1 = .glue::FindFolder(0xffff8000,0x70726566,1,param_3,local_20);
    sVar2 = (short)uVar1;
    local_58 = local_20[0];
    if (sVar2 == -0x2b) {
      uVar1 = .glue::FindFolder(0xffff8000,0x6d616373,0,param_3,local_20);
      sVar2 = (short)uVar1;
      local_58 = local_20[0];
    }
    if (sVar2 == 0) {
      if (param_1 == 0) {
        *param_4 = local_58;
      }
      else {
        local_72 = *param_3;
        local_6c = 0;
        local_76 = param_1;
        local_20[0] = local_58;
        uVar1 = .glue::PBGetCatInfoSync(auStack_88);
        if ((short)uVar1 == 0) {
          *param_4 = local_58;
        }
        else if (((short)uVar1 == -0x2b) && (cStack0000001f != '\0')) {
          uVar1 = .glue::DirCreate((int)*param_3,local_20[0],param_1,param_4);
        }
      }
    }
  }
  return uVar1;
}

