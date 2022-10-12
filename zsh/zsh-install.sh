echo "After entering into zsh shell, exit zsh to finish installation"

sleep 1

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone --depth 1 https://github.com/zsh-users/zsh-completions $HOME/.oh-my-zsh/custom/plugins/zsh-completions
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

cp bureau_mod.zsh-theme $HOME/.oh-my-zsh/custom/themes/

sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bureau_mod"/' $HOME/.zshrc
sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-completions zsh-syntax-highlighting web-search)/' $HOME/.zshrc

echo ""
echo "Hello :D"
zsh
