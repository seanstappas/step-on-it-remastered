
undefined4 .debug::_VerifyUserPB(int param_1,char *param_2,char *param_3,undefined1 *param_4)

{
  int iVar1;
  int iVar2;
  
  iVar2 = *(int *)(param_1 + 0x28);
  iVar1 = *(int *)(param_1 + 0x2c);
  if (((*(int *)(param_1 + 0x18) != 0) && (iVar2 != 0)) &&
     (((*(uint *)(param_1 + 0x24) & 0xffffbffc) == 0 || (iVar1 != 0)))) {
    *param_2 = '\0';
    *param_3 = '\0';
    *param_4 = 0;
    if ((*(uint *)(param_1 + 0x24) & 3) != 0) {
      if (*(int *)(iVar2 + 0x12) == 0) {
        return 0xffffffce;
      }
      if (**(char **)(iVar2 + 0x12) == '\0') {
        return 0xffffffce;
      }
      if (0x3f < **(byte **)(iVar2 + 0x12)) {
        return 0xffffffce;
      }
      *param_4 = 1;
    }
    if ((*(uint *)(param_1 + 0x24) & 4) == 0) {
      *param_3 = '\x01';
      *param_2 = '\x01';
    }
    else {
      if ((*(byte *)(iVar1 + 0x1e) & 0xee) != 0) {
        return 0xffffffce;
      }
      if ((*(byte *)(iVar1 + 0x1e) & 0x10) == 0) {
        *param_3 = '\x01';
        *param_2 = '\x01';
      }
      else if ((*(byte *)(iVar2 + 0x1e) & 0x10) == 0) {
        *param_2 = '\x01';
      }
      else {
        *param_3 = '\x01';
      }
    }
    if (((((*param_3 == '\0') || ((*(uint *)(param_1 + 0x24) & 4) == 0)) ||
         ((*(byte *)(iVar1 + 0x1e) & 1) == 0)) &&
        ((*param_2 == '\0' || ((*(uint *)(param_1 + 0x24) & 0x10) == 0)))) &&
       ((*param_3 == '\0' || ((*(uint *)(param_1 + 0x24) & 0x1e0) == 0)))) {
      return 0;
    }
  }
  return 0xffffffce;
}

