return {
  "gbprod/nord.nvim",
  config = function()
    vim.cmd([[
    colorscheme nord
    let g:nord_underline = 0
    let g:nord_italic_comments = 0
    let g:nord_italic = 0
    hi DiagnosticUnderlineError NONE
    hi DiagnosticUnderlineInfo NONE
    hi DiagnosticUnderlineWarn NONE
    ]])
  end,
}
