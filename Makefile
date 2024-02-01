# TODO: manage different install envs (ubuntu vs macos)
preamble:
	@echo "Some additional installs may be neccesary depending on the system. This is still a work in progress."

update-installs:
	sudo apt update

# if on ubuntu, uninstall snap curl and reinstall using apt
# the snap version does not work properly
# see https://askubuntu.com/questions/1387141/curl-23-failure-writing-output-to-destination
fix-curl: update-installs
	sudo snap remove curl
	sudo apt install curl

install-python: update-installs
	# install a global python version for general usage
	sudo apt install python3.11 -y
	python3 -m pip install --user pipx
	python3 -m pipx ensurepath
	sudo apt install python3.10-venv -y
	pipx install poetry
	curl https://pyenv.run | bash # manage different python version for different projects
	@echo "Make sure to follow pyenv instructions to modify .zshrc"

install-zsh: update-installs
	sudo apt install zsh -y
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	touch .zshrc_private
	@echo "Installing extensions"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	sudo apt install autojump -y

install-font: fix-curl
	curl -LJO https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FantasqueSansMono/Regular/FantasqueSansMNerdFontMono-Regular.ttf
	@echo "Please install the font manually"
	open FantasqueSansMNerdFontMono-Regular.ttf
	@echo "Please select the font as the font to use in your terminal. This may require restarting the terminal first."
	@echo "If you notice that icons are not the right size you may need to install a different version of the font."

install-p10k:
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
	cp .p10k.zsh $HOME/

install-nvim:
	# snap has a later version than apt
	sudo snap install nvim --classic
	@echo "Installing vim-plug"
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

install-fzf:
	sudo apt install fzf
	# build-essential is required for telescope-fzf interaction
	sudo apt install build-essential

install-visidata:
	sudo apt install visidata

nvim-info:
	@echo "Open neovim - it will error because we haven't installed the colorscheme yet"
	@echo "Run :PlugInstall, then restart neovim"

ubuntu: preamble update-installs fix-curl install-python install-zsh install-font install-p10k install-nvim install-fzf install-visidata nvim-info
