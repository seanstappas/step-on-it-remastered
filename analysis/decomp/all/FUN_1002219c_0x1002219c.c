
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002219c(undefined2 param_1)

{
  int iVar1;
  
  iVar1 = (int)_DAT_100394cc;
  _DAT_100394cc = _DAT_100394cc + 1;
  *(undefined2 *)(&DAT_100394ce + iVar1 * 2) = param_1;
  return;
}

