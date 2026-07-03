
void FUN_1001ba40(int param_1)

{
  undefined4 uVar1;
  
  uVar1 = *(undefined4 *)(param_1 + 2);
  if ((*(ushort *)(param_1 + 0xe) & 0x100) != 0) {
    FUN_1001c01c();
    uVar1 = .glue::MenuKey((int)(char)uVar1);
    FUN_1001c398(uVar1,param_1);
  }
  return;
}

