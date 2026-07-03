
uint FUN_1001b14c(uint param_1)

{
  bool bVar1;
  int iVar2;
  int iVar3;
  ushort uVar4;
  
  bVar1 = (param_1 & 0x800) != 0;
  if (bVar1) {
    param_1 = param_1 & 0x7ff;
    iVar2 = .glue::NGetTrapAddress(0xffffaa6e,1);
    iVar3 = .glue::NGetTrapAddress(0xffffa86e,1);
    if (iVar3 == iVar2) {
      uVar4 = 0x200;
    }
    else {
      uVar4 = 0x400;
    }
    if (uVar4 <= (ushort)param_1) {
      param_1 = 0xffffa89f;
    }
  }
  iVar2 = .glue::NGetTrapAddress(0xffffa89f,1);
  iVar3 = .glue::NGetTrapAddress(param_1,bVar1);
  return ((uint)(byte)((iVar3 == iVar2) << 1) << 0x1c) >> 0x1d ^ 1;
}

