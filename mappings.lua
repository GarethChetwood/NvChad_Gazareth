local M = {}

M.disabled = {
  n = {
    ["<leader>fm"] = { "", "lsp formatting" },
    ["<leader>n"] = { "", "toggle line number" },
    ["<leader>rn"] = { "", "toggle relative number" },
    ["<C-n>"] = { "", "toggle nvimtree" },
    ["<leader>e"] = { "", "focus nvimtree" },
  },
}

-- Dashboard/Settings shortcuts
local switch_window = function(command)
  return function()
    vim.cmd("wincmd " .. command)
    local newFileType = vim.bo.filetype
    if newFileType == "NvimTree" then
      vim.cmd("wincmd " .. command)
    end
  end
end

local current_file_dir = function()
  return (vim.fn.expand "%:p:h")
end

local explore_current_file_dir = function()
  if vim.g.is_windows then
    local escaped_file_path = current_file_dir():gsub("\\", "\\\\")
    local command = '!"explorer.exe \'' .. escaped_file_path .. "'\""
    vim.fn.setreg("*", command)
    vim.cmd(command)
  else
    vim.cmd("open " .. current_file_dir())
  end
end

local return_to_dashboard = function(set_cd)
  return function()
    vim.cmd "tabonly | enew | BufOnly"
    vim.cmd "Alpha"
    if set_cd then
      local current_type = vim.bo.filetype
      if current_type ~= "alpha" and #current_type ~= 0 then
        vim.cmd "CdHome"
      end
    end
  end
end

M.general = {
  n = {
    -- Meta stuff
    ["<leader>ps"] = { "<cmd> PackerSync <CR>", "Sync packages" },
    ["<leader>cd"] = { "<cmd> :cd %:p:h <CR>", "Set directory to current file's" },
    ["<leader>ycd"] = {
      function()
        vim.fn.setreg("*", current_file_dir())
      end,
      "Yank current file directory to clipboard",
    },
    ["<leader>ecd"] = { explore_current_file_dir, "Open explorer at current directory (windows)" },

    -- Modes
    [";"] = { ":", "command mode", opts = { nowait = true } },

    ["ZW"] = { "<cmd> wa <CR>", "Save all files" },
    ["ZD"] = { return_to_dashboard(false), "Return to project dashboard" },
    ["ZDQ"] = { return_to_dashboard(true), "Return to dashboard" },
    ["ZA"] = { "<cmd> wa | qa <CR>", "Save all files then quit vim" },

    -- Tab/window switching
    ["<C-w><C-v>"] = { "<cmd> :vert sb # <CR>", "Open a vertical split of current and previous buffer" },
    ["<C-w><C-t>"] = { "<cmd> tabc <CR>", "Close tab" },
    ["<C-t>"] = { "<cmd> tabnew | Alpha <CR>", "Open new tab and run Alpha (dashboard)" },
    ["<C-Tab>"] = { "<cmd> tabnext <CR>", "Switch to next tab" },
    ["<C-S-Tab>"] = { "<cmd> tabprev <CR>", "Switch to previous tab" },
    ["<TAB>"] = { switch_window "w", "Switch to next window" },
    ["<S-Tab>"] = { switch_window "W", "Switch to previous window" },

    -- Help with editing/writing text
    ["Y"] = { "^vg_", "select line (excluding EOL character)" },
    ["<leader><enter>"] = { ":call feedkeys('] [ i')<cr>", "Insert mode with new line above and below." },

    -- Print out current mode on a delay (for debugging)
    -- ["<leader>m"] = { function()
    --   local timer = vim.loop.new_timer()
    --   local print_timer = vim.loop.new_timer()
    --   local curr_mode  = "n"
    --   timer:start(1000, 0, function ()
    --     curr_mode = vim.api.nvim_get_mode().mode
    --     print("Got mode!!!")
    --     print_timer:start(1000,0, function()
    --       print("Mode is: "..curr_mode)
    --       print_timer:stop()
    --       print_timer:close()
    --     end)
    --     timer:stop()
    --     timer:close()
    --   end)
    -- end
    -- ,
  },
  i = {
    ["="] = { " = ", "spaced equals" },
    [">="] = { " >= ", "spaced greater than or equal to" },
    ["<="] = { " <= ", "spaced less than or equal to" },
    ["=="] = { " == ", "spaced equality" },
    ["=>"] = { " => ", "spaced arrow operator" },
    ["{<space>"] = { "{  }<left><left>", "spaced curly braces" },
    ["[<space>"] = { "[  ]<left><left>", "spaced square braces" },
  },
  c = {},
  v = {
    ["<leader>/sa"] = { 'y:%s/<C-R>"//g<left><left>', "Replace selection on all lines." },
    ["<leader>/sc"] = { 'y:%s/<C-R>"//gc<left><left><left>', "Replace selection on all lines (with confirmation)." },
    ["<leader>/sl"] = { 'y:s/<C-R>"//g<left><left>', "Replace selection on current line." },
  },
}

vim.g.camelcasemotion_key = "<leader>"

local setLeapKeymaps = function()
  ---- Leap keymaps ----
  for _, _1_ in ipairs {
    { { "n", "x", "o" }, "-", "<Plug>(leap-forward-to)", "Leap: forward-to" },
    { { "n", "x", "o" }, "+", "<Plug>(leap-backward-to)", "Leap: backward-to" },
    { { "x", "o" }, "x", "<Plug>(leap-forward-till)", "Leap: forward-till" },
    { { "x", "o" }, "X", "<Plug>(leap-backward-till)", "Leap: backward-till" },
    { { "n", "x", "o" }, "gs", "<Plug>(leap-cross-window)", "Leap: cross-window" },
  } do
    local _each_2_ = _1_
    local modes = _each_2_[1]
    local lhs = _each_2_[2]
    local rhs = _each_2_[3]
    local desc = _each_2_[4]
    for _0, mode in ipairs(modes) do
      if force_3f or ((vim.fn.mapcheck(lhs, mode) == "") and (vim.fn.hasmapto(rhs, mode) == 0)) then
        vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
      else
      end
    end
  end
end

setLeapKeymaps()

M.lspconfig = {
  n = {
    ["<leader>fmt"] = {
      function()
        vim.lsp.buf.format { async = true }
      end,
      "lsp formatting",
    },
  },
}

M.nvimtree = {
  n = {
    ["<leader>fd"] = {
      function()
        require("nvim-tree").toggle(false, true)
      end,
      "toggle nvimtree",
    },
    ["<leader>fe"] = { "<cmd> NvimTreeFocus <CR>", "focus nvimtree" },
  },
}

M.cellular_automation = {
  n = {
    ["<leader>fml"] = { "<cmd>CellularAutomaton make_it_rain<CR>", "Make it rain (FML)" },
  },
}

M.tabufline = {
  n = {
    -- cycle through buffers
    ["<leader><TAB>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflineNext()
      end,
      "goto next buffer",
    },
    ["<leader><S-Tab>"] = {
      function()
        require("nvchad_ui.tabufline").tabuflinePrev()
      end,
      "goto prev buffer",
    },
  },
}

M.focus = {
  n = {
    ["<F3>"] = { "<cmd> FocusMaximise <CR>", "Focus current window" },
  },
}

M.telescope = {
  n = {
    ["<leader>fp"] = { "<cmd> Telescope projections <CR>", "find projects" },
    ["<leader><C-t>"] = { "<cmd> Telescope telescope-tabs list_tabs <CR>", "Browse tabs" },
  },
}

M.trouble = {
  n = {
    ["<leader>tc"] = { "<cmd> TroubleToggle <CR>", "Toggle Trouble (Diagnostics)" },
  },
}

M.undoquit = {
  n = {
    ["<C-S-T>"] = { "<cmd> Undoquit <CR>", "Undo last quit window" },
  },
}

M.zen_mode = {
  n = {
    ["<S-F3>"] = { ":ZenMode <CR>", 'Toggle "Total Zen" mode' },
  },
}

return M
