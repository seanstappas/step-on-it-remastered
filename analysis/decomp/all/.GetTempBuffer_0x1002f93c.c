
int .debug::_GetTempBuffer(uint param_1,uint *param_2)

{
  uint uVar1;
  int iVar2;
  uint uVar3;
  
  param_1 = param_1 & 0xfffffc00;
  if ((int)param_1 < 0x400) {
    param_1 = 0x400;
  }
  iVar2 = .glue::NewPtr(param_1);
  if ((iVar2 == 0) && (0x400 < (int)param_1)) {
    iVar2 = .glue::FreeMem();
    uVar1 = iVar2 - 0x8000U & 0xfffffc00;
    uVar3 = .glue::MaxBlock();
    param_1 = uVar3 & 0xfffffc00;
    if ((int)uVar1 < (int)(uVar3 & 0xfffffc00)) {
      param_1 = uVar1;
    }
    if (param_1 == 0) {
      param_1 = 0x400;
    }
    iVar2 = .glue::NewPtr(param_1);
  }
  if (iVar2 == 0) {
    *param_2 = 0;
  }
  else {
    *param_2 = param_1;
  }
  return iVar2;
}

