if !exists(':GitGutter')
    finish
endif

" Disable realtime updates.
autocmd! gitgutter CursorHold,CursorHoldI
