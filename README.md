# rustfmt.el - OBSOLETE

[![MELPA][badge-melpa]](http://melpa.org/#/rustfmt)

**This package has been merged into rust-mode. Please use that instead.**

Format rust code in emacs using [rustfmt][].

## Install

Ensure you are using MELPA:

```lisp
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
```

Then install the "rustfmt" package:

* `M-x package-list-packages`
* Find the "rustfmt" and install with `I`

## Usage

Run <kbd>M-x rustfmt-format-buffer</kbd> to format the current buffer.

For convenience, you may bind it to a key, such as:
```el
(define-key rust-mode-map (kbd "C-c C-f") #'rustfmt-format-buffer)
```

Alternatively, run rustfmt before saving rust buffers:
```el
(add-hook 'rust-mode-hook #'rustfmt-enable-on-save)
```

[rustfmt]: https://github.com/nrc/rustfmt
[badge-melpa]: http://melpa.org/packages/rustfmt-badge.svg
