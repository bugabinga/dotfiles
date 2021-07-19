return function(autocommand)
  autocommand{ setup_build_for_dotfiles_boottripper = [[ BufRead bootstripper.c set makeprg=../build.bat ]]}
end
