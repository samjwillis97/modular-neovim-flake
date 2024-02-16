let 
  primary-gh-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDqBgLxog6NG/d2LQ/XQr1NfCxbvTxsAgDLGKV0pNjcf sam@williscloud.org";
  secondary-gh-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDfkEyrxhe8xzftrPSHH+1Zkkz7i+0MOoHvPNHzd/J6C sam@williscloud.org";
  keys = [ primary-gh-key secondary-gh-key ];
in 
{
  "gh_pat.age".publicKeys = keys;
}
