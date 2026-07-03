
bool FUN_100268a8(undefined4 param_1)

{
  short sVar1;
  undefined4 uStack00000018;
  undefined1 auStack_18 [4];
  undefined1 auStack_14 [4];
  undefined1 auStack_10 [12];
  
  uStack00000018 = param_1;
  sVar1 = .glue::AEGetAttributePtr(param_1,0x6d697373,0x6b657977,auStack_10,auStack_18,4,auStack_14)
  ;
  return sVar1 == -0x6a5;
}

