function _G.Reloadconfig ()
  local luacache = (_G.__luacache or {}).cache
  -- TODO unload commands, mappings + ?symbols?
  for pkg, _ in pairs(package.loaded) do
    if pkg:match '^my_.+'
    then
      print(pkg)
      package.loaded[pkg] = nil
      if luacache then
        lucache[pkg] = nil
      end
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify('Config reloaded!', vim.log.levels.INFO)
end
