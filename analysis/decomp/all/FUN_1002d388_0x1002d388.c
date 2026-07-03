
bool FUN_1002d388(uint param_1)

{
  uint uVar1;
  uint uVar2;
  short sVar3;
  
  sVar3 = (short)(param_1 >> 8) + (ushort)((int)param_1 < 0 && (param_1 & 0xff) != 0);
  uVar1 = (uint)sVar3;
  uVar2 = (uint)sVar3;
  sVar3 = sVar3 + (short)(((int)uVar2 >> 5) + (uint)((int)uVar2 < 0 && (uVar2 & 0x1f) != 0)) * -0x20
  ;
  uVar2 = (uint)sVar3;
  return (0x80000000U >>
          (((((int)uVar2 >> 3) + (uint)((int)uVar2 < 0 && (uVar2 & 7) != 0)) * 0x10 + 7) -
           (int)sVar3 & 0x3f) &
         *(uint *)(&DAT_1003b6fc +
                  (((int)uVar1 >> 5) + (uint)((int)uVar1 < 0 && (uVar1 & 0x1f) != 0)) * 4)) != 0;
}

