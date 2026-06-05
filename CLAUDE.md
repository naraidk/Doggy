# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
bin/setup            # Install dependencies, prepare DB, start server
bin/dev              # Start development server (rails server)
bin/rails db:migrate # Run pending migrations
bin/rails db:seed    # Seed the database

bin/rails test                        # Run all tests
bin/rails test test/path/to/test.rb   # Run a single test file
bin/rails test test/path/to/test.rb:LINE  # Run a single test

bin/rubocop          # Lint Ruby code
bin/brakeman         # Static security analysis
```

Ruby version: see `.ruby-version`. Database: `doggy_projet_development` (PostgreSQL).

Environment variables are loaded from `.env` via `dotenv-rails` — Cloudinary credentials go there (`CLOUDINARY_CLOUD_NAME`, `CLOUDINARY_API_KEY`, `CLOUDINARY_API_SECRET`).

## Architecture

Rails 8.1 app with PostgreSQL, Hotwire (Turbo + Stimulus), Bootstrap 5.3, and importmaps (no Node/webpack build step).

### Core domain model: Dogs as actors

The central design decision is that **Dogs are the social actors, not Users**. A `User` owns `Dog` records, and all social activity (posts, comments, woufs, messages, events) is performed by a `Dog`. The `ApplicationController` exposes `current_dog` which returns `current_user.dogs.first` — the app currently treats the first dog as the active profile.

```
User → has_many :dogs
Dog  → belongs_to :user
     → has_many :posts, :comments, :woufs, :ai_chats
     → has_many :conversations_as_one / :conversations_as_two
     → has_many :event_participants → :events
     → has_one_attached :avatar (via Cloudinary)
```

### Features

- **Feed** (`/posts`): root path. Dogs post content with optional images, other dogs can Wouf (like) and Comment.
- **Dog profiles** (`/dogs`): CRUD for a user's dogs. Each dog has name, breed, age, description, and an avatar image stored on Cloudinary via Active Storage.
- **AI vet chatbot** (`/dogs/:id/ai_chats`): Per-dog chat sessions with an AI vet assistant. Uses `ruby_llm` gem to call an LLM; conversation history is rebuilt from `AiMessage` records on each request. Messages stream back via Turbo Streams.
- **Dog-to-dog messaging** (`/conversations`): Direct messages between two dogs. `Conversation` has a unique constraint on `(dog_one_id, dog_two_id)`. `find_or_create_by` prevents duplicates. `current_user.dogs.first` is always `dog_one`.
- **Events** (`/events`): Dogs create and join events (city + date). `EventParticipant` is the join model.
- **Map** (`/map`): Leaflet map loaded dynamically by `MapController` (Stimulus). Leaflet JS/CSS are loaded from unpkg CDN at runtime — not bundled.

### Authorization

Devise handles authentication (`before_action :authenticate_user!` on `ApplicationController`). Pundit is installed but **commented out** — `include Pundit::Authorization` and the `after_action` verifications are disabled. Do not assume Pundit policies are enforced.

### Styling

SCSS compiled via `sassc-rails`. Structure: `config/` (variables, Bootstrap overrides), `components/`, `pages/`, `posts/`, `dogs/`. Brand color is `#FF5D24` (orange). Custom utility classes: `.btn-doggy`, `.bg-doggy`, `.text-doggy`, `.shadow-doggy`, `.border-doggy`.

### Turbo Streams

Several actions respond to both HTML and Turbo Stream formats. Check for `*.turbo_stream.erb` view files alongside standard views — dogs and AI messages use these for in-page updates without full page reloads.
