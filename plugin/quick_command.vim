vim9script


import autoload 'quick_command.vim' as QC


augroup quick_command
    autocmd GUIEnter * call QC.MaximizeWindow(QC.IS_WINDOWS, QC.IS_GUI)
    autocmd InsertLeave * call QC.SwitchIme(QC.IS_WINDOWS, QC.IS_GUI, v:false)
    autocmd InsertEnter * call QC.SwitchIme(QC.IS_WINDOWS, QC.IS_GUI, v:true)
augroup END

