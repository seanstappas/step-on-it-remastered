
void .debug::_CheckForMatches(int param_1,int param_2,undefined4 param_3,char param_4,char param_5)

{
  bool bVar1;
  char cVar2;
  int iVar3;
  int iVar4;
  uint uVar5;
  char cStack00000027;
  char cStack0000002b;
  undefined1 auStack_68 [76];
  
  bVar1 = false;
  uVar5 = *(uint *)(param_2 + 0x24);
  iVar4 = *(int *)(param_2 + 0x28);
  iVar3 = *(int *)(param_2 + 0x2c);
  cStack00000027 = param_4;
  cStack0000002b = param_5;
  if ((*(byte *)(param_1 + 0x1e) & 0x10) == 0) {
    if (param_4 == '\0') goto LAB_10030348;
  }
  else if (param_5 == '\0') goto LAB_10030348;
  if ((uVar5 & 1) == 0) {
LAB_10030138:
    if ((uVar5 & 2) != 0) {
      cVar2 = .glue::EqualString(*(undefined4 *)(param_1 + 0x12),param_3,0,1);
      if (cVar2 == '\0') goto LAB_10030348;
      if (uVar5 == 2) goto LAB_10030344;
    }
    if ((((((((uVar5 & 0x2000) != 0) &&
            ((*(uint *)(param_1 + 100) < *(uint *)(iVar4 + 100) ||
             (*(uint *)(iVar3 + 100) < *(uint *)(param_1 + 100))))) ||
           (((uVar5 & 4) != 0 &&
            ((*(byte *)(iVar3 + 0x1e) & (*(byte *)(param_1 + 0x1e) ^ *(byte *)(iVar4 + 0x1e))) != 0)
            ))) || ((((uVar5 & 0x10) != 0 &&
                     ((*(ushort *)(param_1 + 0x34) < *(ushort *)(iVar4 + 0x34) ||
                      (*(ushort *)(iVar3 + 0x34) < *(ushort *)(param_1 + 0x34))))) ||
                    (((uVar5 & 8) != 0 &&
                     (cVar2 = _CompareMasked(param_1 + 0x20,iVar4 + 0x20,iVar3 + 0x20,4),
                     cVar2 == '\0')))))) ||
         (((((uVar5 & 0x1000) != 0 &&
            (cVar2 = _CompareMasked(param_1 + 0x54,iVar4 + 0x54,iVar3 + 0x54,4), cVar2 == '\0')) ||
           (((uVar5 & 0x20) != 0 &&
            ((*(uint *)(param_1 + 0x36) < *(uint *)(iVar4 + 0x36) ||
             (*(uint *)(iVar3 + 0x36) < *(uint *)(param_1 + 0x36))))))) ||
          (((uVar5 & 0x40) != 0 &&
           ((*(uint *)(param_1 + 0x3a) < *(uint *)(iVar4 + 0x3a) ||
            (*(uint *)(iVar3 + 0x3a) < *(uint *)(param_1 + 0x3a))))))))) ||
        ((((uVar5 & 0x80) != 0 &&
          ((*(uint *)(param_1 + 0x40) < *(uint *)(iVar4 + 0x40) ||
           (*(uint *)(iVar3 + 0x40) < *(uint *)(param_1 + 0x40))))) ||
         (((uVar5 & 0x100) != 0 &&
          ((*(uint *)(param_1 + 0x44) < *(uint *)(iVar4 + 0x44) ||
           (*(uint *)(iVar3 + 0x44) < *(uint *)(param_1 + 0x44))))))))) ||
       (((((uVar5 & 0x200) != 0 &&
          ((*(uint *)(param_1 + 0x48) < *(uint *)(iVar4 + 0x48) ||
           (*(uint *)(iVar3 + 0x48) < *(uint *)(param_1 + 0x48))))) ||
         (((uVar5 & 0x400) != 0 &&
          ((*(uint *)(param_1 + 0x4c) < *(uint *)(iVar4 + 0x4c) ||
           (*(uint *)(iVar3 + 0x4c) < *(uint *)(param_1 + 0x4c))))))) ||
        (((uVar5 & 0x800) != 0 &&
         ((*(uint *)(param_1 + 0x50) < *(uint *)(iVar4 + 0x50) ||
          (*(uint *)(iVar3 + 0x50) < *(uint *)(param_1 + 0x50))))))))) goto LAB_10030348;
  }
  else {
    if ((**(char **)(param_1 + 0x12) == '\0') || (0x3f < **(byte **)(param_1 + 0x12)))
    goto LAB_10030348;
    .glue::BlockMoveData(*(undefined4 *)(param_1 + 0x12),auStack_68,**(byte **)(param_1 + 0x12) + 1)
    ;
    .glue::UpperString(auStack_68,1);
    cVar2 = _IsSubString(auStack_68,param_3);
    if (cVar2 == '\0') goto LAB_10030348;
    if (uVar5 != 1) goto LAB_10030138;
  }
LAB_10030344:
  bVar1 = true;
LAB_10030348:
  if ((uVar5 & 0x4000) != 0) {
    bVar1 = !bVar1;
  }
  if (bVar1) {
    *(undefined2 *)(*(int *)(param_2 + 0x18) + *(int *)(param_2 + 0x20) * 0x46) =
         *(undefined2 *)(param_1 + 0x16);
    *(undefined4 *)(*(int *)(param_2 + 0x18) + 2 + *(int *)(param_2 + 0x20) * 0x46) =
         *(undefined4 *)(param_1 + 100);
    if (0x3f < **(byte **)(param_1 + 0x12)) {
      **(undefined1 **)(param_1 + 0x12) = 0x3f;
    }
    .glue::BlockMoveData
              (*(undefined4 *)(param_1 + 0x12),
               *(int *)(param_2 + 0x18) + 6 + *(int *)(param_2 + 0x20) * 0x46,
               **(byte **)(param_1 + 0x12) + 1);
    *(int *)(param_2 + 0x20) = *(int *)(param_2 + 0x20) + 1;
  }
  return;
}

