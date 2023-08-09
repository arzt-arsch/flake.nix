require("nvim-autopairs").setup({})

_G.toggle_autopairs = function()
  local ok, autopairs = pcall(require, "nvim-autopairs")
  if ok then
    if autopairs.state.disabled then
      autopairs.enable()
      print("autopairs on")
    else
      autopairs.disable()
      print("autopairs off")
    end
  else
    print("autopairs not available")
  end
end
