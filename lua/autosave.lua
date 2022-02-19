function AutoSave()
  require('autosave').setup({
    enabled = true,
    execution_message = 'Saved at:' .. vim.fn.strftime('%H:%M:%S'),
    conditions = { exists = true, filetype_is_not = {}, modifiable = true },
    events = { 'InsertLeave', 'TextChanged' },
    write_all_buffers = false,
    on_off_commands = true,
    clean_command_line_interval = 0,
    debounce_delay = 135,
  })

  vim.g.auto_save = true
end
