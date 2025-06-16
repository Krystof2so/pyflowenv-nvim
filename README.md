# 🐍 pyflowenv-nvim

`pyflowenv-nvim` est un plugin Neovim écrit en Lua, conçu pour créer rapidement la structure d’un projet Python, avec un environnement virtuel (`venv`) isolé et un fichier `.gitignore` adapté.

Ce plugin est particulièrement utile pour initialiser un projet Python léger directement depuis Neovim, sans avoir à créer manuellement la structure de base.

---

## ✨ Fonctionnalités

- 📁 Création d’un répertoire de projet Python
- 🐍 Création automatique d’un environnement virtuel (`python3 -m venv`)
- 🧾 Génération d’un fichier `.gitignore` adapté aux projets Python
- ⚙️ Option configurable pour personnaliser le nom du dossier de l’environnement virtuel

---

## 📦 Installation (via [lazy.nvim](https://github.com/folke/lazy.nvim))

Ajoutez ce plugin dans votre liste Lazy :
```lua
{
  "Krystof2so/pyflowenv-nvim"
  config = function()
    require("pyflowenv").setup() -- ou rien si pas de setup
  end
}
```

---

## ⚙️ Configuration (optionnelle)

```lua
require("pyflowenv").setup({
  venv_dir = ".venv" -- Par défaut : ".venv"
})
```

`venv_dir` : nom du dossier dans lequel créer l’environnement virtuel (par défaut : `.venv`)

---

## 🚀 Utilisation

Vous pouvez utiliser le plugin de deux manières :

### 1. Commande utilisateur

```vim
:CreatePythonVenv
```

### 2. Appel direct en Lua

```lua
require("pyflowenv").create_python_project()
```

---

## 📂 Exemple de structure générée

```
mon-projet/
├── .gitignore
└── .venv/
```

Le répertoire `.venv/` contient l’environnement virtuel Python créé avec `python3 -m venv`.

Le fichier `.gitignore` contient des règles adaptées aux projets Python : exclusion de `.venv`, des `__pycache__/`, fichiers `.log`, `.cache`, bases de données locales, etc.

---

## 🔧 À venir (feuille de route)

Voici quelques fonctionnalités prévues pour les prochaines versions :

- 📝 Génération automatique d’un fichier `main.py`
- 🧱 Création d’une structure de projet personnalisable (ex : `src/`, `tests/`, etc.)
- 🧪 Possibilité de création de projets avec **pyenv** et **poetry**

Et pourquoi pas :

- Intégration avec **telescope.nvim** pour choisir un dossier ?
- Génération de *templates* ?
- Structure de projet avec **QT for Python** ?
- Et je ne sais quoi encore...

---

## 🧑‍💻 Auteur

Développé par Krystof26... amateur de code (**Python** et **Lua**)

---

## 🪪 Licence

Ce plugin est distribué sous licence MIT.  
Voir le fichier [LICENSE](./LICENSE) pour plus de détails.


