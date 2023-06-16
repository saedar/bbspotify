# bbspotify

Takehome - CLI To Add, Remove, Or Update Playlists

## Making It Executable

### File Permissions

Newly created files are sometimes unavailable to all users of a system. In order to ensure any user can utilize the executable, you may need to update file permissions.

1. Navigate to the `bin` directory of the project.
2. Execute `chmod 777 bbspotify` to set READ/WRITE/EXECUTE privs.

### Make Executable Available System-Wide

We will be symlinking the executable to `/usr/local/bin` to not conflict with system binaries.

`sudo ln -s ~/your/local/path/bbspotify/bin/bbspotify /usr/local/bin`

Note: Do not use the filename (`bbspotify`) as the sole source from its directory. You need to use a system path to avoid a `too many symlink levels` error.

## Using The Utility

Once the executable is properly symlinked, that user can call the executable directly and provide the required files.

Example: `bbspotify ./vendor/spotify.json ./vendor/test_changes.json`

## Validate The Output

You can copy the file output to the [JSON Lint](https://jsonlint.com/) utility to verify that the output json is valid.

## Scaling Out

Given very large files, it could be beneficial to do some kind of concurrent execution. I would split the different possible change sections into their own process to run at the same time. If there was a high volume of change requests, it might also be useful to build out an enqueing system to handle things async or even to enforce rate limits on requests.

You can also combine the two ideas (concurrency and enqueing) by including multiple worker processes to burn down large requests quickly and in a more controllable manner.

## Design Notes

I opted to make the system able to handle batch changes. One-off changes might be useful in certain use cases but the file-based change set gives the impression of needing to make several changes at once. I wanted to include data validation to protect against invalid change requests and hard-crashing the utility in the event of malformed data.

For the execution itself, I wanted to separate the different types of change requests into their own functions. This has a two-fold benefit of keeping things more readable and could make it easier for future enhancement to add in concurrency in the future.

## Task Summary

The entire project took me about two hours to complete including all research, development, testing, and documentation.

I have included a demo/test changeset file in the `vendor` directory including valid and invalid cases.
