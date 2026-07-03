
void FUN_10001b70(undefined4 *param_1,undefined4 param_2,short param_3,int param_4,
                 undefined4 param_5,short param_6,int param_7,int param_8)

{
  short sVar1;
  short sVar2;
  short sVar3;
  short sVar4;
  short sVar5;
  int iVar6;
  short sVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  short *psVar11;
  short sVar13;
  int iVar12;
  short sVar15;
  int iVar14;
  short sVar16;
  int iVar17;
  short sStack00000022;
  short sStack0000002e;
  short in_stack_0000003a;
  int in_stack_0000003c;
  short in_stack_00000042;
  int local_58;
  int *local_54;
  int local_50;
  int local_4c;
  int local_48;
  int *local_44;
  int local_40;
  undefined2 local_3c [6];
  
  sVar7 = in_stack_00000042;
  iVar6 = in_stack_0000003c;
  sVar5 = in_stack_0000003a;
  iVar10 = (int)(short)param_5;
  psVar11 = (short *)*param_1;
  if ((((0 < iVar10) && (iVar10 <= *psVar11)) && (iVar8 = (int)(short)param_2, 0 < iVar8)) &&
     (iVar8 <= *psVar11)) {
    sVar1 = *(short *)((int)psVar11 + *(int *)(psVar11 + iVar8 * 2 + 4));
    iVar17 = (int)sVar1;
    sVar2 = ((short *)((int)psVar11 + *(int *)(psVar11 + iVar8 * 2 + 4)))[1];
    sVar3 = *(short *)((int)psVar11 + *(int *)(psVar11 + iVar10 * 2 + 4));
    sVar4 = ((short *)((int)psVar11 + *(int *)(psVar11 + iVar10 * 2 + 4)))[1];
    sStack00000022 = param_3;
    sStack0000002e = param_6;
    FUN_10001348(param_1,param_2,&stack0x00000022,&local_40);
    local_48 = local_40 + *(int *)(local_40 + 4);
    FUN_10001348(param_1,param_5,&stack0x0000002e,&local_44);
    sVar15 = (short)param_7;
    local_54 = local_44 + 2;
    sVar13 = (short)param_4;
    local_58 = (int)local_44 + *local_44;
    if (sVar13 < sVar15) {
      param_7 = param_7 - param_4;
    }
    else {
      param_7 = param_4 - param_7;
    }
    if (sStack00000022 < sStack0000002e) {
      sVar16 = sStack0000002e - sStack00000022;
    }
    else {
      sVar16 = sStack00000022 - sStack0000002e;
    }
    if (((sVar4 == sVar2) && (sVar3 == sVar1)) && ((short)param_7 <= sVar4)) {
      iVar8 = (int)sStack0000002e;
      iVar10 = (int)sStack00000022;
      if (sStack0000002e == iVar10) {
        iVar12 = (int)sVar15;
        iVar9 = (int)sVar13;
        if (iVar9 < iVar12) {
          iVar12 = (int)sVar7;
          iVar8 = (int)sVar5;
          local_50 = iVar6 + iVar10 + iVar9 * iVar12;
          local_4c = param_8 + iVar10 + iVar9 * iVar8;
          FUN_100026ac(&local_4c,iVar8,&local_50,iVar12,&local_48,param_7,iVar17);
          local_3c[0] = 0;
          FUN_10002770(&local_4c,iVar8,&local_50,iVar12,&local_54,&local_58,&local_48,local_3c);
          FUN_100024d8(&local_4c,iVar8,&local_50,iVar12,&local_54,&local_58,local_3c,param_7);
        }
        else if (iVar12 < iVar9) {
          iVar9 = (int)sVar7;
          iVar10 = (int)sVar5;
          local_50 = iVar6 + iVar8 + iVar12 * iVar9;
          local_4c = param_8 + iVar8 + iVar12 * iVar10;
          local_3c[0] = 0;
          FUN_100024d8(&local_4c,iVar10,&local_50,iVar9,&local_54,&local_58,local_3c,param_7);
          FUN_10002770(&local_4c,iVar10,&local_50,iVar9,&local_54,&local_58,&local_48,local_3c);
          FUN_100026ac(&local_4c,iVar10,&local_50,iVar9,&local_48,param_7,iVar17);
        }
        else {
          local_4c = param_8 + iVar8 + iVar12 * sVar5;
          local_50 = iVar6 + iVar8 + iVar12 * sVar7;
          local_3c[0] = 0;
          FUN_10002770(&local_4c,(int)sVar5,&local_50,(int)sVar7,&local_54,&local_58,&local_48,
                       local_3c);
        }
      }
      else if (iVar10 < sStack0000002e) {
        iVar9 = (int)sVar15;
        iVar12 = (int)sVar13;
        if (iVar12 < iVar9) {
          iVar9 = (int)sVar7;
          iVar8 = (int)sVar5;
          local_50 = iVar6 + iVar10 + iVar12 * iVar9;
          local_4c = param_8 + iVar10 + iVar12 * iVar8;
          FUN_100026ac(&local_4c,iVar8,&local_50,iVar9,&local_48,param_7,iVar17);
          local_3c[0] = 0;
          FUN_100029d4(&local_4c,iVar8,&local_50,iVar9,&local_54,&local_58,&local_48,local_3c);
          local_4c = local_4c + sVar16;
          local_50 = local_50 + sVar16;
          FUN_100024d8(&local_4c,iVar8,&local_50,iVar9,&local_54,&local_58,local_3c,param_7);
        }
        else if (iVar9 < iVar12) {
          iVar12 = (int)sVar7;
          iVar10 = (int)sVar5;
          local_50 = iVar6 + iVar8 + iVar9 * iVar12;
          local_4c = param_8 + iVar8 + iVar9 * iVar10;
          local_3c[0] = 0;
          FUN_100024d8(&local_4c,iVar10,&local_50,iVar12,&local_54,&local_58,local_3c,param_7);
          local_4c = local_4c - sVar16;
          local_50 = local_50 - sVar16;
          FUN_100029d4(&local_4c,iVar10,&local_50,iVar12,&local_54,&local_58,&local_48,local_3c);
          FUN_100026ac(&local_4c,iVar10,&local_50,iVar12,&local_48,param_7,iVar17);
        }
        else {
          local_4c = param_8 + iVar10 + iVar12 * sVar5;
          local_50 = iVar6 + iVar10 + iVar12 * sVar7;
          local_3c[0] = 0;
          FUN_100029d4(&local_4c,(int)sVar5,&local_50,(int)sVar7,&local_54,&local_58,&local_48,
                       local_3c);
        }
      }
      else {
        iVar12 = (int)sVar15;
        iVar9 = (int)sVar13;
        if (iVar9 < iVar12) {
          iVar12 = (int)sVar7;
          iVar8 = (int)sVar5;
          local_50 = iVar6 + iVar10 + iVar9 * iVar12;
          local_4c = param_8 + iVar10 + iVar9 * iVar8;
          FUN_100026ac(&local_4c,iVar8,&local_50,iVar12,&local_48,param_7,iVar17);
          local_4c = local_4c - sVar16;
          local_50 = local_50 - sVar16;
          local_3c[0] = 0;
          FUN_10002d58(&local_4c,iVar8,&local_50,iVar12,&local_54,&local_58,&local_48,local_3c);
          FUN_100024d8(&local_4c,iVar8,&local_50,iVar12,&local_54,&local_58,local_3c,param_7);
        }
        else if (iVar12 < iVar9) {
          iVar9 = (int)sVar7;
          iVar10 = (int)sVar5;
          local_50 = iVar6 + iVar8 + iVar12 * iVar9;
          local_4c = param_8 + iVar8 + iVar12 * iVar10;
          local_3c[0] = 0;
          FUN_100024d8(&local_4c,iVar10,&local_50,iVar9,&local_54,&local_58,local_3c,param_7);
          FUN_10002d58(&local_4c,iVar10,&local_50,iVar9,&local_54,&local_58,&local_48,local_3c);
          local_4c = local_4c + sVar16;
          local_50 = local_50 + sVar16;
          FUN_100026ac(&local_4c,iVar10,&local_50,iVar9,&local_48,param_7,iVar17);
        }
        else {
          local_4c = param_8 + iVar8 + iVar12 * sVar5;
          local_50 = iVar6 + iVar8 + iVar12 * sVar7;
          local_3c[0] = 0;
          FUN_10002d58(&local_4c,(int)sVar5,&local_50,(int)sVar7,&local_54,&local_58,&local_48,
                       local_3c);
        }
      }
    }
    else {
      iVar10 = (int)sVar13;
      iVar8 = (int)sVar15;
      if ((iVar8 <= iVar10 + sVar2) && (iVar10 <= iVar8 + sVar4)) {
        iVar9 = (int)sStack00000022;
        if (((int)sStack0000002e <= iVar9 + sVar1) && (iVar9 <= (int)sStack0000002e + (int)sVar3)) {
          iVar14 = (int)sVar7;
          iVar12 = (int)sVar5;
          local_50 = iVar6 + iVar9 + iVar10 * iVar14;
          local_4c = param_8 + iVar9 + iVar10 * iVar12;
          FUN_100026ac(&local_4c,iVar12,&local_50,iVar14,&local_48,(int)sVar2,iVar17);
          local_50 = iVar6 + (int)sStack0000002e + iVar8 * iVar14;
          local_4c = param_8 + (int)sStack0000002e + iVar8 * iVar12;
          local_3c[0] = 0;
          FUN_100024d8(&local_4c,iVar12,&local_50,iVar14,&local_54,&local_58,local_3c,(int)sVar4);
          return;
        }
      }
      iVar8 = (int)sVar7;
      iVar10 = (int)sVar5;
      local_50 = iVar6 + (int)sStack0000002e + sVar15 * iVar8;
      local_4c = param_8 + (int)sStack0000002e + sVar15 * iVar10;
      local_3c[0] = 0;
      FUN_100024d8(&local_4c,iVar10,&local_50,iVar8,&local_54,&local_58,local_3c,(int)sVar4);
      local_50 = iVar6 + (int)sStack00000022 + sVar13 * iVar8;
      local_4c = param_8 + (int)sStack00000022 + sVar13 * iVar10;
      FUN_100026ac(&local_4c,iVar10,&local_50,iVar8,&local_48,(int)sVar2,iVar17);
    }
  }
  return;
}

