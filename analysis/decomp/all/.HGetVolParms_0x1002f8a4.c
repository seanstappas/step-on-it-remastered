
undefined4
.debug::_HGetVolParms(undefined4 param_1,undefined2 param_2,undefined4 param_3,undefined4 *param_4)

{
  undefined4 uVar1;
  undefined4 uStack00000018;
  undefined2 uStack0000001e;
  undefined4 uStack00000020;
  undefined1 auStack_88 [18];
  undefined4 local_76;
  undefined2 local_72;
  undefined4 local_68;
  undefined4 local_64;
  undefined4 local_60;
  
  local_64 = *param_4;
  uStack00000018 = param_1;
  uStack0000001e = param_2;
  uStack00000020 = param_3;
  local_76 = param_1;
  local_72 = param_2;
  local_68 = param_3;
  uVar1 = .glue::PBHGetVolParmsSync(auStack_88);
  *param_4 = local_60;
  return uVar1;
}

