
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4
.debug::_CreatorTypeFileSearch
          (undefined4 param_1,short param_2,int param_3,int param_4,undefined4 param_5,
          undefined4 param_6,undefined4 *param_7,char param_8)

{
  undefined4 uVar1;
  short sVar2;
  undefined4 uStack00000018;
  short sStack0000001e;
  undefined4 uStack00000028;
  undefined4 uStack0000002c;
  char cStack00000037;
  undefined1 auStack_178 [18];
  undefined4 local_166;
  short local_162;
  undefined4 local_160;
  undefined4 local_15c;
  undefined4 local_158;
  undefined4 local_154;
  undefined1 *local_150;
  undefined1 *local_14c;
  undefined4 local_148;
  undefined4 local_144;
  undefined4 local_140;
  undefined4 local_13c;
  undefined4 local_138;
  int local_134;
  undefined1 auStack_130 [50];
  undefined1 auStack_fe [18];
  undefined4 local_ec;
  undefined1 local_e0;
  undefined4 local_de;
  undefined4 local_da;
  undefined2 local_d6;
  undefined2 local_d4;
  undefined2 local_d2;
  undefined2 local_d0;
  undefined1 auStack_92 [18];
  undefined4 local_80;
  undefined1 local_74;
  int local_72;
  int local_6e;
  undefined2 local_6a;
  undefined2 local_68;
  undefined2 local_66;
  undefined2 local_64;
  
  uStack00000018 = param_1;
  sStack0000001e = param_2;
  uStack00000028 = param_5;
  uStack0000002c = param_6;
  cStack00000037 = param_8;
  uVar1 = _DetermineVRefNum(param_1,(int)param_2,&stack0x0000001e);
  if ((short)uVar1 == 0) {
    local_166 = 0;
    local_162 = sStack0000001e;
    local_160 = uStack00000028;
    local_15c = uStack0000002c;
    local_154 = 0xc;
    local_150 = auStack_92;
    local_14c = auStack_fe;
    local_148 = 0;
    if ((cStack00000037 != '\0') || (_DAT_1003415e != sStack0000001e)) {
      _DAT_1003b710 = 0;
    }
    local_144 = _DAT_1003b710;
    local_140 = uRam1003b714;
    local_13c = uRam1003b718;
    local_138 = uRam1003b71c;
    local_134 = _GetTempBuffer(0x4000,auStack_130);
    local_80 = 0;
    local_ec = 0;
    local_74 = 0;
    local_e0 = 0x10;
    if (param_3 == 0) {
      local_da = 0;
    }
    else {
      local_da = 0xffffffff;
    }
    if (param_4 == 0) {
      local_de = 0;
    }
    else {
      local_de = 0xffffffff;
    }
    local_6a = 0;
    local_68 = 0;
    local_66 = 0;
    local_64 = 0;
    local_d6 = 0;
    local_d4 = 0;
    local_d2 = 0;
    local_d0 = 0;
    local_72 = param_4;
    local_6e = param_3;
    uVar1 = _PBCatSearchSyncCompat(auStack_178);
    sVar2 = (short)uVar1;
    if ((sVar2 == 0) || (sVar2 == -0x27)) {
      *param_7 = local_158;
    }
    else {
      *param_7 = 0;
    }
    if ((sVar2 == 0) || (sVar2 == -0x518)) {
      _DAT_1003b710 = local_144;
      uRam1003b714 = local_140;
      uRam1003b718 = local_13c;
      uRam1003b71c = local_138;
      _DAT_1003415e = sStack0000001e;
    }
    else {
      _DAT_1003b710 = 0;
    }
    if (local_134 != 0) {
      .glue::DisposePtr(local_134);
    }
  }
  return uVar1;
}

