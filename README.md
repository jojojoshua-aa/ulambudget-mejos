# Ulam na Pasok sa Budget

A Filipino budget meal guide and recipe manager for students and budget-conscious cooks.
Built with PHP (PDO), MySQL/MariaDB, Tailwind CSS (CDN), and vanilla JavaScript.

## What is included

| Rubric requirement | Where it lives |
|---|---|
| Landing page (hero, categories, Budget Hacks) | `index.php` |
| Register / Login / Logout (PHP sessions, `password_hash` / `password_verify`) | `auth/register.php`, `auth/login.php`, `auth/logout.php` |
| Protected pages (redirect to login) | `require_login()` in `includes/functions.php`, used by every page below |
| Roles: Admin and Regular User | `users.role` column, `can_manage_recipe()` / `can_view_recipe()` |
| CRUD for Recipes (PDO prepared statements) | `dashboard.php` (Read/list), `recipes/view.php`, `recipes/create.php`, `recipes/edit.php`, `recipes/delete.php` |
| Validation with friendly errors | `validate_recipe()` (server) and `assets/js/app.js` (client) |
| `confirm()` before delete | `data-confirm` forms handled in `assets/js/app.js` |

## Requirements

- XAMPP with **PHP 8.0 or newer** (current XAMPP downloads qualify), Apache, and MySQL/MariaDB
- Internet connection in the browser (Tailwind CSS and Google Fonts load from CDNs)

## Setup in XAMPP

1. **Copy the project.** Put the whole `ulam-na-pasok-sa-budget` folder inside XAMPP's `htdocs`
   (for example `C:\xampp\htdocs\ulam-na-pasok-sa-budget`).
2. **Start services.** Open the XAMPP Control Panel and start **Apache** and **MySQL**.
3. **Import the database.**
   1. Go to <http://localhost/phpmyadmin>.
   2. Click the **Import** tab.
   3. Choose `database.sql` from the project folder and click **Import**.
   4. This creates the `ulam_budget` database with the `users` and `recipes` tables and sample data.
      (You do not need to create the database first. The file does it. Re-importing resets everything.)
4. **Check the DB settings.** `config/db.php` uses XAMPP defaults (`root`, empty password, database `ulam_budget`).
   Change them only if your MySQL setup differs.
5. **Open the app:** <http://localhost/ulam-na-pasok-sa-budget/>

The site URL prefix is detected automatically, so the folder can be renamed without editing any code.

## Default login credentials

| Role | Email | Password |
|---|---|---|
| Admin | `admin@ulam.test` | `Admin@123` |
| Regular user | `user@ulam.test` | `User@1234` |

New accounts created from the Register page are always regular users.

## How the roles work

- **Admin** can view, create, edit, and delete **every** recipe. Recipes an admin creates are public to all users.
- **Regular user** can read the admin's public recipes, and create, edit, and delete **their own** recipes.
  Their recipes are private (marked "Pribado") and only visible to them and to admins.
- Trying to edit or delete someone else's recipe is blocked on the server, not just hidden in the UI.

## Suggested demo flow for your presentation

1. Show the landing page, then resize the window to show it is responsive.
2. Try opening `/dashboard.php` while logged out. It redirects to login.
3. Register a new account, then log in.
4. As the user: add a recipe, submit an empty form to show the error messages, edit it, then delete it (show the confirm dialog).
5. Log out, log in as admin, and show that you can edit and delete the user's recipe too.
6. Open phpMyAdmin and show that the `password_hash` column holds hashes, not plain text.

## Security notes

- Passwords: `password_hash()` and `password_verify()`.
- SQL: PDO prepared statements with real (non-emulated) preparation everywhere.
- Output: all user content passes through `htmlspecialchars()` (the `e()` helper) to prevent XSS.
- CSRF tokens on every POST form, including logout and delete. Delete never runs from a plain link.
- Session ID is regenerated on login. Login errors do not reveal whether the email exists.
- Dropdown values (category, budget) are checked against fixed whitelists on the server.

## Project structure

```
ulam-na-pasok-sa-budget/
├── index.php                 Landing page
├── dashboard.php             Recipe list with search, filters, pagination
├── database.sql              Schema + sample data (import this first)
├── README.md
├── config/
│   └── db.php                PDO connection settings
├── includes/
│   ├── functions.php         Sessions, auth, CSRF, permissions, validation
│   ├── header.php            Shared top navigation and flash messages
│   ├── footer.php
│   └── recipe_form.php       Shared create/edit form
├── auth/
│   ├── register.php
│   ├── login.php
│   └── logout.php
├── recipes/
│   ├── create.php
│   ├── view.php
│   ├── edit.php
│   └── delete.php
└── assets/
    ├── css/style.css
    └── js/app.js
```

## Troubleshooting

- **"Hindi maka-connect sa database"**: MySQL is not running, or `database.sql` has not been imported.
- **Unstyled page**: the browser could not reach `cdn.tailwindcss.com`. Check your internet connection.
- **Blank page or parse error**: confirm XAMPP's PHP version is 8.0 or newer (`http://localhost/dashboard/phpinfo.php`).
- **Port conflict on Apache or MySQL**: change the port in XAMPP's config, then include it in the URL (for example `localhost:8080`).
