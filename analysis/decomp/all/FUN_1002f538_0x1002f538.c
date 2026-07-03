
undefined4 FUN_1002f538(short param_1,int param_2,int param_3)

{
  short sVar1;
  undefined4 uVar2;
  int local_2ac;
  undefined1 local_288 [256];
  undefined1 auStack_188 [256];
  undefined1 auStack_88 [18];
  undefined1 *local_76;
  short local_72;
  undefined2 local_6c;
  int local_58;
  int local_24;
  
  uVar2 = 0;
  if (param_1 < 0) {
    if (param_2 == param_3) {
      uVar2 = 1;
    }
    else {
      local_76 = auStack_188;
      local_288[0] = 0;
      local_24 = param_2;
      while( true ) {
        local_6c = 0xffff;
        local_58 = local_24;
        local_72 = param_1;
        sVar1 = .glue::PBGetCatInfoSync(auStack_88);
        if (sVar1 != 0) break;
        if (local_24 == param_3) {
          return 1;
        }
        sVar1 = FUN_1002f7b4(auStack_188,local_2ac + -0x15,auStack_188);
        if (sVar1 != 0) {
          return 0;
        }
        sVar1 = FUN_1002f7b4(auStack_188,local_288,local_288);
        if (sVar1 != 0) {
          return 0;
        }
        if (local_58 == 2) {
          return 0;
        }
      }
    }
  }
  return uVar2;
}

