# 🐍 pyflowenv-nvim

**`pyflowenv-nvim`** est un *plugin* [Neovim](https://neovim.io/) écrit en [Lua](https://www.lua.org/), permettant de créer rapidement la structure minimale d’un projet **Python** : environnement virtuel isolé, `.gitignore`, les répertoires `src/`, `assets/` et `tests/`, le tout depuis une interface interactive dans **Neovim**.

![demo](./assets/screenshot.png)

Ce plugin est idéal pour les développeurs Python qui veulent **initialiser rapidement un projet dans Neovim**, sans avoir à quitter l'interface (utilisable depuis [alpha](https://github.com/goolord/alpha-nvim) ou via une commande intégrée à **Neovim**)

---

## 🔗 Pré-requis

- **Neovim** >= 0.10.4
- Requiert [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) et son extension [telescope-file-browser.nvim](https://github.com/nvim-telescope/telescope-file-browser.nvim) - Voir [Installation](https://github.com/Krystof2so/pyflowenv-nvim?tab=readme-ov-file#-installation-with-lazynvim)
- L'outil [fd](https://github.com/sharkdp/fd) (ou find, rg, etc.) doit être installé, car **Telescope** s’appuie souvent dessus :
```bash
sudo apt-get install fd-find
```

---


## ✨ Fonctionnalités

- 📁 Création d’un répertoire et d'une architecture pour le projet (commande `:PyflowCreate`)
- 📂 Sélection interactive du répertoire de destination avec **Telescope**
- 🐍 Génération automatique d’un environnement virtuel avec `python3 -m venv` et d'un dépôt **Git**
- 🧾 Création des fichiers `.gitignore` (adapté aux projets Python), `main.py` et `README.md`
- 💬 Interface interactive dans une fenêtre *popup* **Neovim**
- 🗂️ Interface de gestion des projets existants (créés ou ajoutés - Commande `:PyflowManage`)
    - 📋 Liste des projets enregistrés (triés par date de modification)
    - 🕓 Affichage de la date de dernière modification au format relatif (il y a 2 heures, hier, il y a 1 mois...)
    - 🔍 Ouverture du projet avec NvimTree (o)
    - ❌ Suppression d’un projet (d)
    - ➕ Ajout d’un projet existant via Telescope (a)
- 🏳️‍🌍 Support multilingue (`fr`, `es`, `en`)
- ⚙️ Configuration personnalisée : nom du dossier venv, langue...

---

## 📦 Installation (avec [lazy.nvim](https://github.com/folke/lazy.nvim))

Ajoutez le plugin dans la liste des plugins **Lazy**, ainsi que **telescope** si non installé :

```lua
{  -- nvim-telescope : recherche dans listes
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function()
        require("telescope").setup({
            extensions = {
                file_browser = {
                    theme = "dropdown",
                    hijack_netrw = true,
                },
            },
        })
        require("telescope").load_extension("file_browser")
    end,
},   

{
  "Krystof2so/pyflowenv-nvim",
  config = function()
    require("pyflowenv").setup({
      -- langue : "fr" (par défaut), "en", "es"
      lang = "fr",
      -- dossier venv : par défaut ".venv"
      venv_dir = ".venv"
    })
  end
}
```
---

## ⚙️ Configuration

```lua
require("pyflowenv").setup({
  venv_dir = ".venv", -- dossier de l'environnement virtuel (défaut)
  lang = "en",        -- langue : "fr", "en", "es"
})
```
---

## 📘 Help
Après l'installation, vous pouvez accéder à la documentation du plugin avec :

```
:help pyflowenv-fr
```
---

## 📂 Structure générée

```
mon-projet/
├── .gitignore
├── .git/
├── .venv/
├── assets/
├── README.md
├── src/
│   └── mon_projet/
│       └── main.py
└── tests/
```

- `.venv/` : environnement virtuel Python (non activé automatiquement)
- `.gitignore` : contient des règles standards ̀.venv`, `__pycache__/`, fichiers `.log`, etc.
- `main.py` : contient un code minimal.
- `README.md` : contient `# mon_projet`

---

## 🌍 Langues disponibles

Les messages affichés dans les fenêtres *popup* peuvent être traduits dynamiquement.
Langues actuellement supportées :

- 🇫🇷 Français (fr)
- 🇪🇸 Espagnol (es)
- 🇬🇧 Anglais (en)

Le choix se réalise via l'option `lang = "en"` dans `setup()`.

---

## 🔭 Feuille de route (à venir)

- 🧪 Détection et intégration avec **poetry** ou **pyenv**
- 🔧 Configuration plus poussée (*templates* personnalisables)

---

## 👨‍💻 Auteur

Développé par Krystof26, simple amateur des langages **Python** et **Lua**. J'apprécie les outils simples, efficaces et bien intégrés à [Neovim](https://neovim.io/).


