" Neovim entry point: sources the sibling files in dependency order.
let s:dir = fnamemodify(expand('<sfile>:p'), ':h')
for s:name in ['core', 'general', 'plugins', 'themeSetting', 'keyMap']
  execute 'source ' . fnameescape(s:dir . '/' . s:name . '.vim')
endfor
