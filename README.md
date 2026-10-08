# Cogniss Roadmap

A password-gated roadmap page with a comments section. It's one static file (`index.html`) that runs on GitHub Pages. Comments are stored in a free Supabase database, so visitors can post without logging in.

## 1. Set up the comments database (about 5 minutes)

1. Create a free account at [supabase.com](https://supabase.com) and create a new project.
2. In the project, open **SQL Editor → New query**, paste the contents of `supabase-setup.sql`, and click **Run**.
3. Open **Project Settings → API Keys** (older dashboards: **Project Settings → API**) and copy:
   - the **Project URL** (looks like `https://abcdxyz.supabase.co`)
   - the **publishable** key (`sb_publishable_…`), or the **anon / public** key on older projects
4. In `index.html`, paste them into the settings at the top of the script:

   ```js
   const SUPABASE_URL = "https://abcdxyz.supabase.co";
   const SUPABASE_KEY = "sb_publishable_…";
   ```

   This key is meant to be public. The database rules only let visitors read and add comments, not edit or delete them. **Never** paste the `secret` / `service_role` key here.

Until you fill these in, the page runs in preview mode and saves comments only in your own browser.

## 2. Publish on GitHub Pages

1. Create a new repository on GitHub and upload `index.html` (the README and SQL file are optional).
2. Go to **Settings → Pages**. Under **Build and deployment**, choose **Deploy from a branch**, pick `main` and `/ (root)`, and click **Save**.
3. After a minute or two, the site will be live at `https://<your-username>.github.io/<repo-name>/`. Share that link along with the password.

## Change the password

The default password is `roadmap2026`. To change it:

1. Get the SHA-256 hash of your new password. On a Mac, run this in Terminal:

   ```bash
   printf '%s' 'your-new-password' | shasum -a 256
   ```

2. Replace the `PASSWORD_HASH` value in `index.html` with the long string it prints (not the trailing `-`).

## Edit the roadmap

The `QUARTERS` and `ITEMS` lists near the top of the script in `index.html` hold the roadmap content. Each item has:

- `q`: which quarter it goes in (matches a quarter's `id`)
- `status`: `shipped`, `progress`, `planned` or `exploring`
- `area`, `title`, `desc`
- `pct`: optional progress bar for in-progress items

## Resolve and moderate comments

Each comment has a **Mark as resolved** button that moves it to the **Archived** tab. From there, **Reopen** moves it back. Anyone with the link can do this, because visitors don't log in.

To delete a comment for good, open **Table Editor → comments** in Supabase and delete the row.

If you ran an older version of `supabase-setup.sql`, run the current one again. It's safe to re-run, and it adds the resolved columns and permissions.

## What the password does and doesn't protect

The password screen keeps casual visitors out. It isn't strong security:

- The page is static, so the roadmap text is in the page source. Anyone who opens the source or the GitHub repo can read it. With a public repo, the roadmap is effectively public.
- Comments can be read through the Supabase key without the password.

If the roadmap must be truly private, use a private repository with a host that has real password protection, such as Cloudflare Pages with Cloudflare Access (free for small teams) or Netlify's password protection (paid plans). The same `index.html` works on both.
