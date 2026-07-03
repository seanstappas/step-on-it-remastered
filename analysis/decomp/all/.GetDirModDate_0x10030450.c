
undefined4 .debug::_GetDirModDate(undefined2 param_1,undefined4 param_2)

{
  short sVar1;
  undefined2 uStack0000001a;
  undefined4 uStack0000001c;
  undefined1 local_98 [32];
  undefined1 auStack_78 [18];
  undefined1 *local_66;
  undefined2 local_62;
  undefined2 local_5c;
  undefined4 local_48;
  undefined4 local_2c;
  
  local_98[0] = 0;
  local_66 = local_98;
  local_5c = 0xffff;
  uStack0000001a = param_1;
  uStack0000001c = param_2;
  local_62 = param_1;
  local_48 = param_2;
  sVar1 = .glue::PBGetCatInfoSync(auStack_78);
  if (sVar1 != 0) {
    local_2c = 0xffffffff;
  }
  return local_2c;
}

