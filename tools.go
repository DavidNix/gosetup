// +build tools

package tools

import (
	_ "github.com/Arkweid/lefthook"
	_ "github.com/cortesi/modd/cmd/modd"
	_ "golang.org/x/tools/go/analysis/passes/shadow/cmd/shadow"
	_ "honnef.co/go/tools/cmd/staticcheck"
	// Uncomment if you need database migrations
	// _ "github.com/golang-migrate/migrate"
)
