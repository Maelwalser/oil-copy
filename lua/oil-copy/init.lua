local M = {}

--- @param opts table | nil
function M.setup(opts)
  local core = require("oil-copy.core")

  opts = opts or {}
  local keymap = opts.keymap or "<leader>cf"
  local keymap_desc = "Copy entry contents to clipboard"
  local visual_keymap_desc = "Copy selected entries to clipboard"
  local augroup = vim.api.nvim_create_augroup("OilCopySetup", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "oil",
    group = augroup,
    callback = function(args)
      -- Normal mode: copy single entry
      vim.keymap.set("n", keymap, core.copy_entry_contents, {
        buffer = args.buf,
        desc = keymap_desc,
      })
      
      -- Visual mode: copy multiple entries
      vim.keymap.set("v", keymap, function()
        -- Get the visual selection range before calling the function
        local start_line = vim.fn.line("v")
        local end_line = vim.fn.line(".")
        
        -- Ensure start_line is before end_line
        if start_line > end_line then
          start_line, end_line = end_line, start_line
        end
        
        core.copy_visual_selection(start_line, end_line)
        -- Exit visual mode after copying
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
      end, {
        buffer = args.buf,
        desc = visual_keymap_desc,
      })
    end,
  })
end

return M
