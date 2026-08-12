local Config = require("tknvivid.config")
local Init = require("tknvivid")

before_each(function()
  vim.o.background = "dark"
  vim.cmd.colorscheme("default")
  Config.setup()
  Init.styles = {}
end)

it("did prper init", function()
  assert.same({}, Init.styles)
  assert.same("default", vim.g.colors_name)
  assert.same("dark", vim.o.background)
end)

describe("loading respects vim.o.background", function()
  it("= dark", function()
    vim.o.background = "dark"
    vim.cmd.colorscheme("tknvivid")
    assert.same("dark", vim.o.background)
    assert.same("tknvivid-moon", vim.g.colors_name)
  end)

  it("= light", function()
    vim.o.background = "light"
    vim.cmd.colorscheme("tknvivid")
    assert.same("light", vim.o.background)
    assert.same("tknvivid-day", vim.g.colors_name)
  end)

  it("= dark with night", function()
    vim.o.background = "dark"
    vim.cmd.colorscheme("tknvivid-night")
    assert.same("dark", vim.o.background)
    assert.same("tknvivid-night", vim.g.colors_name)
  end)

  it("= dark with day", function()
    vim.o.background = "dark"
    vim.cmd.colorscheme("tknvivid-day")
    assert.same("light", vim.o.background)
    assert.same("tknvivid-day", vim.g.colors_name)
  end)

  it("= light with night", function()
    vim.o.background = "light"
    vim.cmd.colorscheme("tknvivid-night")
    assert.same("dark", vim.o.background)
    assert.same("tknvivid-night", vim.g.colors_name)
  end)

  it("= light with day", function()
    vim.o.background = "light"
    vim.cmd.colorscheme("tknvivid-day")
    assert.same("light", vim.o.background)
    assert.same("tknvivid-day", vim.g.colors_name)
  end)

  it(" and switches to light", function()
    vim.o.background = "dark"
    vim.cmd.colorscheme("tknvivid-night")
    vim.o.background = "light"
    assert.same("light", vim.o.background)
    assert.same("tknvivid-day", vim.g.colors_name)
  end)

  it(" and switches to dark", function()
    vim.o.background = "light"
    vim.cmd.colorscheme("tknvivid")
    vim.o.background = "dark"
    assert.same("dark", vim.o.background)
    assert.same("tknvivid-moon", vim.g.colors_name)
  end)

  it(" and remembers dark", function()
    vim.o.background = "dark"
    vim.cmd.colorscheme("tknvivid-night")
    vim.o.background = "light"
    vim.o.background = "dark"
    assert.same("dark", vim.o.background)
    assert.same("tknvivid-night", vim.g.colors_name)
  end)
end)
