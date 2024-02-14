-- lua_source {{{
local cmp = require 'cmp'

---@param keys string
---@param flags nil|string
local function feedkeys(keys, flags)
  vim.fn.feedkeys(vim.api.nvim_replace_termcodes(keys, true, true, true), flags or 'nt')
end

local function getCurrentDisplayedBuffers()
  local bufs = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if not (vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal') then
      table.insert(bufs, buf)
    end
  end
  return bufs
end

cmp.setup {
  enabled = function()
    -- プロンプトバッファでは無効
    return vim.bo.buftype ~= 'prompt'
  end,
  snippet = {
    expand = function(args)
      vim.fn['vsnip#anonymous'](args.body)
    end,
  },
  window = {
    completion = {
      border = 'rounded',
    },
    documentation = {
      border = 'rounded',
    },
  },
  preselect = cmp.PreselectMode.None,
  experimental = {
    ghost_text = true,
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = require('lspkind').cmp_format {
      with_text = false,
    },
  },
  sources = cmp.config.sources {
    { name = 'vsnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = getCurrentDisplayedBuffers,
      },
    },
    { name = 'spell' },
    -- { name = 'skkeleton' },
  },
  mapping = {
    ['<CR>'] = function(fallback)
      if cmp.visible() then
        cmp.confirm {
          select = true,
          behavior = cmp.ConfirmBehavior.Replace,
        }
      elseif vim.fn['pum#visible']() then
        vim.fn['pum#map#confirm']()
      else
        fallback()
      end
    end,
    ['<C-n>'] = function()
      if cmp.visible() then
        cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
      elseif vim.fn['pum#visible']() then
        vim.fn['pum#map#insert_relative'](1)
      elseif 1 == vim.fn.pumvisible() then
        feedkeys '<C-n>'
      end
      cmp.complete()
    end,
    ['<C-p>'] = function()
      if cmp.visible() then
        cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
      elseif vim.fn['pum#visible']() then
        vim.fn['pum#map#insert_relative'](-1)
      elseif 1 == vim.fn.pumvisible() then
        feedkeys '<C-p>'
      end
      cmp.complete()
    end,
    ['<C-g>'] = function(fallback)
      if cmp.visible() then
        cmp.abort()
      elseif vim.fn['pum#visible']() then
        vim.fn['pum#map#cancel']()
      else
        fallback()
      end
    end,
    ['<Tab>'] = function(fallback)
      if vim.fn['vsnip#jumpable'](1) == 1 then
        feedkeys '<Plug>(vsnip-jump-next)'
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if vim.fn['vsnip#jumpable'](-1) == 1 then
        feedkeys '<Plug>(vsnip-jump-prev)'
      else
        fallback()
      end
    end,
  },
}
cmp.setup.cmdline(':', {
  enabled = true,
  mapping = {
    ['<Tab>'] = {
      c = function()
        if cmp.visible() then
          cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
        elseif vim.fn['pum#visible']() then
          vim.fn['pum#map#insert_relative'](1)
        else
          feedkeys '<Tab>'
        end
      end,
    },
    ['<S-Tab>'] = {
      c = function()
        if cmp.visible() then
          cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
        elseif vim.fn['pum#visible']() then
          vim.fn['pum#map#insert_relative'](-1)
        else
          feedkeys '<S-Tab>'
        end
      end,
    },
    ['<C-g>'] = {
      c = function(fallback)
        if cmp.visible() then
          cmp.close()
        elseif vim.fn['pum#visible']() then
          vim.fn['pum#map#cancel']()
        else
          fallback()
        end
      end,
    },
    ['<C-f>'] = {
      c = function()
        if cmp.visible() then
          cmp.close()
        elseif vim.fn['pum#visible']() then
          vim.fn['pum#map#cancel']()
        end
        feedkeys '<C-f>'
      end,
    },
  },
  sources = cmp.config.sources {
    { name = 'path' },
    {
      name = 'cmdline',
      option = {
        ignore_cmds = { 'Man', '!' },
      },
    },
  },
})
cmp.setup.filetype('gitcommit', {
  sources = require('cmp').config.sources({
    { name = 'emoji' },
  }, {
    {
      name = 'buffer',
      option = {
        get_bufnrs = getCurrentDisplayedBuffers,
      },
    },
  }),
})
cmp.setup.filetype('ddu-ff-filter', {
  sources = {},
})
cmp.setup.filetype('TelescopePrompt', {
  enabled = false,
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'skkeleton-disable-post',
  callback = function()
    require('cmp').setup.buffer { enabled = true }
  end,
})
vim.api.nvim_create_autocmd('User', {
  pattern = 'skkeleton-enable-post',
  callback = function()
    require('cmp').setup.buffer { enabled = false }
  end,
})
--- }}}