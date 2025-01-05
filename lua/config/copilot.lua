-- local utils = require('config.utils')
local icons = require('config.icons')
--
--
-- Copilot chat
local chat = require('CopilotChat')
local actions = require('CopilotChat.actions')
local select = require('CopilotChat.select')
local integration = require('CopilotChat.integrations.fzflua')

chat.setup({
    -- system_prompt = prompts.COPILOT_INSTRUCTIONS,
    model = 'gpt-4o',
    agent = 'copilot',
    question_header = ' ' .. icons.ui.User .. ' Heber MQ ',
    answer_header = ' ' .. icons.ui.Bot .. ' ',
    error_header = '> ' .. icons.diagnostics.Warn .. ' ',
    context = nil,
    temperature = 0.8,
    -- selection = select.buffer,
    selection = function(source)
      return select.visual(source) or select.buffer(source)
    end,
    window = {
      layout = 'float', -- 'vertical', 'horizontal', 'float', 'replace'
      width = 0.8, -- fractional width of parent, or absolute width in columns when > 1
      height = 0.8, -- fractional height of parent, or absolute height in rows when > 1
      -- Options below only apply to floating windows
      relative = 'editor', -- 'editor', 'win', 'cursor', 'mouse'
      border = 'rounded', -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
      row = nil, -- row position of the window, default is centered
      col = nil, -- column position of the window, default is centered
      title = 'Copilot Chat', -- title of chat window
      footer = nil, -- footer of chat window
      zindex = 1, -- determines if window is on top or below other floating windows
    },
    mappings = {
      submit_prompt = {
        normal = '<Leader>s',
        insert = '<C-s>'
      },
      reset = {
          normal = '<C-l>',
          insert = '<C-l>',
      },
    },
    prompts = {
        mypront = {
            system_prompt = 'Utilizar idioma español',
        },
        Explain = {
            mapping = '<leader>ae',
            description = 'AI Explicar',
        },
        Review = {
            mapping = '<leader>ar',
            description = 'AI Revisar',
        },
        Tests = {
            mapping = '<leader>at',
            description = 'AI Test',
        },
        Optimize = {
            mapping = '<leader>ao',
            description = 'AI Optimizar',
        },
        Docs = {
            mapping = '<leader>ad',
            description = 'AI Documentación',
        },
        Commit = {
            mapping = '<leader>ac',
            description = 'AI Generar commit',
        },
    },
    {
  }
})

















