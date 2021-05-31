### After following the instructions, you'll be ready to start plotting!
https://www.tomshardware.com/how-to/raspberry-pi-chia-coin

### Here's exactly what you need to do, call/text if you have any trouble:

1. plug in all your stuff (keyboard/mouse/monitor/disk... but not power!)

1. plugin power to turn on the pi

1. login to the pi

1. connect to your home wifi (may need to google how, but I think it's the top right corner icons)
 
1. open terminal and run the following commands 
	
		# COMMAND 1 - start a byobu multiplexer session called "plotting"
		byobu -S plotting

		# COMMAND 2 - change to the chia-blockchain directory
		cd chia-blockchain
	
		# COMMAND 3 - activate chia 
		. ./activate

		# COMMAND 4 - show your key info
		chia keys show 
			# record you <farmer public key> and <pool public key> in texteditor
		
		# COMMAND 5 - create 5 chia plots 
		chia plots create -k 32 -b 1800 -r 2 -u 128 -n 5 -t "</your/media/location>" -d "</your/media/location>" -f <farmer public key> -p <pool public key>

			# Take note of all the variable stuff you'll need to figure out
			# Get the entire command figured out in your texteditor, then copy/paste into terminal
			
			# EXAMPLE (but use your values!  send me a pic if unsure): 
				# chia plots create -k 32 -b 1800 -r 2 -u 128 -n 5 -t "/home/eth/SSD drive" -d "/home/eth/SSD drive" -f a4ab1f8213ebc06cbce49bf56b923467cf3263fdf587efff5ef0b71635f7c5b51d239046586354db24dfab188071d978 -p 96cbc06eb710bb3c43e8a64208dd49bce37cf440ca1c2bd6ee3c99124818c8ad0520d0b3f401151148a3a0e3c97f9f03
				
			# About 10 minutes or so after you start this process, facetime me?


		# COMMAND 6 - exit the byobu session 
		# Not a command, but press the "F6" key (it will stay running)
			# Note: this process will take days to complete.  Let it run in the background while you do other things...
		
		# COMMAND 7 - start a byobu multiplexer session called "farming"
		byobu -S farming
		
		# COMMAND 8 - change to the chia-blockchain directory
		cd chia-blockchain
	
		# COMMAND 9 - activate Chia 
		. ./activate
		
		# COMMAND 10 - start the Chia Farmer
		chia start farmer 
		
		# COMMAND 11 - exit the byobu session (it will stay running)
		# Not a command, but press the "F6" key
		
### What's next...  
			# Lots of waiting :)
			# It will take a few days for the plots to be created, maybe 15+ hours for each
			# It will take a few days to sync the wallet and blockchain
			# Check back in ~24 hours and look to see if there is anything in your plot directory (ls "</your/media/location>")
			# Call/text tomorrow night and let me know whether or not you have a plot
			# Figure out when we can hang out next!  More to do... you'll be able to farm as soon as the blockchain sync's and you have a plot, as soon as tomorrow if all goes well, more likely another day or two
			
### Other things to do / consider / discuss 
			# configure chia / farming dir 
			# wallet address
			# port 8444 / seedings 
			# https://github.com/stolk/chiaharvestgraph
