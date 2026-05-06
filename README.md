# Learn SQLite

## Environment

-   SQLite 3.40.1 (`sqlite3` Debian package `3.40.1-2+deb12u2` in Docker)

## Usage

1.  Build docker image

    ```sh
    docker compose build
    ```

2.  Run an exercise.

    Arguments are subdirectory names directly under [`db`](db).

    Paths are rooted at `/root/db` inside the container.

    Bundled example:

    ```sh
    docker compose run --rm app topsic-contest010-4
    ```

    Multiple directories may be listed. Omitting directories by running
    `docker compose run --rm app` with **no arguments** exits with error so
    that an exercise cannot be skipped by mistake.

3.  Optionally run the harness on the host.

    This needs SQLite supporting `FORMAT()` (available from SQLite 3.38+).

    ```sh
    bash db/topsic-contest010-4/00_init.sh
    ```

    The script verifies that outputs of
    [`01_response.sql`](db/topsic-contest010-4/01_response.sql)
    and
    [`02_solution.sql`](db/topsic-contest010-4/02_solution.sql)
    match after each randomized delete round.

    Contest write-ups in [`doc`](doc) may not ship runnable SQL alongside
    [`db`](db). Add folders like
    [`topsic-contest010-4`](db/topsic-contest010-4)
    (`00_init.sh` and companion `.sql` files) when you reproduce a task.

## Document

### TOPSIC SQL Contest

-   [ルール](doc/topsic-contest-rules.md)
-   [SQLiteの注意点](doc/topsic-contest-sqlite.md)
-   [練習用コンテスト](doc/topsic-contest000-0.md)
-   [第1回 SQLコンテスト](doc/topsic-contest001-0.md)
-   [第2回 SQLコンテスト](doc/topsic-contest002-0.md)
-   [第3回 SQLコンテスト](doc/topsic-contest003-0.md)
