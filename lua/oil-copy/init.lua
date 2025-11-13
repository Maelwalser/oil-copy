local M = {}

--- @param opts table | nil
function M.setup(opts)
  opts = opts or {}
  opts.keymap = opts.keymap or "<leader>cf"

  local core = require("oil-copy.core")

  local new_keymaps = {
    [opts.keymap] = {
      callback = core.copy_entry_contents,
      desc = "Copy entry contents to clipboard",
      mode = "n",
    },
  }

  local lazy_oil_opts = {}
  
  local spec_ok, lazy_core_spec = pcall(require, "lazy.core.spec")

  if spec_ok then
    local lazy_spec = lazy_core_spec.find("oil.nvim")
    if lazy_spec and lazy_spec.opts then
      lazy_oil_opts = vim.deepcopy(lazy_spec.opts)
    end
  else
    vim.notify("lazy.core.spec not found, cannot merge oil opts", vim.log.levels.WARN)
  end

  local final_oil_opts = vim.tbl_deep_extend(
    "force",
    lazy_oil_opts,
    {
      keymaps = new_keymaps,
    }
  )

  require("oil").setup(final_oil_opts)
end

return M
