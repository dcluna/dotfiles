load '~/.irbrc'
Pry.config.correct_indent = false if ENV["INSIDE_EMACS"]
if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  # Pry.commands.alias_command 'e', 'finish'
end
# Pry::Commands.command /^$/, "repeat last command" do
#   _pry_.run_command Pry.history.to_a.last
# end
Pry.editor = "emacsclient -s dcl"
