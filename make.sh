#!/bin/bash
# main management script to do various operations
# this scripts requires
# 1. firefox
# 2. pandoc
# 3. inotifywait
#
# make <operation> [options]
#
# See print_help() function for more information on usage.

CMD=$1

# browser to open to see the changes of editing .html file
BROWSER=firefox

print_help()
{
  echo "Management script"
  echo "Usage: make <operation> [options]"
  echo ""
  echo "<operation> is available as follows"
  echo "  new   - Create a new post, or continue Editing if a file exists."
  echo ""
  echo "          Usgae: new <filename.txt>"
  echo ""
  echo "          This will create a new post .txt at src/ directory if a file not exist, otherwise"
  echo "          ask to overwrite or continue editing from existing content, then execute"
  echo "          'inotifywait' for automatically update changes then write as output .html at"
  echo "          posts/ directory, then finally open a browser tab using firefox."  
  echo ""
}

if [ -z "$CMD" ]; then
  print_help
fi

if [ "$CMD" == "new" ]; then
  # get the filename parameter
  if [ -z "$2" ]; then
    echo "Missing <filename.txt> parameter"
    echo "Usage: make new <filename.txt>"
    exit 1
  fi

  # if all ok
  # check if file extension is exactly only 'txt'
  file_extension="${2##*.}"
  if [ "${file_extension}" != "txt" ]; then
    echo "Input file can only be .txt"
    exit 1
  fi

  # check if there's existing source file, to avoid overwriting
  if [ -f "src/$2" ]; then
    echo "Target source file 'src/$2' exists"
    read -p "Overwrite [N/y]: " confirm

    # not overwrite
    # convert to smaller case
    cconfirm=`echo "$confirm" | tr '[:upper:]' '[:lower:]'`
  fi

  # if confirmed to overwrite
  if [ "$cconfirm" == "y" ]; then
    # write file to src/
    printf "Your Post Title\n---------" > "src/$2" && echo "Wrote source file 'src/$2'"
    # show error message when things went wrong
    if [ $? -ne 0 ]; then
      echo "Error: Can't wrote file"
      exit 1
    fi
  fi

  # create posts directory if not yet exist
  if [ ! -d posts ]; then
    mkdir posts
    echo "Created posts/ directory"
  fi

  # pre-convert so users can see the result of .html now
  pandoc -B header.html "src/$2" -o "posts/${2%%.*}.html"

  # now open the browser tab
  ${BROWSER} posts/${2%%.*}.html

  # wait and listen to file changes event for writing
  # note: don't try to execute this in the background, it's mess to clean up later
  while inotifywait -e modify "src/$2" || true; do pandoc "src/$2" -o "posts/${2%%.*}.html" ; done
  # show error messasge when things went wrong
  if [ $? -ne 0 ]; then
    echo "Can't listen to file changes event"
    exit 1
  fi
fi
