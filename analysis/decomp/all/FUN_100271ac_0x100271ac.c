
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100271ac(void)

{
  undefined4 uVar1;
  int *piVar2;
  int local_3c;
  
  .glue::GetPort(&DAT_1003b6d8);
  uVar1 = .glue::GetGDevice();
  *(undefined4 *)(local_3c + 0x7564) = uVar1;
  piVar2 = *(int **)(**(int **)(local_3c + 0x7564) + 0x16);
  _DAT_1003ad10 =
       FUN_10000ae8(local_3c + 0x7584,8,*(undefined4 *)(*piVar2 + 0x2a),&DAT_1003b6e0,
                    local_3c + 0x756c);
  if (_DAT_1003ad10 != 0) {
    FUN_100192f8(7);
  }
  *(undefined4 *)(local_3c + 0x70e8) = *(undefined4 *)**(undefined4 **)(_DAT_1003b6e0 + 2);
  *(uint *)(local_3c + 0x70e4) = (int)*(short *)(**(int **)(_DAT_1003b6e0 + 2) + 4) & 0x7fff;
  if (*(char *)(local_3c + 0x523c) != '\0') {
    _DAT_1003ad10 =
         FUN_10000ae8(local_3c + 0x7584,8,*(undefined4 *)(*piVar2 + 0x2a),&DAT_1003ad54,
                      local_3c + 0x6be0);
    if (_DAT_1003ad10 == 0) {
      *(undefined4 *)(local_3c + 0x6bdc) = *(undefined4 *)**(undefined4 **)(_DAT_1003ad54 + 2);
      *(uint *)(local_3c + 0x6bd8) = (int)*(short *)(**(int **)(_DAT_1003ad54 + 2) + 4) & 0x7fff;
    }
    else {
      *(undefined1 *)(local_3c + 0x523c) = 0;
      *(undefined1 *)(local_3c + 0x342e) = 0;
    }
  }
  return;
}

