## Configuration

- Add script path and zsh hook to your `.zshrc`

```sh
export AUTO_GENERATE_NPMRC_PATH="$HOME/.shellscripts/auto-generate-npmrc-in-repository-folder"

autoload -U add-zsh-hook

add-zsh-hook -Uz chpwd (){
    ${AUTO_GENERATE_NPMRC_PATH}/auto-generate-npmrc.sh
}
```

- Add npmrc files do `npmrc_files` folder.

- Configure configs.json rules to auto identify private projects.
