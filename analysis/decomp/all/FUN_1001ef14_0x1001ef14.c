
undefined4 FUN_1001ef14(void)

{
  int iVar1;
  int iVar2;
  undefined4 uVar3;
  
  iVar1 = .glue::NGetTrapAddress(0xffffaa6e,1);
  iVar2 = .glue::NGetTrapAddress(0xffffa86e,1);
  if (iVar2 == iVar1) {
    uVar3 = 0x200;
  }
  else {
    uVar3 = 0x400;
  }
  return uVar3;
}

