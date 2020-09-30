eval (direnv hook fish)
starship init fish | source
# function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
#     for mode in default insert visual
#         fish_default_key_bindings -M $mode
#     end
#     fish_vi_key_bindings --no-erase
# end
# set -g fish_key_bindings hybrid_bindings
function fish_user_key_bindings
  fish_vi_key_bindings
end
