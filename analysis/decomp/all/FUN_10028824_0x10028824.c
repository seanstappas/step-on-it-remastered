
void FUN_10028824(void)

{
  undefined4 uVar1;
  undefined4 local_2c;
  
  .glue::FreeMem();
  FUN_10023e14();
  FUN_10027320();
  .glue::FreeMem();
  uVar1 = .glue::GetPicture(200);
  *(undefined4 *)(local_2c + 0x7130) = uVar1;
  if (*(int *)(local_2c + 0x7130) == 0) {
    FUN_100192f8(5);
  }
  .glue::FreeMem();
  FUN_1002af74();
  .glue::FreeMem();
  uVar1 = .glue::GetResource(0x636c7574,1000);
  *(undefined4 *)(local_2c + 0x70fc) = uVar1;
  FUN_100035e4();
  uVar1 = .glue::GetResource(0x636c7574,0x193);
  *(undefined4 *)(local_2c + 0x70f8) = uVar1;
  uVar1 = .glue::RGetResource(0x636c7574,8);
  *(undefined4 *)(local_2c + 0x70f4) = uVar1;
  FUN_10022114();
  FUN_100226c4();
  FUN_1002289c();
  FUN_10022954();
  FUN_10022a3c();
  FUN_10022b54();
  return;
}

