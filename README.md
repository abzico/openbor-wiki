# openbor-wiki
The file structure is to host as website on server.

* `index.html` is the first page users will see at your web server `.../openbor-wiki` path.
* `src` is directory that holds the source for editing posts in `.txt` format which finally will be manually converted into `.html` with `pandoc` tool via `pandoc -B header.html filename.txt -o filename.html` or similary `pandoc -s -B header.html filename.txt -o filename.html`.
* `.html` files will live in `posts` directory.

This project doesn't aim to provide good looking website thus style. Pure focus on content as reference, and to be useful for OpenBOR users.

# automate

During writintg a new article. Use `inotifywait` package (via `sudo apt install inotifywait`) to help
in detecting changes then produce result `.html` file in `posts/` directory.

Use the following command to do so in different terminal window

```
while inotifywait -e modify src/crosscompile.txt || true; do pandoc src/crosscompile.txt -o 
posts/crosscompile.html ; done
```

# License
Copyrights 2019, Wasin Thonkaew, Angry Baozi (气包子) https://abzi.co.
In case of reprinting, or to do anything with the article you're unsure of, please write me e-mail.
