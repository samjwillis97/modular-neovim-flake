# My Modular Neovim

![Screenshot 2024-01-10 at 12 54 13 pm](https://github.com/samjwillis97/modular-neovim-flake/assets/37866085/9bc6329e-e874-408c-9ba7-6b427d8bc3a7)


Attempting to build out my neovim config in a modular fashion in effort to understand nix packaging better. Inspired by the likes of:

- [jordanisaacs](https://github.com/jordanisaacs/neovim-flake)
- [wiltaylor](https://github.com/wiltaylor/neovim-flake)

## Require Files

- For the `review` module which uses `Octo` the private key for the Github agenix is required at `/var/agenix/github-primary`


## Helpful vim commands

Shows you which init vim was loaded: `:scriptnames`


## To Address

- Treesitter errors, `:checkhealth nvim-treesitter`
