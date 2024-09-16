<!--- Add badges, title, and description -->
<h1 align="center">
  <br>
  Pythonette
  <br>
</h1>

<p align="center">
  <strong>Automate Pycodestyle Installation and Alias Creation</strong>
</p>

<!--- Add a brief introduction -->
## Introduction

Pythonette is a bash script that automates the installation of `pycodestyle` and the creation of the alias `pythonette` in either .bashrc or .zshrc. The `pythonette` alias is used to check the PEP8 compliance of your Python files. This script ensures that `pycodestyle` is installed to your home directory without requiring sudo rights, making it usable on the 42 computers.

<!--- Add installation instructions -->
## Installation

To use Pythonette, follow these steps:

1. Open your terminal.

2. Copy and Paste this line of code into your terminal:

	```shell
	bash -c "$(curl -fsSL https://raw.githubusercontent.com/Caballosanex/Scripts/main/Pythonette/pythonette.sh)"
	```

<!--- Add explanation of the script -->
## How It Works

The `pythontte.sh` script checks if `pycodestyle` is already installed. If not, it attempts to install it using `pip` or `pip3`, depending on availability. The script also checks if the `pythonette` alias is already created. If not, it adds the alias to your `~/.zshrc` file.

<!--- Add a note or additional details -->
## Notes

- The `pythonette` alias allows you to check the PEP8 compliance of individual Python files or entire directories.

<!--- Add credits or acknowledgements -->
## Credits

Pythonette was created by [alexsanc](https://github.com/Caballosanex).

<!--- Add contact information or a way to contribute -->
## Contact

For questions, suggestions, or contributions, please contact [alexsanc](mailto:alexsanc@student.42barcelona.com).
