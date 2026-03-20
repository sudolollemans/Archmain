Maintenance script I wrote as a personal project to learn Bash (and Arch). 

Dependencies: pacman, rsync, fwupdmgr, pacdiff. I also use yay but it should work without it. 

Free to use but check the code first and at least change the paths. It should be possible with an .env file too if you prefer that. 

I'll try to put a decent explanation here about the functions when I have time to do so. 

I'm planning on implementing popular AUR helper support, and a file manager by improving one of the modules (files.sh). 


------------------------------------------------------------------------------------

Running with _archmain_ opens the menu. 

Use functions directly with _(sudo) archmain modulename_
Only possible with functions: backup | update | clean | orphaned | syscheck

