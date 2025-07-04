#!/bin/bash
# Global Variables for the script
folders=()
home_array=()
file2=""
# Folders that are excluded from being processed into the .config directory under your home directory
exclude=("zsh")
# Folders that are processed into the .config directory under your home directory and also symlinked to your home directory
both=("bashrc" "tmux")

#Funtions
debug() {
  if [ "$DEBUG" = true ]; then
    echo "DEBUG: $1"
  fi
}

empty_folder(){
    # check if the directory is not empty
  if [ -z "$(ls -A "$dir")" ]; then
    debug "Skipping empty directory: $dir"
  else 
    debug "Processing directory: $dir"
    folders+=("$dir")
  fi
}

generatedir(){
# Generate a list of directories in the current directory
  for dir in */; do
    if [[ " ${both[*]} " =~ ${dir%/} ]]; then
      empty_folder "$dir" 
      continue
    elif [[ " ${exclude[*]} " =~ ${dir%/} ]]; then
        continue
    else
        empty_folder "$dir"
        continue
    fi
  done
}

generate-configlink(){
# Create symbolic links for each directory in the folders array
  if [ "$DRY" = true ] || [ "$DRY" = TRUE ]; then
    echo "Dry run mode: No symlinks will be created."
    echo "Dry run mode: Folders to be linked: ${folders[@]}"
    return
  else
    for folder in "${folders[@]}"; do
      # Remove trailing slash from folder name
      folder_name="${folder%/}"
      # Create symbolic link in the home directory
      while IFS= read -r file; do
        file2="${file}"
      done < <(find "$folder" -maxdepth 1 -type f -name "*" -not -name ".DS_Store" -not -name ".stowrc")
      rm -rf "$HOME/.config/${folder_name:?}"
      mkdir -p "$HOME/.config/$folder_name"
      if [ "$folder_name" '=' "tmux" ]; then
        cp "$PWD/$file2" "$HOME/.config/$file2" 
      elif [ "$folder_name" '=' "ghostty" ]; then
        cp -r "$PWD/$folder_name" "$HOME/.config" 
      elif [ "$folder_name" '=' "zsh" ]; then
        cp -r "$PWD/$folder_name" "$HOME/.config" 
      elif [ "$folder_name" '=' "btop" ]; then
        cp -r "$PWD/$folder_name" "$HOME/.config" 
      else
       ln -sf "$PWD/$file2" "$HOME/.config/$file2"
      fi
    done
  fi
}

generate-home(){
# Create an array of files within the folders defined in the exclude array
for dir in "${exclude[@]}" "${both[@]}"; do
  while IFS= read -r file; do
    home_filepath="${file}"
    home_filename="${file##*/}"
    home_array+=("$home_filepath")
    debug "Processing file: $home_filename"
    debug "File path: $PWD/$home_filepath"
    debug "Adding file to home_array: $home_filename"
  done < <(find "$dir" -maxdepth 1 -type f -name ".*" -not -name ".DS_Store" -not -name ".stowrc")
done
}
generate-homelink(){
# Create symbolic links for each directory in the excule array
  if [ "$DRY" = true ] || [ "$DRY" = TRUE ]; then
    echo "Dry run mode: No symlinks will be created."
    echo "Dry run mode: files to be linked to HOME Directory: ${home_array[*]}"
    return
  else 
    for file in "${home_array[@]}"; do
      # Remove the leading path and get the filename
      home_filepath="${file}"
      home_filename="${file##*/}"
      debug "Processing file for symlink: $home_filename"
      # Create symbolic link in the home directory
      sudo rm "$HOME"/"${home_filename:?}"
      if [[ "$home_filename" == *".tmux"* ]]; then
        cp "$PWD/$home_filepath" "$HOME/$home_filename"
        debug "CP from $PWD/$home_filepath in $HOME/$home_filename"
      elif [[ "$home_filename" == *".zsh"* ]]; then
        cp "$PWD/$home_filepath" "$HOME/$home_filename"
        debug "CP from $PWD/$home_filepath in $HOME/$home_filename"
        if [ "$SHELL" = "/bin/zsh" ]; then
          if [ "$home_filename" == ".zshrc" ]; then
            echo "Please restart your terminal or run 'source ~/.zshrc' in your zsh shell to apply changes."
          fi
        fi
      else
        ln -sf "$PWD/$home_filepath" "$HOME/$home_filename"
        debug "Created symlink for $PWD/$home_filepath in $HOME/$home_filename"
      fi
    done
  fi
}

# Script Execution
generatedir
generate-home
generate-configlink
generate-homelink
