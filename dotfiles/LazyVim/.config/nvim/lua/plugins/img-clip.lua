return {
  "HakonHarnes/img-clip.nvim",
  ft = { "tex", "markdown", "typst" },
  opts = {
    default = {
      embed_image_as_base64 = false, -- Base64图片
      prompt_for_file_name = false, -- 提示输入文件名
      use_absolute_path = false, -- 绝对路径
      copy_images = true, -- 复制剪切板图片
      drag_and_drop = { insert_mode = true },
    },
    filetypes = {
      markdown = {
        dir_path = function()
          local current_file = vim.fn.expand("%:p")
          local file_dir = vim.fn.fnamemodify(current_file, ":h")
          local file_name_no_ext = vim.fn.fnamemodify(current_file, ":t:r")
          return file_dir .. "/pictures/" .. file_name_no_ext
        end,
      },
    },
  },
}
