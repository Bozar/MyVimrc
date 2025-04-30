vim9script


import autoload 'quick_command.vim' as QC
import autoload 'format_text.vim' as FT
import autoload 'snippet.vim' as SNP


augroup quick_command
    autocmd GUIEnter * call QC.MaximizeWindow(QC.IS_WINDOWS, QC.IS_GUI)
    autocmd InsertLeave * call QC.SwitchIme(QC.IS_WINDOWS, QC.IS_GUI, v:false)
    autocmd InsertEnter * call QC.SwitchIme(QC.IS_WINDOWS, QC.IS_GUI, v:true)
    autocmd FileType * call SNP.LoadSnippet(expand('<amatch>'))
augroup END


command -bar -nargs=* FormatText silent call <sid>FT.AutoFormat(<f-args>)

