{ langs ? []  , ... }:

{
  imports = [
    (if (builtins.elem "c" langs) then  import ./cc/cc.nix else ./guh.nix  ) 
    (if (builtins.elem "python" langs) then  import ./python/python.nix else ./guh.nix  ) 
    (if (builtins.elem "godot" langs) then  import ./godot/godot.nix else ./guh.nix  ) 
    (if (builtins.elem "haskell" langs) then  import ./haskell/haskell.nix else ./guh.nix  ) 
    (if (builtins.elem "rust" langs) then  import ./rust/rust.nix else ./guh.nix  ) 
    (if (builtins.elem "android" langs) then  import ./android/android.nix else ./guh.nix  ) 
    (if (builtins.elem "c-sharp" langs) then  import ./c-sharp/c-sharp.nix else ./guh.nix  ) 
    #(if (builtins.elem "yaml" langs) then  import ./yaml/yaml.nix else ./guh.nix  ) 
  ];

}
