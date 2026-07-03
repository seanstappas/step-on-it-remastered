
void FUN_10019f70(short param_1,short param_2,undefined4 *param_3,undefined4 *param_4,int param_5)

{
  byte bVar1;
  undefined1 uVar2;
  undefined1 *puVar3;
  short sVar4;
  undefined4 *local_a0;
  byte *local_9c;
  byte *local_98;
  byte *local_94;
  byte *local_90;
  short local_86;
  undefined4 *local_82;
  byte *local_7e;
  byte *local_7a;
  byte *local_76;
  byte *local_6a;
  byte *local_66;
  byte *local_5a;
  
  if (param_2 == 0) {
    for (sVar4 = 0; sVar4 < param_1; sVar4 = sVar4 + 1) {
      *param_4 = 0x80808080;
      param_4[1] = 0x80808080;
      param_4 = param_4 + 2;
    }
  }
  else if (param_2 == 1) {
    local_5a = (byte *)*param_3;
    for (sVar4 = 0; sVar4 < (short)((int)param_1 << 2); sVar4 = sVar4 + 1) {
      bVar1 = *local_5a;
      local_5a = local_5a + 1;
      uVar2 = *(undefined1 *)(param_5 + (short)(bVar1 + 0x180));
      *(undefined1 *)param_4 = uVar2;
      *(undefined1 *)((int)param_4 + 1) = uVar2;
      param_4 = (undefined4 *)((int)param_4 + 2);
    }
  }
  else if (param_2 == 2) {
    local_6a = (byte *)param_3[1];
    local_66 = (byte *)*param_3;
    for (sVar4 = 0; sVar4 < (short)((int)param_1 << 2); sVar4 = sVar4 + 1) {
      uVar2 = *(undefined1 *)(param_5 + (short)(*local_66 + 0x100 + (ushort)*local_6a));
      *(undefined1 *)param_4 = uVar2;
      *(undefined1 *)((int)param_4 + 1) = uVar2;
      param_4 = (undefined4 *)((int)param_4 + 2);
      local_6a = local_6a + 1;
      local_66 = local_66 + 1;
    }
  }
  else if (param_2 == 3) {
    local_82 = param_4;
    local_7e = (byte *)param_3[2];
    local_7a = (byte *)param_3[1];
    local_76 = (byte *)*param_3;
    for (sVar4 = 0; sVar4 < (short)((int)param_1 << 2); sVar4 = sVar4 + 1) {
      puVar3 = (undefined1 *)((int)local_82 + 1);
      uVar2 = *(undefined1 *)
               (param_5 + (short)(*local_76 + 0x80 + (ushort)*local_7a + (ushort)*local_7e));
      *(undefined1 *)local_82 = uVar2;
      local_82 = (undefined4 *)((int)local_82 + 2);
      *puVar3 = uVar2;
      local_7e = local_7e + 1;
      local_7a = local_7a + 1;
      local_76 = local_76 + 1;
    }
  }
  else if (param_2 == 4) {
    local_86 = 0;
    local_a0 = param_4;
    local_9c = (byte *)param_3[3];
    local_98 = (byte *)param_3[2];
    local_94 = (byte *)param_3[1];
    local_90 = (byte *)*param_3;
    while (local_86 < (short)((int)param_1 << 2)) {
      uVar2 = *(undefined1 *)
               (param_5 +
               (short)((ushort)*local_90 + (ushort)*local_94 + (ushort)*local_98 + (ushort)*local_9c
                      ));
      puVar3 = (undefined1 *)((int)local_a0 + 1);
      local_86 = local_86 + 1;
      *(undefined1 *)local_a0 = uVar2;
      local_a0 = (undefined4 *)((int)local_a0 + 2);
      *puVar3 = uVar2;
      local_9c = local_9c + 1;
      local_98 = local_98 + 1;
      local_94 = local_94 + 1;
      local_90 = local_90 + 1;
    }
  }
  return;
}

