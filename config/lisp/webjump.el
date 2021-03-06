;;; webjump.el --- webjump configuration
;;; Commentary:
;;; Code:

(setq webjump-sites
      '(("Google" . [simple-query "www.google.com" "www.google.com/search?q=" ""])
        ("DuckDuckGo" . [simple-query "duckduckgo.com" "duckduckgo.com/?q=" ""])
        ("MDN" . [simple-query "developer.mozilla.org" "developer.mozilla.org/en/search?q=" ""])
        ("Stackoverflow" . [simple-query "stackoverflow.com" "stackoverflow.com/search?q=" ""])
        ("Github" . [simple-query "github.com" "github.com/search?q=" ""])
        ))

;;; webjump.el ends here
