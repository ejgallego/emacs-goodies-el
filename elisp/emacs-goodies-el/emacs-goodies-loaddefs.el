;;; emacs-goodies-loaddefs.el --- automatically extracted autoloads
;;
;;; Code:

;;;### (autoloads (all) "all" "all.el" (16059 54755))
;;; Generated autoloads from all.el

(autoload (quote all) "all" "\
Show all lines in the current buffer containing a match for REGEXP.

If a match spreads across multiple lines, all those lines are shown.

Each line is displayed with NLINES lines before and after, or -NLINES
before if NLINES is negative.
NLINES defaults to `list-matching-lines-default-context-lines'.
Interactively it is the prefix arg.

The lines are shown in a buffer named `*All*'.
Any changes made in that buffer will be propagated to this buffer." t nil)

;;;***

;;;### (autoloads (bar-cursor-change bar-cursor-mode) "bar-cursor"
;;;;;;  "bar-cursor.el" (16253 43285))
;;; Generated autoloads from bar-cursor.el

(autoload (quote bar-cursor-mode) "bar-cursor" "\
Toggle use of variable `bar-cursor-mode'.
This quasi-minor mode changes cursor to a bar cursor in insert mode,
and a block cursor in overwrite mode.  It may only be turned on and
off globally, not on a per-buffer basis (hence the quasi- designation).

Optional ARG turns mode on if ARG is a positive integer." t nil)

(autoload (quote bar-cursor-change) "bar-cursor" "\
Enable or disable advice based on value of variable `bar-cursor-mode'." nil nil)

;;;***

;;;### (autoloads (boxquote-unbox boxquote-unbox-region boxquote-fill-paragraph
;;;;;;  boxquote-kill boxquote-narrow-to-boxquote-content boxquote-narrow-to-boxquote
;;;;;;  boxquote-text boxquote-shell-command boxquote-describe-key
;;;;;;  boxquote-describe-variable boxquote-describe-function boxquote-boxquote
;;;;;;  boxquote-paragraph boxquote-defun boxquote-yank boxquote-kill-ring-save
;;;;;;  boxquote-insert-file boxquote-buffer boxquote-region boxquote-title)
;;;;;;  "boxquote" "boxquote.el" (16107 56175))
;;; Generated autoloads from boxquote.el

(autoload (quote boxquote-title) "boxquote" "\
Set the title of the current boxquote to TITLE.

If TITLE is an empty string the title is removed. Note that the title will
be formatted using `boxquote-title-format'." t nil)

(autoload (quote boxquote-region) "boxquote" "\
Draw a box around the left hand side of a region bounding START and END." t nil)

(autoload (quote boxquote-buffer) "boxquote" "\
Apply `boxquote-region' to a whole buffer." t nil)

(autoload (quote boxquote-insert-file) "boxquote" "\
Insert the contents of a file, boxed with `boxquote-region'.

If `boxquote-title-files' is non-nil the boxquote will be given a title that
is the result applying `boxquote-file-title-funciton' to FILENAME." t nil)

(autoload (quote boxquote-kill-ring-save) "boxquote" "\
Like `kill-ring-save' but remembers a title if possible.

The title is acquired by calling `boxquote-kill-ring-save-title'. The title
will be used by `boxquote-yank'." t nil)

(autoload (quote boxquote-yank) "boxquote" "\
Do a `yank' and box it in with `boxquote-region'.

If the yanked entry was placed on the kill ring with
`boxquote-kill-ring-save' the resulting boxquote will be titled with
whatever `boxquote-kill-ring-save-title' returned at the time." t nil)

(autoload (quote boxquote-defun) "boxquote" "\
Apply `boxquote-region' the current defun." t nil)

(autoload (quote boxquote-paragraph) "boxquote" "\
Apply `boxquote-region' to the current paragraph." t nil)

(autoload (quote boxquote-boxquote) "boxquote" "\
Apply `boxquote-region' to the current boxquote." t nil)

(autoload (quote boxquote-describe-function) "boxquote" "\
Call `describe-function' and boxquote the output into the current buffer." t nil)

(autoload (quote boxquote-describe-variable) "boxquote" "\
Call `describe-variable' and boxquote the output into the current buffer." t nil)

(autoload (quote boxquote-describe-key) "boxquote" "\
Call `describe-key' and boxquote the output into the current buffer." t nil)

(autoload (quote boxquote-shell-command) "boxquote" "\
Call `shell-command' with COMMAND and boxquote the output." t nil)

(autoload (quote boxquote-text) "boxquote" "\
Insert TEXT, boxquoted." t nil)

(autoload (quote boxquote-narrow-to-boxquote) "boxquote" "\
Narrow the buffer to the current boxquote." t nil)

(autoload (quote boxquote-narrow-to-boxquote-content) "boxquote" "\
Narrow the buffer to the content of the current boxquote." t nil)

(autoload (quote boxquote-kill) "boxquote" "\
Kill the boxquote and its contents." t nil)

(autoload (quote boxquote-fill-paragraph) "boxquote" "\
Perform a `fill-paragraph' inside a boxquote." t nil)

(autoload (quote boxquote-unbox-region) "boxquote" "\
Remove a box created with `boxquote-region'." t nil)

(autoload (quote boxquote-unbox) "boxquote" "\
Remove the boxquote that contains `point'." t nil)

;;;***

;;;### (autoloads (browse-kill-ring browse-kill-ring-default-keybindings)
;;;;;;  "browse-kill-ring" "browse-kill-ring.el" (16107 56175))
;;; Generated autoloads from browse-kill-ring.el

(autoload (quote browse-kill-ring-default-keybindings) "browse-kill-ring" "\
Set up M-y (`yank-pop') so that it can invoke `browse-kill-ring'.
Normally, if M-y was not preceeded by C-y, then it has no useful
behavior.  This function sets things up so that M-y will invoke
`browse-kill-ring'." t nil)

(autoload (quote browse-kill-ring) "browse-kill-ring" "\
Display items in the `kill-ring' in another buffer." t nil)

;;;***

;;;### (autoloads (coffee) "coffee" "coffee.el" (16222 36565))
;;; Generated autoloads from coffee.el

(autoload (quote coffee) "coffee" "\
Submit a BREW request to an RFC2324-compliant coffee device" t nil)

;;;***

;;;### (autoloads (df) "df" "df.el" (16111 43155))
;;; Generated autoloads from df.el

(autoload (quote df) "df" "\
Enables display of space left on any PARTITION in mode-lines.
This display updates automatically every `df-refresh' seconds." t nil)

;;;***

;;;### (autoloads (diminished-modes diminish-undo diminish) "diminish"
;;;;;;  "diminish.el" (16253 43285))
;;; Generated autoloads from diminish.el

(autoload (quote diminish) "diminish" "\
Diminish mode-line display of minor mode MODE to TO-WHAT (default \"\").

Interactively, enter (with completion) the name of any minor mode, followed
on the next line by what you want it diminished to (default empty string).
The response to neither prompt should be quoted.  However, in Lisp code,
both args must be quoted, the first as a symbol, the second as a string,
as in (diminish 'jiggle-mode \" Jgl\").

The mode-line displays of minor modes usually begin with a space, so
the modes' names appear as separate words on the mode line.  However, if
you're having problems with a cramped mode line, you may choose to use single
letters for some modes, without leading spaces.  Capitalizing them works
best; if you then diminish some mode to \"X\" but have abbrev-mode enabled as
well, you'll get a display like \"AbbrevX\".  This function prepends a space
to TO-WHAT if it's > 1 char long & doesn't already begin with a space.

If ANNOTATE-FLAG is nil or omitted, the normal case in interactive use, then
the variable `diminished-minor-modes' will be modified to reflect the change." t nil)

(autoload (quote diminish-undo) "diminish" "\
Restore mode-line display of diminished mode MODE to its minor-mode value.
Do nothing if the arg is a minor mode that hasn't been diminished.

Interactively, enter (with completion) the name of any diminished mode (a
mode that was formerly a minor mode on which you invoked M-x diminish).
To restore all diminished modes to minor status, answer `diminished-modes'.
The response to the prompt shouldn't be quoted.  However, in Lisp code,
the arg must be quoted as a symbol, as in (diminish-undo 'diminished-modes).

If ANNOTATE-FLAG is nil or omitted, the normal case in interactive use, then
the variable `diminished-minor-modes' will be modified to reflect the change." t nil)

(autoload (quote diminished-modes) "diminish" "\
Echo all active diminished or minor modes as if they were minor.
The display goes in the echo area; if it's too long even for that,
you can see the whole thing in the *Messages* buffer.
This doesn't change the status of any modes; it just lets you see
what diminished modes would be on the mode-line if they were still minor." t nil)

;;;***

;;;### (autoloads (egocentric-update-regexp-list egocentric-mode-off
;;;;;;  egocentric-mode-on egocentric-mode) "egocentric" "egocentric.el"
;;;;;;  (16107 56176))
;;; Generated autoloads from egocentric.el

(autoload (quote egocentric-mode) "egocentric" "\
Toggle egocentric mode.
Optional argument ARG is an optional boolean controling whether egocentric-mode should be turned on/off." t nil)

(autoload (quote egocentric-mode-on) "egocentric" "\
Turn Egocentric mode on." t nil)

(autoload (quote egocentric-mode-off) "egocentric" "\
Turn Egocentric mode off." t nil)

(autoload (quote egocentric-update-regexp-list) "egocentric" "\
Update ``egocentric-regexp-list'' from $USER and $NAME variables." t nil)

;;;***

;;;### (autoloads (ff-paths-install) "ff-paths" "ff-paths.el" (16188
;;;;;;  18180))
;;; Generated autoloads from ff-paths.el

(autoload (quote ff-paths-install) "ff-paths" "\
Install ff-paths as a `find-file-not-found-hooks' and to ffap package." nil nil)

;;;***

;;;### (autoloads (floatbg-mode) "floatbg" "floatbg.el" (16107 56176))
;;; Generated autoloads from floatbg.el

(autoload (quote floatbg-mode) "floatbg" "\
Toggle floatbg mode" t nil)

;;;***

;;;### (autoloads (highlight-beyond-fill-column) "highlight-beyond-fill-column"
;;;;;;  "highlight-beyond-fill-column.el" (16253 43285))
;;; Generated autoloads from highlight-beyond-fill-column.el

(autoload (quote highlight-beyond-fill-column) "highlight-beyond-fill-column" "\
Setup this buffer to highlight beyond the `fill-column'." t nil)

;;;***

;;;### (autoloads (highlight-current-line-minor-mode) "highlight-current-line"
;;;;;;  "highlight-current-line.el" (16235 37445))
;;; Generated autoloads from highlight-current-line.el

(autoload (quote highlight-current-line-minor-mode) "highlight-current-line" "\
Toggle highlight-current-line minor mode.
With ARG, turn minor mode on if ARG is positive, off otherwise.
You can customize the face of the highlighted line and whether the entire
line is hightlighted by customizing the group highlight-current-line." t nil)

;;;***

;;;### (autoloads (home-end-end home-end-home) "home-end" "home-end.el"
;;;;;;  (16253 43285))
;;; Generated autoloads from home-end.el

(autoload (quote home-end-home) "home-end" "\
Go to beginning of line/window/buffer.
First hitting key goes to beginning of line, second in a row goes to
beginning of window, third in a row goes to beginning of buffer." t nil)

(autoload (quote home-end-end) "home-end" "\
Go to end of line/window/buffer.
First hitting key goes to end of line, second in a row goes to end
of window, third in a row goes to end of buffer." t nil)

;;;***

;;;### (autoloads (htmlize-many-files-dired htmlize-many-files htmlize-file
;;;;;;  htmlize-region htmlize-buffer htmlize-buffer-noninteractive)
;;;;;;  "htmlize" "htmlize.el" (16107 56177))
;;; Generated autoloads from htmlize.el

(autoload (quote htmlize-buffer-noninteractive) "htmlize" "\
Convert BUFFER to HTML, preserving the font-lock and other colorization.
Returns the buffer with the resulting text.
If htmlize-major-mode is non-nil, this funcall the mode.  If this is
not what you want in a non-interactive environment, bind htmlize-major-mode
to nil before calling this function." nil nil)

(autoload (quote htmlize-buffer) "htmlize" "\
Convert BUFFER to HTML, preserving the font-lock and other colorization.
HTML contents are provided in a new buffer." t nil)

(autoload (quote htmlize-region) "htmlize" "\
Convert the region to HTML, preserving the font-lock colorization." t nil)

(autoload (quote htmlize-file) "htmlize" "\
HTML-ize FILE, and save the result.
If TARGET-DIRECTORY is non-nil, the resulting HTML file will be saved
to that directory, instead of to the FILE's directory." t nil)

(autoload (quote htmlize-many-files) "htmlize" "\
HTML-ize files specified by FILES, and save them to `.html' files.
If TARGET-DIRECTORY is specified, the HTML files will be saved to that
directory.  Normally, each HTML file is saved to the directory of the
corresponding source file." t nil)

(autoload (quote htmlize-many-files-dired) "htmlize" "\
HTMLize dired-marked files." t nil)

;;;***

;;;### (autoloads (ibuffer) "ibuffer" "ibuffer.el" (16107 56177))
;;; Generated autoloads from ibuffer.el

(defsubst ibuffer-and-update (&optional other-window-p) "\
Like `ibuffer', but update the list of buffers too.
With optional prefix argument, use another window." (interactive "P") (ibuffer other-window-p nil nil t))

(defsubst ibuffer-and-update-other-window nil "\
Like `ibuffer-and-update', but use another window." (interactive) (ibuffer-and-update t))

(autoload (quote ibuffer) "ibuffer" "\
Begin using `ibuffer' to edit a list of buffers.
Type 'h' after entering ibuffer for more information.

Optional argument OTHER-WINDOW-P says to use another window.
Optional argument NAME specifies the name of the buffer; it defaults
to \"*Ibuffer*\".
Optional argument QUALIFIERS is an initial set of limiting qualifiers
to use; see `ibuffer-limiting-qualifiers'." t nil)

;;;***

;;;### (autoloads (keydef) "keydef" "keydef.el" (16107 56178))
;;; Generated autoloads from keydef.el

(autoload (quote keydef) "keydef" "\
Define the key sequence SEQ, written in kbd form, to run CMD.
CMD is automatically wrapped in an anonymous interactive function if it
is Emacs Lisp code rather than a command name. SEQ may also have the form
\(MODE SEQ) where the car is a mode name; for example

  (keydef (latex \"C-c %\") comment-region)

means to define the given key in latex-mode-map. And this will work even
if latex-mode is not loaded yet, provided that it is possible to deduce
the file that it will be loaded from, either from the autoload info or
by searching for a matching file name in the Emacs load path.

For best results, the \"mode name\" that you use here should yield the
proper foo-mode-map symbol when \"-mode-map\" is appended; although
this will normally match the mode name as given in the mode line,
Shell-script is one example I can think of where it doesn't---the map is
named sh-mode-map. The common cases that I know about, including
shell-script-mode and latex-mode, are handled as exceptions through the
variable mode-map-alist. But for other cases you will need to look up
the name of the mode-map that goes with the given mode." nil (quote macro))

;;;***

;;;### (autoloads (muttrc-mode) "muttrc-mode" "muttrc-mode.el" (16253
;;;;;;  43285))
;;; Generated autoloads from muttrc-mode.el

(autoload (quote muttrc-mode) "muttrc-mode" "\
Major mode for editing Muttrc files.
This function ends by invoking the function(s) `muttrc-mode-hook'.

\\{muttrc-mode-map}
" t nil)

;;;***

;;;### (autoloads (nuke-trailing-whitespace) "nuke-trailing-whitespace"
;;;;;;  "nuke-trailing-whitespace.el" (16253 43286))
;;; Generated autoloads from nuke-trailing-whitespace.el

(autoload (quote nuke-trailing-whitespace) "nuke-trailing-whitespace" "\
Nuke all trailing whitespace in the buffer.
Whitespace in this case is just spaces or tabs.
This is a useful function to put on write-file-hooks.

Unless called interactively, this function uses
`nuke-trailing-whitespace-p' to determine how to behave.
However, even if this variable is `t', this function will query for
replacement if the buffer is read-only." t nil)

;;;***

;;;### (autoloads (obfuscate-url) "obfusurl" "obfusurl.el" (16107
;;;;;;  56178))
;;; Generated autoloads from obfusurl.el

(autoload (quote obfuscate-url) "obfusurl" "\
Obfuscate an URL under `point'.

This might be useful if you're writing out an URL for someone but the URL
itself is a spoiler. The URL will still work but it won't be readable (by
most mortals anyway)." t nil)

;;;***

;;;### (autoloads (perldoc-perl-hook perldoc-at-point perldoc) "perldoc"
;;;;;;  "perldoc.el" (16253 43285))
;;; Generated autoloads from perldoc.el

(autoload (quote perldoc) "perldoc" "\
Run perldoc on the given STRING.
If the string is a recognised function then we can call `perldoc-function',
otherwise we call `perldoc-module'." t nil)

(autoload (quote perldoc-at-point) "perldoc" "\
Call `perldoc' for string at point." t nil)

(autoload (quote perldoc-perl-hook) "perldoc" "\
A hook which binds F1 to `perldoc-at-point'." nil nil)

;;;***

;;;### (autoloads (protect-process-buffer-from-kill-mode protect-buffer-from-kill-mode)
;;;;;;  "protbuf" "protbuf.el" (16107 56178))
;;; Generated autoloads from protbuf.el

(defvar protect-buffer-from-kill-mode nil "\
*If non-`nil', then prevent buffer from being accidentally killed.
This variable is local to all buffers.")

(defvar protect-process-buffer-from-kill-mode nil "\
*If non-`nil', then protect buffer with live process from being killed.
This variable is local to all buffers.")

(defvar protect-process-buffer-from-kill-preserve-function nil "\
*Function to run to determine whether to kill a process buffer.
If function returns non-nil, buffer is preserved.  Otherwise, the buffer
may be killed.

If this variable is undefined, default action is to test whether a process
object is using this buffer as a process buffer.

This variable is buffer-local when set.")

(autoload (quote protect-buffer-from-kill-mode) "protbuf" "\
Protect buffer from being killed.
To remove this protection, call this command with a negative prefix argument." t nil)

(autoload (quote protect-process-buffer-from-kill-mode) "protbuf" "\
Protect buffer from being killed as long as it has an active process.
To remove this protection, call this command with a negative prefix argument." t nil)

;;;***

;;;### (autoloads (protocols-clear-cache protocols-lookup) "protocols"
;;;;;;  "protocols.el" (16107 56178))
;;; Generated autoloads from protocols.el

(autoload (quote protocols-lookup) "protocols" "\
Find a protocol and display its details." t nil)

(autoload (quote protocols-clear-cache) "protocols" "\
Clear the protocols \"cache\"." t nil)

;;;***

;;;### (autoloads (services-clear-cache services-lookup) "services"
;;;;;;  "services.el" (16107 56178))
;;; Generated autoloads from services.el

(autoload (quote services-lookup) "services" "\
Find a service and display its details." t nil)

(autoload (quote services-clear-cache) "services" "\
Clear the services \"cache\"." t nil)

;;;***

;;;### (autoloads (sm-add-all-headers sm-add-random-header) "silly-mail"
;;;;;;  "silly-mail.el" (16107 56178))
;;; Generated autoloads from silly-mail.el

(autoload (quote sm-add-random-header) "silly-mail" "\
Insert a random silly mail header.
The choice of available headers is taken from sm-mail-header-table." t nil)

(autoload (quote sm-add-all-headers) "silly-mail" "\
Insert one of every kind of silly mail header defined.
The choice of available headers is taken from sm-mail-header-table." t nil)

;;;***

;;;### (autoloads (sys-apropos) "sys-apropos" "sys-apropos.el" (16107
;;;;;;  56178))
;;; Generated autoloads from sys-apropos.el

(autoload (quote sys-apropos) "sys-apropos" "\
Ask the system apropos command for man-pages matching QUERY." t nil)

;;;***

;;;### (autoloads (table-version table-release table-capture table-delete-column
;;;;;;  table-delete-row table-insert-sequence table-generate-source
;;;;;;  table-query-dimension table-fixed-width-mode table-justify-column
;;;;;;  table-justify-row table-justify-cell table-justify table-split-cell
;;;;;;  table-split-cell-horizontally table-split-cell-vertically
;;;;;;  table-span-cell table-backward-cell table-forward-cell table-narrow-cell
;;;;;;  table-widen-cell table-shorten-cell table-heighten-cell table-unrecognize-cell
;;;;;;  table-recognize-cell table-unrecognize-table table-recognize-table
;;;;;;  table-unrecognize-region table-recognize-region table-unrecognize
;;;;;;  table-recognize table-insert-row-column table-insert-column
;;;;;;  table-insert-row table-insert table-point-left-cell-hook
;;;;;;  table-point-entered-cell-hook table-load-hook table-cell-map-hook)
;;;;;;  "table" "table.el" (16107 56180))
;;; Generated autoloads from table.el

(defvar table-cell-map-hook nil "\
*Normal hooks run when finishing construction of `table-cell-map'.
User can modify `table-cell-map' by adding custom functions here.")

(defvar table-load-hook nil "\
*List of functions to be called after the table is first loaded.")

(defvar table-point-entered-cell-hook nil "\
*List of functions to be called after point entered a table cell.")

(defvar table-point-left-cell-hook nil "\
*List of functions to be called after point left a table cell.")

(autoload (quote table-insert) "table" "\
Insert an editable text table.
Insert a table of specified number of COLUMNS and ROWS.  Optional
parameter CELL-WIDTH and CELL-HEIGHT can specify the size of each
cell.  The cell size is uniform across the table if the specified size
is a number.  They can be a list of numbers to specify different size
for each cell.  When called interactively, the list of number is
entered by simply listing all the numbers with space characters
delimiting them.

Examples:

\\[table-insert] inserts a table at the current point location.

Suppose we have the following situation where `-!-' indicates the
location of point.

    -!-

Type \\[table-insert] and hit ENTER key.  As it asks table
specification, provide 3 for number of columns, 1 for number of rows,
5 for cell width and 1 for cell height.  Now you shall see the next
table and the point is automatically moved to the beginning of the
first cell.

    +-----+-----+-----+
    |-!-  |     |     |
    +-----+-----+-----+

Inside a table cell, there are special key bindings. \\<table-cell-map>

M-9 \\[table-widen-cell] (or \\[universal-argument] 9 \\[table-widen-cell]) widens the first cell by 9 character
width, which results as

    +--------------+-----+-----+
    |-!-           |     |     |
    +--------------+-----+-----+

Type TAB \\[table-widen-cell] then type TAB M-2 M-7 \\[table-widen-cell] (or \\[universal-argument] 2 7 \\[table-widen-cell]).  Typing
TAB moves the point forward by a cell. The result now looks like this:

    +--------------+------+--------------------------------+
    |              |      |-!-                             |
    +--------------+------+--------------------------------+

If you knew each width of the columns prior to the table creation,
what you could have done better was to have had given the complete
width information to `table-insert'.

Cell width(s): 14 6 32

instead of

Cell width(s): 5

This would have eliminated the previously mentioned width adjustment
work all together.

If the point is in the last cell type S-TAB S-TAB to move it to the
first cell.  Now type \\[table-heighten-cell] which heighten the row by a line.

    +--------------+------+--------------------------------+
    |-!-           |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+

Type \\[table-insert-row-column] and tell it to insert a row.

    +--------------+------+--------------------------------+
    |-!-           |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+

Move the point under the table as shown below.

    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    -!-

Type M-x table-insert-row instead of \\[table-insert-row-column].  \\[table-insert-row-column] does not work
when the point is outside of the table.  This insertion at
outside of the table effectively appends a row at the end.

    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    |-!-           |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+

Text editing inside the table cell produces reasonably expected
results.

    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+
    |              |      |Text editing inside the table   |
    |              |      |cell produces reasonably        |
    |              |      |expected results.-!-            |
    +--------------+------+--------------------------------+
    |              |      |                                |
    |              |      |                                |
    +--------------+------+--------------------------------+

Inside a table cell has a special keymap.

\\{table-cell-map}
" t nil)

(autoload (quote table-insert-row) "table" "\
Insert N table row(s).
When point is in a table the newly inserted row(s) are placed above
the current row.  When point is outside of the table it must be below
the table within the table width range, then the newly created row(s)
are appended at the bottom of the table." t nil)

(autoload (quote table-insert-column) "table" "\
Insert N table column(s).
When point is in a table the newly inserted column(s) are placed left
of the current column.  When point is outside of the table it must be
right side of the table within the table height range, then the newly
created column(s) are appended at the right of the table." t nil)

(autoload (quote table-insert-row-column) "table" "\
Insert row(s) or column(s).
See `table-insert-row' and `table-insert-column'." t nil)

(autoload (quote table-recognize) "table" "\
Recognize all tables within the current buffer and activate them.
Scans the entire buffer and recognizes valid table cells.  If the
optional numeric prefix argument ARG is negative the tables in the
buffer become inactive, meaning the tables become plain text and loses
all the table specific features." t nil)

(autoload (quote table-unrecognize) "table" nil t nil)

(autoload (quote table-recognize-region) "table" "\
Recognize all tables within region.
BEG and END specify the region to work on.  If the optional numeric
prefix argument ARG is negative the tables in the region become
inactive, meaning the tables become plain text and lose all the table
specific features." t nil)

(autoload (quote table-unrecognize-region) "table" nil t nil)

(autoload (quote table-recognize-table) "table" "\
Recognize a table at point.
If the optional numeric prefix argument ARG is negative the table
becomes inactive, meaning the table becomes plain text and loses all
the table specific features." t nil)

(autoload (quote table-unrecognize-table) "table" nil t nil)

(autoload (quote table-recognize-cell) "table" "\
Recognize a table cell that contains current point.
Probe the cell dimension and prepare the cell information.  The
optional two arguments FORCE and NO-COPY are for internal use only and
must not be specified.  When the optional numeric prefix argument ARG
is negative the cell becomes inactive, meaning that the cell becomes
plain text and loses all the table specific features." t nil)

(autoload (quote table-unrecognize-cell) "table" nil t nil)

(autoload (quote table-heighten-cell) "table" "\
Heighten the current cell by N lines by expanding the cell vertically.
Heightening is done by adding blank lines at the bottom of the current
cell.  Other cells aligned horizontally with the current one are also
heightened in order to keep the rectangular table structure.  The
optional argument NO-COPY is internal use only and must not be
specified." t nil)

(autoload (quote table-shorten-cell) "table" "\
Shorten the current cell by N lines by shrinking the cell vertically.
Shortening is done by removing blank lines from the bottom of the cell
and possibly from the top of the cell as well.  Therefor, the cell
must have some bottom/top blank lines to be shorten effectively.  This
is applicable to all the cells aligned horizontally with the current
one because they are also shortened in order to keep the rectangular
table structure." t nil)

(autoload (quote table-widen-cell) "table" "\
Widen the current cell by N columns and expand the cell horizontally.
Some other cells in the same table are widen as well to keep the
table's rectangle structure." t nil)

(autoload (quote table-narrow-cell) "table" "\
Narrow the current cell by N columns and shrink the cell horizontally.
Some other cells in the same table are narrowed as well to keep the
table's rectangle structure." t nil)

(autoload (quote table-forward-cell) "table" "\
Move point forward to the beginning of the next cell.
With argument ARG, do it ARG times;
a negative argument ARG = -N means move backward N cells.
Do not specify NO-RECOGNIZE and UNRECOGNIZE. They are for internal use only.

Sample Cell Traveling Order (In Irregular Table Cases)

You can actually try how it works in this buffer.  Press
\\[table-recognize] and go to cells in the following tables and press
\\[table-forward-cell] or TAB key.

+-----+--+  +--+-----+  +--+--+--+  +--+--+--+  +---------+  +--+---+--+
|0    |1 |  |0 |1    |  |0 |1 |2 |  |0 |1 |2 |  |0        |  |0 |1  |2 |
+--+--+  |  |  +--+--+  +--+  |  |  |  |  +--+  +----+----+  +--+-+-+--+
|2 |3 |  |  |  |2 |3 |  |3 +--+  |  |  +--+3 |  |1   |2   |  |3   |4   |
|  +--+--+  +--+--+  |  +--+4 |  |  |  |4 +--+  +--+-+-+--+  +----+----+
|  |4    |  |4    |  |  |5 |  |  |  |  |  |5 |  |3 |4  |5 |  |5        |
+--+-----+  +-----+--+  +--+--+--+  +--+--+--+  +--+---+--+  +---------+

+--+--+--+  +--+--+--+  +--+--+--+  +--+--+--+
|0 |1 |2 |  |0 |1 |2 |  |0 |1 |2 |  |0 |1 |2 |
|  |  |  |  |  +--+  |  |  |  |  |  +--+  +--+
+--+  +--+  +--+3 +--+  |  +--+  |  |3 +--+4 |
|3 |  |4 |  |4 +--+5 |  |  |3 |  |  +--+5 +--+
|  |  |  |  |  |6 |  |  |  |  |  |  |6 |  |7 |
+--+--+--+  +--+--+--+  +--+--+--+  +--+--+--+

+--+--+--+  +--+--+--+  +--+--+--+--+  +--+-----+--+  +--+--+--+--+
|0 |1 |2 |  |0 |1 |2 |	|0 |1 |2 |3 |  |0 |1    |2 |  |0 |1 |2 |3 |
|  +--+  |  |  +--+  |	|  +--+--+  |  |  |     |  |  |  +--+--+  |
|  |3 +--+  +--+3 |  |	+--+4    +--+  +--+     +--+  +--+4    +--+
+--+  |4 |  |4 |  +--+	|5 +--+--+6 |  |3 +--+--+4 |  |5 |     |6 |
|5 +--+  |  |  +--+5 |	|  |7 |8 |  |  |  |5 |6 |  |  |  |     |  |
|  |6 |  |  |  |6 |  |	+--+--+--+--+  +--+--+--+--+  +--+-----+--+
+--+--+--+  +--+--+--+
" t nil)

(autoload (quote table-backward-cell) "table" "\
Move backward to the beginning of the previous cell.
With argument ARG, do it ARG times;
a negative argument ARG = -N means move forward N cells." t nil)

(autoload (quote table-span-cell) "table" "\
Span current cell into adjacent cell in DIRECTION.
DIRECTION is one of symbols; right, left, above or below." t nil)

(autoload (quote table-split-cell-vertically) "table" "\
Split current cell vertically.
Creates a cell above and a cell below the current point location." t nil)

(autoload (quote table-split-cell-horizontally) "table" "\
Split current cell horizontally.
Creates a cell on the left and a cell on the right of the current point location." t nil)

(autoload (quote table-split-cell) "table" "\
Split current cell in ORIENTATION.
ORIENTATION is a symbol either horizontally or vertically." t nil)

(autoload (quote table-justify) "table" "\
Justify contents of a cell, a row of cells or a column of cells.
WHAT is a symbol 'cell, 'row or 'column.  JUSTIFY is a symbol 'left,
'center, 'right, 'top, 'middle, 'bottom or 'none." t nil)

(autoload (quote table-justify-cell) "table" "\
Justify cell contents.
JUSTIFY is a symbol 'left, 'center or 'right for horizontal, or 'top,
'middle, 'bottom or 'none for vertical.  When optional PARAGRAPH is
non-nil the justify operation is limited to the current paragraph,
otherwise the entire cell contents is justified." t nil)

(autoload (quote table-justify-row) "table" "\
Justify cells of a row.
JUSTIFY is a symbol 'left, 'center or 'right for horizontal, or top,
'middle, 'bottom or 'none for vertical." t nil)

(autoload (quote table-justify-column) "table" "\
Justify cells of a column.
JUSTIFY is a symbol 'left, 'center or 'right for horizontal, or top,
'middle, 'bottom or 'none for vertical." t nil)

(autoload (quote table-fixed-width-mode) "table" "\
Toggle fixing width mode.
In the fixed width mode, typing inside a cell never changes the cell
width where in the normal mode the cell width expands automatically in
order to prevent a word being folded into multiple lines." t nil)

(autoload (quote table-query-dimension) "table" "\
Return the dimension of the current cell and the current table.
The result is a list (cw ch tw th c r cells) where cw is the cell
width, ch is the cell height, tw is the table width, th is the table
height, c is the number of columns, r is the number of rows and cells
is the total number of cells.  The cell dimension excludes the cell
frame while the table dimension includes the table frame.  The columns
and the rows are counted by the number of cell boundaries.  Therefore
the number tends to be larger than it appears for the tables with
non-uniform cell structure (heavily spanned and split).  When optional
WHERE is provided the cell and table at that location is reported." t nil)

(autoload (quote table-generate-source) "table" "\
Generate source of the current table in the specified language.
LANGUAGE is a symbol that specifies the language to describe the
structure of the table.  It must be either 'html, 'latex, 'tei or
'cals.  The resulted source text is inserted into DEST-BUFFER and the
buffer object is returned.  When DEST-BUFFER is omitted or nil the
default buffer specified in `table-dest-buffer-name' is used.  In this
case the content of the default buffer is erased prior to the
generation.  When DEST-BUFFER is non-nil it is expected to be either a
destination buffer or a name of the destination buffer.  In this case
the generated result is inserted at the current point in the
destination buffer and the previously existing contents in the buffer
are untouched.

References used for this implementation:

HTML:
        http://www.w3.org

LaTeX:
        http://www.maths.tcd.ie/~dwilkins/LaTeXPrimer/Tables.html

TEI (Text Encoding Initiative XML/SGML DTD):
        http://www.hcu.ox.ac.uk/TEI/Guidelines/ (general)
        http://www.hcu.ox.ac.uk/TEI/Guidelines/FT.htm#FTTAB (tables)

CALS (DocBook DTD):
        http://www.oasis-open.org/html/a502.htm
        http://www.oreilly.com/catalog/docbook/chapter/book/table.html#AEN114751
" t nil)

(autoload (quote table-insert-sequence) "table" "\
Travel cells forward while inserting a specified sequence string in each cell.
STR is the base string from which the sequence starts.  When STR is an
empty string then each cell content is erased.  When STR ends with
numerical characters (they may optionally be surrounded by a pair of
parentheses) they are incremented as a decimal number.  Otherwise the
last character in STR is incremented in ASCII code order.  N is the
number of sequence elements to insert.  When N is negative the cell
traveling direction is backward.  When N is zero it travels forward
entire table.  INCREMENT is the increment between adjacent sequence
elements and can be a negative number for effectively decrementing.
INTERVAL is the number of cells to travel between sequence element
insertion which is normally 1.  When zero or less is given for
INTERVAL it is interpreted as number of cells per row so that sequence
is placed straight down vertically as long as the table's cell
structure is uniform.  JUSTIFY is one of the symbol 'left, 'center or
'right, that specifies justification of the inserted string.

Example:

  (progn
    (table-insert 16 3 5 1)
    (table-forward-cell 15)
    (table-insert-sequence \"D0\" -16 1 1 'center)
    (table-forward-cell 16)
    (table-insert-sequence \"A[0]\" -16 1 1 'center)
    (table-forward-cell 1)
    (table-insert-sequence \"-\" 16 0 1 'center))

  (progn
    (table-insert 16 8 5 1)
    (table-insert-sequence \"@\" 0 1 2 'right)
    (table-forward-cell 1)
    (table-insert-sequence \"64\" 0 1 2 'left))
" t nil)

(autoload (quote table-delete-row) "table" "\
Delete N row(s) of cells.
Delete N rows of cells from current row.  The current row is the row
contains the current cell where point is located.  Each row must
consists from cells of same height." t nil)

(autoload (quote table-delete-column) "table" "\
Delete N column(s) of cells.
Delete N columns of cells from current column.  The current column is
the column contains the current cell where point is located.  Each
column must consists from cells of same width." t nil)

(autoload (quote table-capture) "table" "\
Convert plain text into a table by capturing the text in the region.
Create a table with the text in region as cell contents.  BEG and END
specify the region.  The text in the region is replaced with a table.
The removed text is inserted in the table.  When optional
COL-DELIM-REGEXP and ROW-DELIM-REGEXP are provided the region contents
is parsed and separated into individual cell contents by using the
delimiter regular expressions.  This parsing determines the number of
columns and rows of the table automatically.  If COL-DELIM-REGEXP and
ROW-DELIM-REGEXP are omitted the result table has only one cell and
the entire region contents is placed in that cell.  Optional JUSTIFY
is one of 'left, 'center or 'right, which specifies the cell
justification.  Optional MIN-CELL-WIDTH specifies the minimum cell
width.  Optional COLUMNS specify the number of columns when
ROW-DELIM-REGEXP is not specified.


Example 1:

1, 2, 3, 4
5, 6, 7, 8
, 9, 10

Running `table-capture' on above 3 line region with COL-DELIM-REGEXP
\",\" and ROW-DELIM-REGEXP \"\\n\" creates the following table.  In
this example the cells are centered and minimum cell width is
specified as 5.

+-----+-----+-----+-----+
|  1  |  2  |  3  |  4  |
+-----+-----+-----+-----+
|  5  |  6  |  7  |  8  |
+-----+-----+-----+-----+
|     |  9  | 10  |     |
+-----+-----+-----+-----+

Note:

In case the function is called interactively user must use \\[quoted-insert] `quoted-insert'
in order to enter \"\\n\" successfully.  COL-DELIM-REGEXP at the end
of each row is optional.


Example 2:

This example shows how a table can be used for text layout editing.
Let `table-capture' capture the following region starting from
-!- and ending at -*-, that contains three paragraphs and two item
name headers.  This time specify empty string for both
COL-DELIM-REGEXP and ROW-DELIM-REGEXP.

-!-`table-capture' is a powerful command however mastering its power
requires some practice.  Here is a list of items what it can do.

Parse Cell Items      By using column delimiter regular
		      expression and raw delimiter regular
		      expression, it parses the specified text
		      area and extracts cell items from
		      non-table text and then forms a table out
		      of them.

Capture Text Area     When no delimiters are specified it
		      creates a single cell table.  The text in
		      the specified region is placed in that
		      cell.-*-

Now the entire content is captured in a cell which is itself a table
like this.

+-----------------------------------------------------------------+
|`table-capture' is a powerful command however mastering its power|
|requires some practice.  Here is a list of items what it can do. |
|                                                                 |
|Parse Cell Items      By using column delimiter regular          |
|                      expression and raw delimiter regular       |
|                      expression, it parses the specified text   |
|                      area and extracts cell items from          |
|                      non-table text and then forms a table out  |
|                      of them.                                   |
|                                                                 |
|Capture Text Area     When no delimiters are specified it        |
|                      creates a single cell table.  The text in  |
|                      the specified region is placed in that     |
|                      cell.                                      |
+-----------------------------------------------------------------+

By splitting the cell appropriately we now have a table consisting of
paragraphs occupying its own cell.  Each cell can now be edited
independently.

+-----------------------------------------------------------------+
|`table-capture' is a powerful command however mastering its power|
|requires some practice.  Here is a list of items what it can do. |
+---------------------+-------------------------------------------+
|Parse Cell Items     |By using column delimiter regular          |
|                     |expression and raw delimiter regular       |
|                     |expression, it parses the specified text   |
|                     |area and extracts cell items from          |
|                     |non-table text and then forms a table out  |
|                     |of them.                                   |
+---------------------+-------------------------------------------+
|Capture Text Area    |When no delimiters are specified it        |
|                     |creates a single cell table.  The text in  |
|                     |the specified region is placed in that     |
|                     |cell.                                      |
+---------------------+-------------------------------------------+

By applying `table-release', which does the opposite process, the
contents become once again plain text.  `table-release' works as
companion command to `table-capture' this way.
" t nil)

(autoload (quote table-release) "table" "\
Convert a table into plain text by removing the frame from a table.
Remove the frame from a table and inactivate the table.  This command
converts a table into plain text without frames.  It is a companion to
`table-capture' which does the opposite process." t nil)

(autoload (quote table-version) "table" "\
Show version number of table package." t nil)

;;;***

;;;### (autoloads (trivial-cite) "tc" "tc.el" (16107 56180))
;;; Generated autoloads from tc.el

(autoload (quote trivial-cite) "tc" "\
trivial-cite is a simple citation function for use in news/mailreaders.
It parses the headers via the functions defined in tc-header-funs, then
makes a attribution for the citation using tc-make-attribution and indents
the inserted text with tc-indent-citation.
Numeric prefix arguments is how many lines of body to cite (useful for citing
mails with long attachments).
Usage:  (auto-load 'trivial-cite \"tc\" t t)
        (add-hook 'mail-citation-hook 'trivial-cite)
Bugs:  Not very intelligent about old citation marks other than '>'.
Customization:  See variables tc-fill-long-lines, tc-remove-signature,
tc-citation-string, tc-make-attribution and tc-header-funs." nil nil)

;;;***

;;;### (autoloads (thinks-maybe-region thinks-yank thinks-region
;;;;;;  thinks) "thinks" "thinks.el" (16107 56180))
;;; Generated autoloads from thinks.el

(autoload (quote thinks) "thinks" "\
Insert TEXT wrapped in a think bubble.

Prefix a call to this function with \\[universal-argument] if you don't want
the text to be filled for you." t nil)

(autoload (quote thinks-region) "thinks" "\
Bubble wrap region bounding START and END.

Prefix a call to this function with \\[universal-argument] if you don't want
the text to be filled for you." t nil)

(autoload (quote thinks-yank) "thinks" "\
Do a `yank' and bubble wrap the yanked text.

Prefix a call to this function with \\[universal-argument] if you don't want
the text to be filled for you." t nil)

(autoload (quote thinks-maybe-region) "thinks" "\
If region is active, bubble wrap region bounding START and END.
If not, query for text to insert in bubble." t nil)

;;;***

;;;### (autoloads (tld) "tld" "tld.el" (16107 56180))
;;; Generated autoloads from tld.el

(autoload (quote tld) "tld" "\
Search the TLD list." t nil)

;;;***

;;;### (autoloads (twiddle-compile twiddle-start) "twiddle" "twiddle.el"
;;;;;;  (16107 56180))
;;; Generated autoloads from twiddle.el

(autoload (quote twiddle-start) "twiddle" "\
Start a mode line display hack.
If called interactively with a prefix argument, prompt for the name of
a hack to run.  If called from lisp, optional argument HACK is the name of
a hack to run.
Named hacks are defined in the table `twiddle-hacks'." t nil)

(autoload (quote twiddle-compile) "twiddle" "\
Like \\[compile], but run a twiddle hack during compilation.
If called with a prefix argument, prompt for a specific hack to run." t nil)

;;;***

;;;### (autoloads (wdired-change-to-wdired-mode) "wdired" "wdired.el"
;;;;;;  (16107 56180))
;;; Generated autoloads from wdired.el

(autoload (quote wdired-change-to-wdired-mode) "wdired" "\
Put a dired buffer in a mode in which filenames are editable.
In this mode the names of the files can be changed, and after
typing C-c C-c the files and directories in disk are renamed.

See `wdired-mode'." t nil)

;;;***

;;;### (autoloads (xrdb-mode) "xrdb-mode" "xrdb-mode.el" (16107 56181))
;;; Generated autoloads from xrdb-mode.el

(autoload (quote xrdb-mode) "xrdb-mode" "\
Major mode for editing xrdb config files" t nil)

;;;***

;;;### (autoloads (all) "all" "all.el" (16107 56175))
;;; Generated autoloads from all.el

(autoload (quote all) "all" "\
Show all lines in the current buffer containing a match for REGEXP.

If a match spreads across multiple lines, all those lines are shown.

Each line is displayed with NLINES lines before and after, or -NLINES
before if NLINES is negative.
NLINES defaults to `list-matching-lines-default-context-lines'.
Interactively it is the prefix arg.

The lines are shown in a buffer named `*All*'.
Any changes made in that buffer will be propagated to this buffer." t nil)

;;;***

(provide 'emacs-goodies-loaddefs)

;;; emacs-goodies-loaddefs.el ends here
