vim9script


export def AutoFormat(): void
	!go fmt % | go vet %
enddef


export def IsAvailable(): bool
	system('go version')
	if v:shell_error !=# 0
		return v:false
	endif
	return v:true
enddef

