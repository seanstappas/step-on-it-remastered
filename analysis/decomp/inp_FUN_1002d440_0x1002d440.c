/* FUN_1002d440 @ 0x1002d440 */

void FUN_1002d440(void)

{
  undefined **ppuVar1;
  char cVar2;
  short sVar3;
  undefined **local_5c;
  undefined1 auStack_38 [16];
  undefined1 local_28;
  
  ppuVar1 = &_toc;
  if (DAT_100393ad != '\0') {
    local_28 = .glue::WaitNextEvent(0xffff,auStack_38,1,0);
    ppuVar1 = local_5c;
  }
  .glue::GetKeys(ppuVar1 + 0x1d63);
  *(undefined1 *)((int)local_5c + 0x6992) = 0;
  *(undefined1 *)((int)local_5c + 0x6993) = 0;
  uRam1003aa40 = 0;
  uRam1003aa41 = 0;
  uRam1003aa42 = 0;
  uRam1003aa44 = 0;
  uRam1003aa43 = 0;
  uRam1003aa3e = 0;
  uRam1003aa3f = 0;
  uRam1003aab0 = 0;
  uRam1003aab1 = 0;
  uRam1003aab2 = 0;
  uRam1003aab4 = 0;
  uRam1003aab3 = 0;
  uRam1003aaae = 0;
  uRam1003aaaf = 0;
  cVar2 = FUN_1002d388(0x3700);
  if (cVar2 != '\0') {
    cVar2 = FUN_1002d388(0xc00);
    if (cVar2 != '\0') {
      *(undefined1 *)(local_5c + 0x1a64) = 1;
      *(undefined1 *)((int)local_5c + 0x5263) = 1;
      FUN_1002d41c();
    }
    cVar2 = FUN_1002d388(local_5c[0xbdf]);
    if (cVar2 != '\0') {
      *(undefined1 *)((int)local_5c + 0x6993) = 1;
      FUN_1002d41c();
    }
    cVar2 = FUN_1002d388(local_5c[0xbe0]);
    if (cVar2 != '\0') {
      *(undefined1 *)((int)local_5c + 0x6992) = 1;
      FUN_1002d41c();
    }
    cVar2 = FUN_1002d388(local_5c[0xbde]);
    if (cVar2 == '\0') {
      *(undefined1 *)(local_5c + 0x1a65) = 0;
    }
    else {
      *(undefined1 *)(local_5c + 0x1a65) = 1;
      FUN_1002d41c();
    }
    cVar2 = FUN_1002d388(0x100);
    if (cVar2 != '\0') {
      cVar2 = FUN_10020f00();
      if (cVar2 != '\0') {
        FUN_1002b020(0x2f,100);
      }
      FUN_1002d41c();
    }
  }
  for (sVar3 = 1; sVar3 < 3; sVar3 = sVar3 + 1) {
    cVar2 = FUN_1002d388(*(undefined4 *)(&DAT_1003ab06 + sVar3 * 0x1c));
    if (cVar2 != '\0') {
      *(undefined1 *)(sVar3 * 0x70 + 0x1003a9cf) = 1;
    }
    cVar2 = FUN_1002d388(*(undefined4 *)(sVar3 * 0x1c + 0x1003ab0a));
    if (cVar2 != '\0') {
      *(undefined1 *)(sVar3 * 0x70 + 0x1003a9ce) = 1;
    }
    cVar2 = FUN_1002d388(*(undefined4 *)(sVar3 * 0x1c + 0x1003ab1e));
    if (cVar2 == '\0') {
      *(undefined1 *)(sVar3 * 6 + 0x1003ab5e) = 0;
    }
    else {
      if (*(char *)(sVar3 * 6 + 0x1003ab5e) == '\0') {
        *(undefined1 *)(sVar3 * 0x70 + 0x1003a9d3) = 1;
      }
      *(undefined1 *)(sVar3 * 6 + 0x1003ab5e) = 1;
    }
    cVar2 = FUN_1002d388(*(undefined4 *)(sVar3 * 0x1c + 0x1003ab1a));
    if (cVar2 == '\0') {
      *(undefined1 *)(sVar3 * 6 + 0x1003ab5d) = 0;
    }
    else {
      if (*(char *)(sVar3 * 6 + 0x1003ab5d) == '\0') {
        *(undefined1 *)(sVar3 * 0x70 + 0x1003a9d4) = 1;
      }
      *(undefined1 *)(sVar3 * 6 + 0x1003ab5d) = 1;
    }
    cVar2 = FUN_1002d388(*(undefined4 *)(sVar3 * 0x1c + 0x1003ab16));
    if (cVar2 == '\0') {
      *(undefined1 *)(sVar3 * 6 + 0x1003ab5c) = 0;
    }
    else {
      if (*(char *)(sVar3 * 6 + 0x1003ab5c) == '\0') {
        *(undefined1 *)(sVar3 * 0x70 + 0x1003a9d2) = 1;
      }
      *(undefined1 *)(sVar3 * 6 + 0x1003ab5c) = 1;
    }
    cVar2 = FUN_1002d388(*(undefined4 *)(sVar3 * 0x1c + 0x1003ab12));
    if (cVar2 == '\0') {
      *(undefined1 *)(sVar3 * 6 + 0x1003ab5b) = 0;
    }
    else {
      if (*(char *)(sVar3 * 6 + 0x1003ab5b) == '\0') {
        *(undefined1 *)(sVar3 * 0x70 + 0x1003a9d1) = 1;
      }
      *(undefined1 *)(sVar3 * 6 + 0x1003ab5b) = 1;
    }
    cVar2 = FUN_1002d388(*(undefined4 *)(sVar3 * 0x1c + 0x1003ab0e));
    if (cVar2 == '\0') {
      (&DAT_1003ab5a)[sVar3 * 6] = 0;
    }
    else {
      if ((&DAT_1003ab5a)[sVar3 * 6] == '\0') {
        *(undefined1 *)(sVar3 * 0x70 + 0x1003a9d0) = 1;
      }
      *(undefined1 *)(sVar3 * 0x70 + 0x1003a9d0) = 1;
      (&DAT_1003ab5a)[sVar3 * 6] = 1;
    }
  }
  cVar2 = FUN_1002d388(local_5c[0xbe2]);
  if (cVar2 != '\0') {
    *(undefined1 *)((int)local_5c + 0x6991) = 1;
  }
  cVar2 = FUN_1002d388(local_5c[0xbe3]);
  if (cVar2 != '\0') {
    *(undefined1 *)(local_5c + 0x1a64) = 1;
  }
  cVar2 = FUN_1002d388(local_5c[0xbe1]);
  if (cVar2 != '\0') {
    *(undefined1 *)(local_5c + 0x1498) = 1;
  }
  return;
}

