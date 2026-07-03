
void FUN_1002d980(void)

{
  ushort uVar1;
  short sVar2;
  undefined2 uVar3;
  int iVar4;
  short sVar5;
  int iVar6;
  short sVar7;
  
  FUN_100058ac();
  iVar4 = 1;
  while( true ) {
    sVar5 = (short)iVar4;
    if (0x13 < sVar5) break;
    for (iVar6 = 1; sVar7 = (short)iVar6, sVar7 < 0xe; iVar6 = iVar6 + 1) {
      uVar1 = (ushort)*(undefined4 *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar7 * 4) & 0xff;
      if ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar7 * 4) & 0x400) != 0) {
        sVar2 = FUN_10005948();
        *(undefined1 *)(sVar2 * 0x46 + 0x10037e7c) = 0;
        if ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar7 * 4) & 0x2000) == 0) {
          if (((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar7 * 4) & 0x100) == 0) ||
             ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar7 * 4) & 0x200) == 0)) {
            if ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar7 * 4) & 0x100) != 0) {
              *(undefined2 *)(sVar2 * 0x46 + 0x10037e4c) = 1;
            }
            if ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar7 * 4) & 0x200) != 0) {
              *(undefined2 *)(sVar2 * 0x46 + 0x10037e4c) = 2;
            }
          }
          else {
            *(undefined2 *)(sVar2 * 0x46 + 0x10037e4c) = 3;
          }
        }
        else {
          *(undefined2 *)(sVar2 * 0x46 + 0x10037e4c) = 4;
        }
        *(ushort *)(sVar2 * 0x46 + 0x10037e4a) = uVar1;
        *(ushort *)(sVar2 * 0x46 + 0x10037e8a) = uVar1;
        uVar3 = FUN_1002e6ac(iVar4);
        *(undefined2 *)(sVar2 * 0x46 + 0x10037e58) = uVar3;
        uVar3 = FUN_1002e6bc(iVar6);
        *(undefined2 *)(sVar2 * 0x46 + 0x10037e5a) = uVar3;
        *(undefined2 *)(sVar2 * 0x46 + 0x10037e88) = 0;
        *(ushort *)(sVar2 * 0x46 + 0x10037e4e) =
             (ushort)((uint)*(undefined4 *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar7 * 4) >> 0x10) &
             0xff;
        *(ushort *)(sVar2 * 0x46 + 0x10037e50) =
             (ushort)(byte)((uint)*(undefined4 *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar7 * 4) >> 0x18)
        ;
        *(undefined4 *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar7 * 4) = 0;
      }
    }
    iVar4 = iVar4 + 1;
  }
  FUN_10017b68();
  return;
}

