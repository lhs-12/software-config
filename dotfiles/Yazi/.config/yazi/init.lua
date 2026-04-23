local home = os.getenv("HOME")
if home then pcall(function() require("omp"):setup({ config = home .. "/.omp.json" }) end) end

require("full-border"):setup()