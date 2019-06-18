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
  echo "  new   - Create a new post."
  echo ""
  echo "          Usgae: new <filename.txt>"
  echo ""
  echo "          This will create a new post .txt at src/ directory, then execute 'inotifywait' for"
  echo "          automatically update changes then write as output .html at posts/ directory,"
  echo "          then finally open a browser tab using firefox."  
  echo ""
  echo "  build - Create a final built ready for deploy."
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

  # write file to src/
  touch "src/$2" && echo "Wrote source file 'src/$2'"
  # show error message when things went wrong
  if [ $? -ne 0 ]; then
    echo "Error: Can't wrote file"
    exit 1
  fi

  # create .dirty directory if not yet exist
  if [ ! -d .dirty ]; then
    mkdir .dirty
    echo "Created temporary directory"
  fi

  # write a correct from conversion from pandoc now
  # so we can execute inotifywait in loop
  printf "<h2 id=\"title\">Your Post Title</h2>" > ".dirty/${2%%.*}.html"

  # now open the browser tab
  ${BROWSER} .dirty/${2%%.*}.html

  # wait and listen to file changes event for writing
  # note: don't try to execute this in the background, it's mess to clean up later
  while inotifywait -e modify "src/$2" || true; do pandoc "src/$2" -o ".dirty/${2%%.*}.html" ; done
  # show error messasge when things went wrong
  if [ $? -ne 0 ]; then
    echo "Can't listen to file changes event"
    exit 1
  fi
fi
