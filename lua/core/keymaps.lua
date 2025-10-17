-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable the space key's default behavior in Normal and Visual modes

vim.keymap.set({'n','v'},'<Space>','<Nop>',{silent = true})

-- for conciseness
 local opts = {noremap = true,silent = true}
 
 -- save the file
 
 -- set(mode,required_shortcut,the_command_to_be_executed_by_the_shorcut,options)
 -- n-normal mode
 --<C-s>-Ctrl+s
 --<cmd> w <CR>-:w then press enter, <CR>-means enter
vim.keymap.set('n','<C-s>', '<cmd> w <CR>',opts)

-- delete a single character without copying it to the register
vim.keymap.set('n','x','"_x"',opts)


--vertical scroll and center
vim.keymap.set('n','<C-d>','<C-d>zz',opts)
vim.keymap.set('n','<C-u>','<C-u>zz',opts)

--deleting words
vim.keymap.set('i', '<C-h>', '<C-w>', opts)

--buffers
--got to next buffer
vim.keymap.set('n',"<Tab>",":bnext<CR>",opts)
--got to previous buffer
vim.keymap.set('n',"<S-Tab>",":bprevious<CR>",opts)
--close current buffer 
vim.keymap.set('n',"<leader>x",":bdelete!<CR>",opts)
-- create new buffer
vim.keymap.set('n',"<leader>b","<cmd> enew <CR>",opts)

--splitting the window
--vertically
vim.keymap.set('n','<leader>v','<C-w>v',opts)
--horizontally
vim.keymap.set('n','<leader>h','<C-w>s',opts)
--close the current split window
vim.keymap.set('n','<leader>xs',':close<CR>',opts)



--navigating between splitted windows
vim.keymap.set('n','<C-h>',':wincmd h<CR>',opts)
vim.keymap.set('n','<C-j>',':wincmd j<CR>',opts)
vim.keymap.set('n','<C-k>',':wincmd k<CR>',opts)
vim.keymap.set('n','<C-l>',':wincmd l<CR>',opts)

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)
