#define NO_HOSTNAME_FOUND -23
#define SYMLINKS_FILE_COULD_NOT_BE_OPENED -54

void link_file(char *source, char *target){
  printf("Linking %s to %s\n", source, target);
  //TODO
}

int main(int argument_count, char *arguments[]){
  printf("START\n");
  for(int index = 0; index < argument_count; ++index){
    printf("a%d: %s\n", index, arguments[index]);
  }

  char current_working_direcory[256];
  getcwd(current_working_direcory, 256);
  printf("CWD: %s\n", current_working_direcory);

  //We assume no hostnames longer than 64
  char hostname[64];
  int hostname_error = gethostname(hostname, 64);
  if(hostname_error != 0){
    printf("Hostname could not be gleaned. ERROR: %d\n", hostname_error);
    exit(NO_HOSTNAME_FOUND);
  }
  printf("Hostname: %s\n", hostname);

  char* symlinks_file_name = strcat(hostname, ".symlinks");
  //64 from the hostname buffer + 6 for the concatinated part
  char symlinks_file_path[70] = "../../";
  strcat(symlinks_file_path, symlinks_file_name);
  printf("Reading symlinks out of: %s\n", symlinks_file_path);
  int symlinks_file_fd = open(symlinks_file_path, O_RDONLY);
  if(symlinks_file_fd == -1){
    printf("Symlinks file %s could not be opened. ERROR: %d\n", symlinks_file_name, errno);
    exit(SYMLINKS_FILE_COULD_NOT_BE_OPENED);
  }
  // Parse the *.symlink file, which is expected to be in following format:
  // 1st line: source path
  // 2nd line: target path
  // 3rd line: newline
  // repeat for as many symlinks as wiched for
  char read_character[1];
  char source_file_path[256];
  int source_file_path_complete = 0;
  char target_file_path[256];
  int target_file_path_complete = 0;
  int path_index = 0;
  int last_character_was_newline = 0;
  while((read(symlinks_file_fd, &read_character, 1))){
    char character = read_character[0];
    //skip reading \r so we can pretend \r\n == \n
    if(character == '\r'){
      continue;
    }
    if(character != '\n'){
      if(!source_file_path_complete){
        source_file_path[path_index] = character;
      }
      else{
        if(!target_file_path_complete){
          target_file_path[path_index] = character;
        }
      }
      path_index = path_index + 1;
      last_character_was_newline = 0;
    }
    else{
      //ignore empty lines
      if(last_character_was_newline){
        last_character_was_newline = 0;
        continue;
      }
      last_character_was_newline = 1;
      if(!source_file_path_complete){
        source_file_path[path_index] = '\0';
        source_file_path_complete = 1;
      }
      else{
        if(!target_file_path_complete){
          target_file_path[path_index] = '\0';
          target_file_path_complete = 1;
        }
      }
      if(source_file_path_complete && target_file_path_complete){
        link_file(source_file_path, target_file_path);
        source_file_path_complete = 0;
        target_file_path_complete = 0;
      }
      path_index = 0;
    }
  }
  close(symlinks_file_fd);
  printf("END\n");
  return EXIT_SUCCESS;
}
