require 'rake'

desc "install the dot files into user's home directory"
task :install do
  replace_all = false
  # link dotfiles first
  create_dotfile_link

  Dir['*'].each do |file|
    next if %w[Rakefile README notes fonts iterm id_dsa.pub .git .gitignore gitignore].include? file

    if File.exist?(File.join(ENV['HOME'], ".#{file}"))
      if replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file}"
        end
      end
    else
      link_file(file)
    end
  end

  system %Q{mkdir -p ~/.tmp}
end

def create_dotfile_link
  system %Q{rm "$HOME/.dotfiles"}
  system %Q{ln -s $PWD "$HOME/.dotfiles"}
end

def replace_file(file)
  system %Q{rm "$HOME/.#{file}"}
  link_file(file)
end

def link_file(file)
  puts "linking ~/.#{file}"
  system %Q{ln -s "$HOME/.dotfiles/#{file}" "$HOME/.#{file}"}
end
