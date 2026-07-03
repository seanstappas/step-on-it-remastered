
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10017cd8(void)

{
  short sVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  undefined4 uVar7;
  undefined4 uVar8;
  undefined4 uVar9;
  undefined4 uVar10;
  undefined4 uVar11;
  undefined4 uVar12;
  undefined4 uVar13;
  undefined4 uVar14;
  undefined4 uVar15;
  undefined4 uVar16;
  undefined4 uVar17;
  undefined4 uVar18;
  short sVar19;
  
  sVar19 = _DAT_1003a36a;
  do {
    uVar18 = _DAT_1003ad14;
    uVar17 = _DAT_1003a360;
    uVar16 = uRam1003a35c;
    uVar15 = uRam1003a354;
    uVar14 = uRam1003a350;
    uVar13 = uRam1003a34c;
    uVar12 = uRam1003a348;
    uVar11 = uRam1003a344;
    uVar10 = uRam1003a340;
    uVar9 = uRam1003a33c;
    uVar8 = uRam1003a338;
    uVar7 = uRam1003a330;
    uVar6 = uRam1003a32c;
    uVar5 = uRam1003a328;
    uVar4 = uRam1003a324;
    uVar3 = uRam1003a31c;
    uVar2 = uRam1003a318;
    if (sVar19 == 0) {
      return;
    }
    sVar1 = *(short *)(sVar19 * 0x46 + 0x10037e4a);
    if (sVar1 == 0x65) {
LAB_10017e04:
      *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a318;
      *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar2;
    }
    else if (sVar1 < 0x65) {
      if (sVar1 == 0xb) {
LAB_10017e7c:
        *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a340;
        *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar10;
      }
      else if (sVar1 < 0xb) {
        if (sVar1 == 5) {
LAB_10017ea4:
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a328;
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar5;
        }
        else if (sVar1 < 5) {
          if (sVar1 == 1) goto LAB_10017e04;
          if (0 < sVar1) {
            if (3 < sVar1) goto LAB_10017f94;
            *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a31c;
            *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar3;
          }
        }
        else if (sVar1 == 9) {
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a338;
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar8;
        }
        else {
          if (8 < sVar1) goto LAB_10017e2c;
          if (sVar1 < 7) goto LAB_10017f1c;
LAB_10017f6c:
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a330;
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar7;
        }
      }
      else if (sVar1 == 0xf) {
        *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a350;
        *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar14;
      }
      else if (sVar1 < 0xf) {
        if (sVar1 == 0xd) {
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a348;
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar12;
        }
        else {
          if (sVar1 < 0xd) goto LAB_10017e54;
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a34c;
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar13;
        }
      }
      else {
        if (sVar1 == 0x13) goto LAB_10017ef4;
        if (sVar1 < 0x13) {
          if (0x11 < sVar1) goto LAB_10017ecc;
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a354;
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar15;
        }
      }
    }
    else if (sVar1 == 0x70) {
LAB_10017e54:
      *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a344;
      *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar11;
    }
    else if (sVar1 < 0x70) {
      if (sVar1 == 0x6a) {
LAB_10017f1c:
        *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a32c;
        *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar6;
      }
      else if (sVar1 < 0x6a) {
        if (sVar1 == 0x68) {
LAB_10017f94:
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a324;
          *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar4;
        }
        else if (0x67 < sVar1) goto LAB_10017ea4;
      }
      else if (sVar1 == 0x6e) {
LAB_10017e2c:
        *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a33c;
        *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar9;
      }
      else {
        if (0x6d < sVar1) goto LAB_10017e7c;
        if (sVar1 < 0x6d) goto LAB_10017f6c;
      }
    }
    else if (sVar1 == 0x77) {
LAB_10017ef4:
      *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = _DAT_1003a360;
      *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar17;
    }
    else if (sVar1 < 0x77) {
      if (sVar1 < 0x76) {
        if (sVar1 < 0x73) goto LAB_1001805c;
      }
      else {
LAB_10017ecc:
        *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = uRam1003a35c;
        *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar16;
      }
    }
    else if (sVar1 == 200) {
LAB_1001805c:
      *(undefined4 *)(sVar19 * 0x46 + 0x10037e52) = _DAT_1003ad14;
      *(undefined4 *)(sVar19 * 0x46 + 0x10037e5c) = uVar18;
    }
    sVar19 = *(short *)(sVar19 * 0x46 + 0x10037e86);
  } while( true );
}

