
int .debug::_IsSubString(byte *param_1,byte *param_2)

{
  byte bVar1;
  short sVar2;
  short sVar3;
  int iVar4;
  short sVar5;
  ushort uVar6;
  
  iVar4 = 0;
  bVar1 = *param_2;
  if ((ushort)bVar1 <= (ushort)*param_1) {
    sVar2 = 1;
    sVar3 = ((ushort)*param_1 - (ushort)bVar1) + 1;
    do {
      uVar6 = 1;
      sVar5 = sVar2;
      while (iVar4 == 0) {
        if (param_1[sVar5] != param_2[(short)uVar6]) break;
        if (uVar6 == bVar1) {
          iVar4 = 1;
        }
        else {
          uVar6 = uVar6 + 1;
          sVar5 = sVar5 + 1;
        }
      }
      if (iVar4 == 0) {
        sVar2 = sVar2 + 1;
        sVar3 = sVar3 + -1;
      }
    } while ((sVar3 != 0) && (iVar4 == 0));
  }
  return iVar4;
}

