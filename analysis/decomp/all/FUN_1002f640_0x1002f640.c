
int FUN_1002f640(short param_1)

{
  short sVar1;
  int iVar2;
  undefined1 auStack_98 [64];
  undefined1 auStack_58 [18];
  undefined1 *local_46;
  undefined2 local_42;
  short local_40;
  undefined2 local_3c;
  short local_24;
  
  iVar2 = 0;
  if (param_1 != -1) {
    local_46 = auStack_98;
    local_42 = 0;
    local_3c = 0;
    local_40 = param_1;
    sVar1 = .glue::PBGetFCBInfoSync(auStack_58);
    if (sVar1 == 0) {
      iVar2 = (int)local_24;
    }
  }
  return iVar2;
}

