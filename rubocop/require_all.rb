dir = "#{ENV['DOTFILES_DIR'].chomp('/')}/rubocop/cops/*.rb"
puts Dir[dir].map {|f| "--require #{f}"}.join(' ')
