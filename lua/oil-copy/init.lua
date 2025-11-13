local M = {}

--- @param opts table | nil
function M.setup(opts)
  local core = require("oil-copy.core")

  opts = opts or {}
  local keymap = opts.keymap or "<leader>cf"
  local keymap_desc = "Copy entry contents to clipboard"
  local augroup = vim.api.nvim_create_augroup("OilCopySetup", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    group = augroup,
    callback = function(args)
      vim.keymap.set("n", keymap, core.copy_entry_contents, {
        buffer = args.buf,
        desc = keymap_desc,
      })
    end,
  })
end

return M
