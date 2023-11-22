function dump(val)
	if type(val) == 'table' then
		local s = '{ '

		for k, v in pairs(val) do
			if type(k) ~= 'number' then
				k = '"' .. k .. '"'
			end

			s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
		end

		return s .. ' }'
	else
		return tostring(val)
	end
end

vim.g.editorconfig = true
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.cursorline = true
vim.opt.number = true
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true

require('bufferline').setup()
