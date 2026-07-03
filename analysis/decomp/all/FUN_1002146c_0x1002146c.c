
undefined4 FUN_1002146c(undefined4 param_1)

{
  undefined4 uVar1;
  int iVar2;
  char cVar3;
  undefined4 uStack00000018;
  int local_ac;
  short local_88 [3];
  undefined4 local_82;
  undefined2 local_7e;
  undefined2 local_7c;
  undefined2 local_7a;
  undefined2 local_78;
  undefined1 local_76;
  undefined4 local_74;
  undefined2 local_70;
  undefined2 local_6e;
  undefined2 local_6c;
  undefined2 local_6a;
  int local_68;
  undefined1 local_64;
  undefined1 auStack_63 [65];
  undefined4 local_22;
  short local_1e [9];
  
  uStack00000018 = param_1;
  uVar1 = .glue::FSpOpenDF(param_1,1,local_1e);
  local_22 = 0x66;
  if ((short)uVar1 == 0) {
    uVar1 = .glue::SetFPos((int)local_1e[0],1,0);
  }
  if ((short)uVar1 == 0) {
    uVar1 = .glue::FSRead((int)local_1e[0],&local_22,local_88);
  }
  if ((short)uVar1 == 0) {
    uVar1 = .glue::FSClose((int)local_1e[0]);
  }
  iVar2 = FUN_100212d4(local_88);
  if (local_68 == iVar2) {
    cVar3 = FUN_1002701c(local_ac + 0x6b5c,auStack_63);
    if (cVar3 == '\0') {
      .glue::ParamText(auStack_63,0,0,0);
      .glue::Alert(0x1a1,0);
      .glue::ParamText(0,0,0,0);
      uVar1 = 0xffffffff;
    }
    else {
      FUN_100263d8((int)local_88[0]);
      uRam1003aa5c = local_82;
      uRam1003aa66 = local_7e;
      uRam1003aa6a = local_7c;
      uRam1003aa6c = local_7a;
      uRam1003aa58 = local_78;
      uRam1003aa4b = 1;
      uRam1003aa68 = local_76;
      uRam1003aacc = local_74;
      uRam1003aad6 = local_70;
      uRam1003aada = local_6e;
      uRam1003aadc = local_6c;
      uRam1003aac8 = local_6a;
      uRam1003aabb = 1;
      uRam1003aad8 = local_64;
      if ((short)uVar1 == 0) {
        *(undefined1 *)(local_ac + 0x51ec) = 1;
        *(undefined1 *)(local_ac + 0x5260) = 1;
        FUN_10024b1c();
        FUN_100238b4(5);
        FUN_10023770(5);
      }
    }
  }
  else {
    .glue::Alert(0x1a0,0);
    uVar1 = 0xffffffff;
  }
  return uVar1;
}

