;; extends

;; 1. Kernel Macros (@)
((command_name) @ArtTexKernelMacro
 (#lua-match? @ArtTexKernelMacro "@"))

;; 2. Expl3 Macros (_ and :)
((command_name) @ArtTexExpl3Macro
 (#lua-match? @ArtTexExpl3Macro "[_:]"))

;; 3. Structural Package Includes
((command_name) @ArtTexStructCmd
 (#any-of? @ArtTexStructCmd "\\usepackage" "\\RequirePackage" "\\documentclass" "\\ProvidesPackage" "\\ProvidesClass" "\\import" "\\subimport" "\\input" "\\include"))
