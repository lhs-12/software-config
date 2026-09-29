local home = os.getenv("HOME")
if home then pcall(function() require("omp"):setup({ config = home .. "/.om-posh.json" }) end) end

require("full-border"):setup()