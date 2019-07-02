# openbor-wiki
The file structure is to host as website on server.

* `index.html` is the first page users will see at your web server `.../openbor-wiki` path.
* `src` is directory that holds the source for editing posts in `.txt` format which finally will be manually converted into `.html` with `pandoc` tool via `pandoc -B header.html filename.txt -o filename.html` or similary `pandoc -s -B header.html filename.txt -o filename.html`.
* `.html` files will live in `posts` directory.

This project doesn't aim to provide good looking website thus style. Pure focus on content as reference, and to be useful for OpenBOR users.

# make.sh

Use `make.sh` to manage and edit a new/existing post.

`./make.sh new <post.txt>` - in which `<post.txt>` can be either new or existing file. If it's the latter
case, then it will ask you to confirm whether to overwrite or continue editing. Behind the scene,
it listen to changes event of file, and open browser tab (`firefox` for now) for you to see the
changes immediately.

# Credits

* `belug1.css` and webpage style - taken from [The Linux Information Project](http://www.linfo.org)

# License
Copyrights 2019, Wasin Thonkaew, Angry Baozi (气包子) https://abzi.co.
In case of reprinting, or to do anything with the article you're unsure of, please write me e-mail.
