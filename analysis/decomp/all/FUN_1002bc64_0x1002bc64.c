
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002bc64(undefined4 param_1)

{
  int iVar1;
  int iVar2;
  short sVar7;
  short sVar8;
  int iVar3;
  int iVar4;
  undefined4 uVar5;
  undefined4 uVar6;
  ushort uVar10;
  uint uVar9;
  short sVar11;
  bool bVar12;
  short sVar13;
  short sVar14;
  
  uVar5 = param_1;
  if (DAT_100370e4 == '\0') {
    uVar5 = 1;
  }
  sVar14 = (short)param_1;
  iVar1 = FUN_1002e6cc(*(short *)(&DAT_1003a9b0 + sVar14 * 0x70) + 0xc);
  iVar2 = FUN_1002e6f8(*(short *)(sVar14 * 0x70 + 0x1003a9b4) + 0x10);
  sVar7 = FUN_1002e6cc(*(short *)(sVar14 * 0x70 + 0x1003a9c2) + 0xc);
  sVar8 = FUN_1002e6f8(*(short *)(sVar14 * 0x70 + 0x1003a9c6) + 0x10);
  sVar13 = (short)iVar1;
  sVar11 = (short)iVar2;
  if ((sVar13 == sVar7) && (sVar11 == sVar8)) {
    bVar12 = false;
  }
  else {
    bVar12 = true;
  }
  iVar3 = FUN_1002e6ac(iVar1);
  iVar4 = FUN_1002e6bc(iVar2);
  uVar9 = *(uint *)(&DAT_1003ad68 + sVar13 * 0x3c + sVar11 * 4) & 0xff;
  uVar10 = (ushort)uVar9;
  if (uVar10 != 0) {
    if ((0x19 < uVar10) && (uVar10 < 0x23)) {
      sVar7 = FUN_1002e6cc(*(short *)(&DAT_1003a9b0 + sVar14 * 0x70) + 0xc);
      sVar8 = FUN_1002e6cc(*(short *)(&DAT_1003a9b0 + sVar14 * 0x70) + 0x12);
      if (sVar8 != sVar7) {
        return;
      }
    }
    if ((*(uint *)(&DAT_1003ad68 + sVar13 * 0x3c + sVar11 * 4) & 0x800) != 0) {
      if (uVar10 < 4) {
        sVar7 = FUN_1002e6f8((int)*(short *)(sVar14 * 0x70 + 0x1003a9b4));
        if ((sVar11 == sVar7) && (((int)(short)uVar10 == sVar14 + 1 || (uVar10 == 1)))) {
          *(undefined1 *)(sVar14 * 0x70 + 0x1003a9d9) = 1;
          FUN_10018a18(param_1);
          FUN_1002b020(0x27,10);
        }
      }
      else if (6 < uVar10) {
        if ((uVar10 < 10) && (6 < uVar10)) {
          if (((int)(short)uVar10 == sVar14 + 7) || (uVar10 == 7)) {
            FUN_1002b020(0x14,10);
            FUN_10004090(_DAT_1003ad2c,uVar9,iVar3,iVar4);
            FUN_100278bc(_DAT_1003ad2c,uVar9,iVar3,iVar4,0,0xffffffb0,1);
            iVar1 = sVar13 * 0x3c + sVar11 * 4;
            *(uint *)(&DAT_1003ad68 + iVar1) = *(uint *)(&DAT_1003ad68 + iVar1) & 0xffff1000;
            if (DAT_1003ab6c == '\0') {
              uRam1003aa47 = 1;
              uRam1003aab7 = 1;
            }
            else {
              *(undefined1 *)(sVar14 * 0x70 + 0x1003a9d7) = 1;
            }
            for (iVar1 = 1; sVar7 = (short)iVar1, sVar7 < 0x14; iVar1 = iVar1 + 1) {
              for (iVar2 = 1; sVar8 = (short)iVar2, sVar8 < 0xe; iVar2 = iVar2 + 1) {
                uVar9 = *(uint *)(&DAT_1003ad68 + sVar7 * 0x3c + sVar8 * 4) & 0xff;
                if (((short)uVar9 + 3 == (int)(short)uVar10) &&
                   ((*(uint *)(&DAT_1003ad68 + sVar7 * 0x3c + sVar8 * 4) & 0x800) != 0)) {
                  uVar5 = FUN_1002e6bc(iVar2);
                  uVar6 = FUN_1002e6ac(iVar1);
                  FUN_10004090(_DAT_1003ad2c,uVar9,uVar6,uVar5);
                  uVar5 = FUN_1002e6bc(iVar2);
                  uVar6 = FUN_1002e6ac(iVar1);
                  FUN_10004108(_DAT_1003ad2c,uVar9 - 3,uVar6,uVar5);
                  *(int *)(&DAT_1003ad68 + sVar7 * 0x3c + sVar8 * 4) = (short)uVar9 + 0x8fd;
                }
              }
            }
          }
        }
        else if ((uVar10 < 0x1a) || (0x2d < uVar10)) {
          if (uVar10 == 0xff) {
            FUN_10004090(_DAT_1003ad14,0x10,iVar3 + 4,iVar4 + 4);
            uVar9 = *(int *)(&DAT_1003ad68 + sVar13 * 0x3c + sVar11 * 4) >> 0x10;
            FUN_100278bc(_DAT_1003ad2c,uVar9,iVar3,iVar4,0,0xffffffb0,1);
            *(undefined4 *)(&DAT_1003ad68 + sVar13 * 0x3c + sVar11 * 4) = 0;
          }
          else {
            FUN_10004090(_DAT_1003ad2c,uVar9,iVar3,iVar4);
            FUN_100278bc(_DAT_1003ad2c,uVar9,iVar3,iVar4,0,0xffffffb0,1);
          }
          sVar8 = (short)uVar9;
          sVar7 = (short)uVar5;
          if (sVar8 == 10) {
            FUN_1002b020(0x15,10);
            *(int *)(sVar7 * 0x70 + 0x1003a9ec) = *(int *)(sVar7 * 0x70 + 0x1003a9ec) + 500;
            _DAT_10038fea = _DAT_10038fea + 1;
          }
          else if (sVar8 == 0xb) {
            FUN_1002b020(0x16,10);
          }
          else if ((sVar8 < 0xc) || (0xf < sVar8)) {
            if (sVar8 == 0x10) {
              FUN_1002b020(0x18,10);
              FUN_1000e9c8(uVar5,1);
            }
            else if (sVar8 == 0x11) {
              FUN_1002b020(0x19,10);
              FUN_1000eb34(uVar5,1);
            }
            else if (sVar8 == 0x12) {
              FUN_1002b020(0x1a,10);
              FUN_1000ec50(uVar5,1);
            }
            else if ((sVar8 < 0x13) || (0x16 < sVar8)) {
              if (sVar8 == 0x17) {
                FUN_1002b020(0x1c,10);
                *(int *)(sVar7 * 0x70 + 0x1003a9ec) = *(int *)(sVar7 * 0x70 + 0x1003a9ec) + 1000;
                _DAT_10038fe8 = _DAT_10038fe8 + 1;
              }
              else if (sVar8 == 0x18) {
                FUN_1002b020(0x1d,10);
                *(int *)(sVar7 * 0x70 + 0x1003a9ec) = *(int *)(sVar7 * 0x70 + 0x1003a9ec) + 2000;
                _DAT_10038fe6 = _DAT_10038fe6 + 1;
              }
              else if (sVar8 == 0x19) {
                FUN_1002b020(0x1e,10);
                *(int *)(sVar7 * 0x70 + 0x1003a9ec) = *(int *)(sVar7 * 0x70 + 0x1003a9ec) + 5000;
                _DAT_10038fe4 = _DAT_10038fe4 + 1;
              }
              else if (sVar8 == 0x2e) {
                FUN_1002b020(0x2b,10);
                _DAT_1003b294 = 600;
              }
            }
            else {
              FUN_1002b020(0x1b,10);
              FUN_1000f3f0(uVar5,(uVar9 - 0x12) * 0x9c4);
            }
          }
          else {
            FUN_1002b020(0x17,10);
            FUN_10011428(uVar5,uVar9 - 10);
          }
          if (sVar8 == 0x2f) {
            FUN_1002b020(0x26,10);
            FUN_10016b28();
          }
          else if (sVar8 == 0x30) {
            FUN_1002b020(0x29,10);
            FUN_10014c28(param_1);
          }
          else if (sVar8 == 0x31) {
            FUN_1002b020(0x2a,10);
            FUN_1000543c(param_1);
          }
          else if (sVar8 == 0x32) {
            FUN_1002b020(0x28,10);
            FUN_10014ccc(param_1);
          }
          iVar1 = sVar13 * 0x3c + sVar11 * 4;
          *(uint *)(&DAT_1003ad68 + iVar1) = *(uint *)(&DAT_1003ad68 + iVar1) & 0xffff1000;
        }
        else if (uVar10 < 0x24) {
          if (uVar10 == 0x1a) {
            bVar12 = false;
            iVar3 = 1;
            while ((sVar7 = (short)iVar3, sVar7 < 0x14 && (!bVar12))) {
              iVar4 = 1;
              while (((short)iVar4 < 0xe && (!bVar12))) {
                if ((*(uint *)(&DAT_1003ad68 + sVar7 * 0x3c + (short)iVar4 * 4) & 0xff) == 0x1b) {
                  bVar12 = true;
                  FUN_1002b9bc(param_1,(int)*(short *)(&DAT_1003a9b0 + sVar14 * 0x70) +
                                       (iVar3 - iVar1) * 0x20,
                               (int)*(short *)(sVar14 * 0x70 + 0x1003a9b4) + (iVar4 - iVar2) * 0x20)
                  ;
                  *(short *)(&DAT_1003a9b0 + sVar14 * 0x70) =
                       *(short *)(&DAT_1003a9b0 + sVar14 * 0x70) + (short)(iVar3 - iVar1) * 0x20;
                  *(short *)(sVar14 * 0x70 + 0x1003a9b2) =
                       *(short *)(sVar14 * 0x70 + 0x1003a9b2) + (sVar7 - sVar13) * 0x20;
                  *(short *)(sVar14 * 0x70 + 0x1003a9b4) =
                       *(short *)(sVar14 * 0x70 + 0x1003a9b4) + (short)(iVar4 - iVar2) * 0x20;
                }
                iVar4 = iVar4 + 1;
              }
              iVar3 = iVar3 + 1;
            }
          }
          else if (uVar10 == 0x1c) {
            bVar12 = false;
            iVar3 = 1;
            while ((sVar7 = (short)iVar3, sVar7 < 0x14 && (!bVar12))) {
              iVar4 = 1;
              while (((short)iVar4 < 0xe && (!bVar12))) {
                if ((*(uint *)(&DAT_1003ad68 + sVar7 * 0x3c + (short)iVar4 * 4) & 0xff) == 0x1d) {
                  bVar12 = true;
                  FUN_1002b9bc(param_1,(int)*(short *)(&DAT_1003a9b0 + sVar14 * 0x70) +
                                       (iVar3 - iVar1) * 0x20,
                               (int)*(short *)(sVar14 * 0x70 + 0x1003a9b4) + (iVar4 - iVar2) * 0x20)
                  ;
                  *(short *)(&DAT_1003a9b0 + sVar14 * 0x70) =
                       *(short *)(&DAT_1003a9b0 + sVar14 * 0x70) + (sVar7 - sVar13) * 0x20;
                  *(short *)(sVar14 * 0x70 + 0x1003a9b2) =
                       *(short *)(sVar14 * 0x70 + 0x1003a9b2) + (short)(iVar3 - iVar1) * 0x20;
                  *(short *)(sVar14 * 0x70 + 0x1003a9b4) =
                       *(short *)(sVar14 * 0x70 + 0x1003a9b4) + (short)(iVar4 - iVar2) * 0x20;
                }
                iVar4 = iVar4 + 1;
              }
              iVar3 = iVar3 + 1;
            }
          }
          else if (uVar10 == 0x1e) {
            bVar12 = false;
            iVar3 = 1;
            while ((sVar7 = (short)iVar3, sVar7 < 0x14 && (!bVar12))) {
              iVar4 = 1;
              while (((short)iVar4 < 0xe && (!bVar12))) {
                if ((*(uint *)(&DAT_1003ad68 + sVar7 * 0x3c + (short)iVar4 * 4) & 0xff) == 0x1f) {
                  bVar12 = true;
                  FUN_1002b9bc(param_1,(int)*(short *)(&DAT_1003a9b0 + sVar14 * 0x70) +
                                       (iVar3 - iVar1) * 0x20,
                               (int)*(short *)(sVar14 * 0x70 + 0x1003a9b4) + (iVar4 - iVar2) * 0x20)
                  ;
                  *(short *)(&DAT_1003a9b0 + sVar14 * 0x70) =
                       *(short *)(&DAT_1003a9b0 + sVar14 * 0x70) + (sVar7 - sVar13) * 0x20;
                  *(short *)(sVar14 * 0x70 + 0x1003a9b2) =
                       *(short *)(sVar14 * 0x70 + 0x1003a9b2) + (short)(iVar3 - iVar1) * 0x20;
                  *(short *)(sVar14 * 0x70 + 0x1003a9b4) =
                       *(short *)(sVar14 * 0x70 + 0x1003a9b4) + (short)(iVar4 - iVar2) * 0x20;
                }
                iVar4 = iVar4 + 1;
              }
              iVar3 = iVar3 + 1;
            }
          }
          else if (uVar10 == 0x20) {
            bVar12 = false;
            iVar3 = 1;
            while ((sVar7 = (short)iVar3, sVar7 < 0x14 && (!bVar12))) {
              iVar4 = 1;
              while (((short)iVar4 < 0xe && (!bVar12))) {
                if ((*(uint *)(&DAT_1003ad68 + sVar7 * 0x3c + (short)iVar4 * 4) & 0xff) == 0x21) {
                  bVar12 = true;
                  FUN_1002b9bc(param_1,(int)*(short *)(&DAT_1003a9b0 + sVar14 * 0x70) +
                                       (iVar3 - iVar1) * 0x20,
                               (int)*(short *)(sVar14 * 0x70 + 0x1003a9b4) + (iVar4 - iVar2) * 0x20)
                  ;
                  *(short *)(&DAT_1003a9b0 + sVar14 * 0x70) =
                       *(short *)(&DAT_1003a9b0 + sVar14 * 0x70) + (sVar7 - sVar13) * 0x20;
                  *(short *)(sVar14 * 0x70 + 0x1003a9b2) =
                       *(short *)(sVar14 * 0x70 + 0x1003a9b2) + (short)(iVar3 - iVar1) * 0x20;
                  *(short *)(sVar14 * 0x70 + 0x1003a9b4) =
                       *(short *)(sVar14 * 0x70 + 0x1003a9b4) + (short)(iVar4 - iVar2) * 0x20;
                }
                iVar4 = iVar4 + 1;
              }
              iVar3 = iVar3 + 1;
            }
          }
          else if (uVar10 == 0x22) {
            bVar12 = false;
            iVar3 = 1;
            while ((sVar7 = (short)iVar3, sVar7 < 0x14 && (!bVar12))) {
              iVar4 = 1;
              while (((short)iVar4 < 0xe && (!bVar12))) {
                if ((*(uint *)(&DAT_1003ad68 + sVar7 * 0x3c + (short)iVar4 * 4) & 0xff) == 0x23) {
                  bVar12 = true;
                  FUN_1002b9bc(param_1,(int)*(short *)(&DAT_1003a9b0 + sVar14 * 0x70) +
                                       (iVar3 - iVar1) * 0x20,
                               (int)*(short *)(sVar14 * 0x70 + 0x1003a9b4) + (iVar4 - iVar2) * 0x20)
                  ;
                  *(short *)(&DAT_1003a9b0 + sVar14 * 0x70) =
                       *(short *)(&DAT_1003a9b0 + sVar14 * 0x70) + (short)(iVar3 - iVar1) * 0x20;
                  *(short *)(sVar14 * 0x70 + 0x1003a9b2) =
                       *(short *)(sVar14 * 0x70 + 0x1003a9b2) + (sVar7 - sVar13) * 0x20;
                  *(short *)(sVar14 * 0x70 + 0x1003a9b4) =
                       *(short *)(sVar14 * 0x70 + 0x1003a9b4) + (short)(iVar4 - iVar2) * 0x20;
                }
                iVar4 = iVar4 + 1;
              }
              iVar3 = iVar3 + 1;
            }
          }
        }
        else if (bVar12) {
          FUN_10016544(uVar9,iVar1,iVar2);
          FUN_1002b020(0x2c,10);
        }
      }
    }
  }
  return;
}

