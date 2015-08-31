# rustfmt.el

[![MELPA][badge-melpa]](http://melpa.org/#/rustfmt)

Format rust code in emacs using [rustfmt][].

## Usage

Run <kbd>M-x rustfmt-format-buffer</kbd> to format the current buffer.

For convenience, you may bind it to a key, such as:
```el
(define-key rust-mode-map (kbd "C-c C-f") #'rustfmt-format-buffer)
```

[rustfmt]: https://github.com/nrc/rustfmt
[badge-melpa]: http://melpa.org/packages/rustfmt-badge.svg
