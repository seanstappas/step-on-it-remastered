
undefined4 .debug::_PBCatSearchSyncCompat(int param_1)

{
  undefined **ppuVar1;
  short sVar2;
  bool bVar3;
  undefined4 uVar4;
  undefined **local_5c;
  undefined4 local_38;
  undefined1 auStack_34 [2];
  uint local_32;
  uint local_20 [5];
  
  uVar4 = 0;
  ppuVar1 = &_toc;
  if (DAT_10034162 == '\0') {
    DAT_10034162 = '\x01';
    sVar2 = .glue::Gestalt(0x66732020,local_20);
    ppuVar1 = local_5c;
    if (sVar2 == 0) {
      *(bool *)(local_5c + -4) = (local_20[0] & 1) != 0;
    }
  }
  bVar3 = false;
  if (*(char *)(ppuVar1 + -4) != '\0') {
    local_38 = 0x14;
    uVar4 = _HGetVolParms(*(undefined4 *)(param_1 + 0x12),(int)*(short *)(param_1 + 0x16),auStack_34
                          ,&local_38);
    if ((short)uVar4 == 0) {
      bVar3 = (local_32 & 0x80) != 0;
    }
  }
  if (((short)uVar4 == 0) || ((short)uVar4 == -0x32)) {
    if (bVar3) {
      uVar4 = .glue::PBCatSearchSync(param_1);
    }
    else {
      uVar4 = _IndexedSearch(param_1,2);
    }
  }
  return uVar4;
}

