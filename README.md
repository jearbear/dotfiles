### installation

You'll need to clone this repo to some directory that is **not** `$HOME`, I like to use `.dotfiles`. The files are structured in the same manner as they would sit in your `$HOME` directory without the typical `.` prefix, just to make them slightly easier to navigate. I've somewhat tested these with both OSX and Arch Linux, but only some of these dotfiles are relevant in OSX.

**link file** - `ln -s $FILE .$FILE`

**link file, overwriting existing** - `ln -sf $FILE .$FILE`

A helper script is in the works to avoid the possibility of shooting yourself in the foot with these commands as I have already done.


### todo

- make a helper program to manage linking and unlinking these files
- common `bin` scripts I use
- generalize to support 4K resolution
