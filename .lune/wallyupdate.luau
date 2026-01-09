local process = require "@lune/process"

process.exec("wally", { "install" })
process.exec("rojo", { "sourcemap", "base.project.json", "--output", "sourcemap.json" })
process.exec("wally-package-types", { "--sourcemap", "sourcemap.json", "Packages/" })
print "ran wallyUpdate processes!"
