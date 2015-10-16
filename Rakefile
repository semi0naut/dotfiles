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
      link_to_dotfile file
    end
  end

  setup_personal_folder
  setup_temp_folder
end

def create_dotfile_link
  system %Q{rm -f "$HOME/.dotfiles"}
  system %Q{ln -s $PWD "$HOME/.dotfiles"}
end

def replace_file(file)
  system %Q{rm -r "$HOME/.#{file}"}
  link_to_dotfile file
end

def link_to_dotfile(file)
  link_file "$HOME/.dotfiles/#{file}", "$HOME/.#{file}"
end

def link_file(source, dest)
  puts "linking #{source} to #{dest}"
  system %Q{ln -s #{source} #{dest}}
end

def setup_personal_folder
  puts "Where are your personal files?"
  dir = $stdin.gets.chomp
  link_file dir, "~/.personal-files"
end

def setup_temp_folder
  system %Q{mkdir -p ~/.tmp}
end
