
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10003a0c(short param_1,short param_2)

{
  int iVar1;
  int iVar2;
  
  iVar1 = param_1 * 0x14;
  iVar2 = param_2 * 0x14;
  if ((((*(short *)(iVar1 + 0x100378aa) <= *(short *)(iVar2 + 0x100378ae)) &&
       (*(short *)(iVar2 + 0x100378aa) <= *(short *)(iVar1 + 0x100378ae))) &&
      (*(short *)(iVar2 + 0x100378ac) <= *(short *)(iVar1 + 0x100378b0))) &&
     (*(short *)(iVar1 + 0x100378ac) <= *(short *)(iVar2 + 0x100378b0))) {
    if (*(char *)(*(short *)(&DAT_1003789e + param_1 * 0x14) * 0x46 + 0x10037e69) == '\0') {
      *(undefined1 *)(*(short *)(&DAT_1003789e + param_1 * 0x14) * 0x46 + 0x10037e69) = 1;
      iVar1 = (int)_DAT_10037524;
      _DAT_10037524 = _DAT_10037524 + 1;
      *(short *)(&DAT_10037526 + iVar1 * 2) = param_1;
    }
    if (*(char *)(*(short *)(&DAT_1003789e + param_2 * 0x14) * 0x46 + 0x10037e69) == '\0') {
      *(undefined1 *)(*(short *)(&DAT_1003789e + param_2 * 0x14) * 0x46 + 0x10037e69) = 1;
      iVar1 = (int)_DAT_10037524;
      _DAT_10037524 = _DAT_10037524 + 1;
      *(short *)(&DAT_10037526 + iVar1 * 2) = param_2;
    }
  }
  return;
}

