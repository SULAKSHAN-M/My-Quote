# MyQuote — Rails Application Prototype
## CSI2441 Applications Development — Assignment 2

---

## Setup & Deployment Instructions

### Prerequisites
- Ubuntu 22.04
- Ruby 3.2.2
- Rails 7.0.4
- SQLite 3.42.0
- git 2.41.0

### Installation Steps

```bash
# 1. Navigate to the project directory
cd myquote

# 2. Install gems
bundle install

# 3. Create and migrate the database
rails db:create
rails db:migrate

# 4. Seed the database with required accounts and sample data
rails db:seed

# 5. Start the server
rails server
```

Then open: http://localhost:3000

---

## Required Test Accounts

| Role | Name | Email | Password |
|------|------|-------|----------|
| Administrator | John Jones | admin@myquotes.com | admin123 |
| Standard User | Vincent Brown | vinceb@myemail.com | vince123 |

---

## Application Features

### Public (no login required)
- View 10 most recently added public quotes on the homepage
- Search quotes by category
- Browse all sources (philosophers)

### Standard Users
- Create an account, log in, log out
- Edit personal details and change password
- Add, edit, delete their own quotes
- Set quotes as Public or Private
- Add new sources (philosophers)

### Admin Users
- All standard user features
- Admin dashboard with system stats
- Change user status (Active / Suspended / Banned)
- Elevate/demote users to/from admin
- Delete user accounts
- Delete categories and sources

---

## Data Model Summary
- **User** — fname, lname, email, password_digest, is_admin, status
- **Source** — fname, lname, byear, dyear, bio
- **Quote** — qtext, qyear, qcom, ispublic, user_id, source_id
- **Category** — catname
- **QuoteCategory** — quote_id, category_id (join table)
