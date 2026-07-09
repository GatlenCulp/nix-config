-- Ported from nvix plugins/lualine/ (default.nix + sections.nix).
-- Icons inlined from plugins/common/icons.nix (config.nvix.icons).
return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      -- extraConfigLua from nvix
      vim.cmd([[hi StatusLine guibg=NONE ctermbg=NONE]])

      local separators = { left = "", right = "" }
      local transparent = { a = { fg = "none" }, c = { bg = "none" } }

      require("lualine").setup({
        options = {
          theme = {
            normal = transparent,
            insert = transparent,
            visual = transparent,
            replace = transparent,
            command = transparent,
            inactive = transparent,
          },
          always_divide_middle = true,
          globalstatus = true,
          icons_enabled = true, -- nix source had a no-op `icons_enable` typo
          component_separators = separators,
          section_separators = separators,
          disabled_filetypes = {
            "Outline",
            "neo-tree",
            "dashboard",
            "snacks_dashboard",
            "snacks_terminal",
          },
        },
        sections = {
          lualine_a = {
            {
              "fileformat",
              padding = { left = 1, right = 1 },
              color = "SLGreen",
            },
          },
          lualine_b = { "encoding" },
          lualine_c = {
            {
              "b:gitsigns_head",
              icon = "", -- icons.git.Branch
              color = { gui = "bold" },
            },
            {
              "diff",
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if vim.b.gitsigns_status_dict then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
              symbols = {
                added = "" .. " ", -- icons.git.LineAdded
                modified = "" .. " ", -- icons.git.LineModified
                removed = "" .. " ", -- icons.git.LineRemoved
              },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              symbols = {
                error = "" .. " ", -- icons.diagnostics.BoldError
                warn = "" .. " ", -- icons.diagnostics.BoldWarning
                info = "" .. " ", -- icons.diagnostics.BoldInformation
                hint = "" .. " ", -- icons.diagnostics.BoldHint
              },
            },
          },
          lualine_x = {
            {
              function()
                local ok, noice = pcall(require, "noice")
                if not ok then
                  return false
                end
                return noice.api.status.mode.get()
              end,
              color = { fg = "#ff9e64" },
              cond = function()
                local ok, noice = pcall(require, "noice")
                if not ok then
                  return false
                end
                return noice.api.status.mode.has()
              end,
            },
            {
              function()
                local clients = vim.lsp.get_clients()
                local lsp_names = {}
                if next(clients) == nil then
                  return "Ls Inactive"
                end
                for _, client in ipairs(clients) do
                  if client.name ~= "copilot" and client.name ~= "null-ls" and client.name ~= "typos_lsp" then
                    local name = client.name:gsub("%[%d+%]", "") -- makes otter-ls[number] -> otter-ls
                    table.insert(lsp_names, name)
                  end
                end

                -- Guard conform like the noice component: a missing/failed
                -- load must not throw inside a statusline redraw.
                local conform_ok, conform = pcall(require, "conform")
                local formatters = conform_ok and conform.list_formatters() or {}
                local con_names = {}

                for _, formatter in ipairs(formatters) do
                  local name = formatter.name
                  if
                    formatter.available
                    and (name ~= "squeeze_blanks" and name ~= "trim_whitespace" and name ~= "trim_newlines")
                  then
                    table.insert(con_names, formatter.name)
                  end
                end
                local names = {}
                vim.list_extend(names, lsp_names)
                vim.list_extend(names, con_names)
                -- vim.fn.uniq() only drops ADJACENT duplicates, so sort first
                -- to collapse the same tool appearing in both lists.
                table.sort(names)
                return "[" .. table.concat(vim.fn.uniq(names), ", ") .. "]"
              end,
            },
            {
              "filetype",
              padding = { left = 1, right = 1 },
            },
          },
          lualine_y = { "progress" },
          lualine_z = {
            "location",
            {
              function()
                local lsp_clients = vim.lsp.get_clients()
                for _, client in ipairs(lsp_clients) do
                  if client.name == "copilot" then
                    return "%#SLGreen#" .. "" -- icons.kind.Copilot
                  end
                end
                return ""
              end,
            },
          },
        },
      })
    end,
  },
}
