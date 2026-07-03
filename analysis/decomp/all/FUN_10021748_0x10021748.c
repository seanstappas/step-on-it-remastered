
undefined4 FUN_10021748(int param_1)

{
  undefined4 uVar1;
  undefined2 uVar2;
  char cVar3;
  int local_3c;
  
  uVar1 = .glue::FSpOpenResFile(param_1,0);
  if ((short)uVar1 == -1) {
    *(undefined2 *)(local_3c + 0x712a) = 0;
    *(undefined2 *)(local_3c + 0x712c) = 0;
    .glue::Alert(0x19c,0);
    DAT_1003944c = 0;
    uVar1 = 0xffffffff;
  }
  else {
    uVar2 = FUN_10028788(uVar1,0x191);
    *(undefined2 *)(local_3c + 0x712c) = uVar2;
    uVar2 = FUN_10028788(uVar1,0x3e9);
    *(undefined2 *)(local_3c + 0x712a) = uVar2;
    FUN_10026fd8(param_1 + 6,local_3c + 0x6b5c);
    cVar3 = FUN_1002701c(local_3c + 0x6b5c,local_3c + 0xde7);
    DAT_1003944c = cVar3 != '\0';
    *(short *)(local_3c + 0x6b9c) = (short)uVar1;
  }
  return uVar1;
}

