.text
.global practice_choice
.type practice_choice,%function
practice_choice:
 stp x20,x19,[sp,#-32]!
 stp x29,x30,[sp,#16]
 add x29,sp,#16
 mov x19,x0
 // Ask with the game's own off-day team practice prompt; Yes = team practice, No = shoot around.
 mov w1,#0xc80e
 movk w1,#0xef4c,lsl #16
 mov x2,xzr
 mov w3,#-1
 mov w4,#-1
 mov w5,#1
 bl dialog_yesno
 cbz w0,do_shootaround
 // Same sequence as MYCAREER_OFFDAYS_MENU team practice, minus spending an off-day task.
 mov w0,#1
 bl rich_presence
 bl drills_status
 mov w1,#3
 bl drills_setmode
 mov w0,#1
 bl drills_allai
 mov w0,#4
 bl set_start_type
 bl import_schedule
 mov w0,#1
 mov w1,#0
 bl set_autoload
 mov x0,x19
 mov w1,#1
 bl autosave
 bl abort_pending
 cbnz w0,done
 bl roster_player
 mov x1,x0
 mov x0,x19
 mov w2,#3
 mov w3,#1        // no 0x10: let RunSingleDrill switch to the game itself (off-days defers it)
 bl run_single_drill
done:
 ldp x29,x30,[sp,#16]
 ldp x20,x19,[sp],#32
 ret
do_shootaround:
 mov x0,x19
 ldp x29,x30,[sp,#16]
 ldp x20,x19,[sp],#32
 stp x20,x19,[sp,#-32]!
 b shootaround_resume
.size practice_choice,.-practice_choice
