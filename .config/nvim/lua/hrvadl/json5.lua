return {
  "Joakker/lua-json5",
  build = "./install.sh",
  config = function()
    package.cpath = "./?.dylib;" .. package.cpath
    table.insert(vim._so_trails, "/?.dylib")
  end,
}
