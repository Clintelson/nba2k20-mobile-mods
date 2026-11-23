
.text
.global decrypt_hook
.type decrypt_hook,%function
// Entered by branch from the end of MOBILE_STORE::ITEM::Decrypt (x20 = the item, now plain).
// Every store read decrypts first, so Connections-only rewards (requirement 10000, price 0) get a price everywhere,
// including items already saved in a career.
decrypt_hook:
 mov x10,x20
 bl fix_item
 ldp x29,x30,[sp,#0x40]         // displaced original instruction
 b decrypt_resume
fix_item:
 mov x11,x30
 mov x0,x10
 movz w1,#0x79c0
 movk w1,#0x5da5,lsl #16        // requirement field
 bl find_field
 cbz x0,sp_next
 ldr w2,[x0]
 mov w3,#10000
 cmp w2,w3
 b.ne sp_next
 mov x0,x10
 movz w1,#0x0ddd
 movk w1,#0x0b09,lsl #16        // price field
 bl find_field
 cbz x0,sp_next
 mov x12,x0
 ldr w2,[x12]
 cbnz w2,sp_next
 mov x0,x10
 movz w1,#0xf817
 movk w1,#0x2cec,lsl #16        // item type field
 bl find_field
 cbz x0,sp_next
 ldr w13,[x0]
 adr x14,equip_types
 mov x15,#0
sp_eq:
 ldr w16,[x14,x15,lsl #2]
 cmp w16,w13
 b.eq sp_tier
 add x15,x15,#1
 cmp x15,#3
 b.lt sp_eq
 adr x14,type_prices
sp_tab:
 ldp w16,w17,[x14],#8
 cbz w16,sp_store               // end of table: w17 = default price
 cmp w16,w13
 b.ne sp_tab
 b sp_store
sp_tier:
 mov x0,x10
 movz w1,#0xa938
 movk w1,#0x462c,lsl #16        // boost tier field (1..3)
 bl find_field
 mov w17,#9000
 cbz x0,sp_store
 ldr w2,[x0]
 mov w17,#1500
 cmp w2,#1
 b.eq sp_store
 mov w17,#4000
 cmp w2,#2
 b.eq sp_store
 mov w17,#9000
sp_store:
 str w17,[x12]
sp_next:
 ret x11

// x0 = item, w1 = field crc -> x0 = value slot (value, type) or 0. Uses x0-x4 only.
find_field:
 mov x2,#0
ff_loop:
 add x3,x0,x2,lsl #3
 ldr w4,[x3,#4]
 cmp w4,w1
 b.eq ff_hit
 add x2,x2,#1
 cmp x2,#48
 b.lt ff_loop
 mov x0,#0
 ret
ff_hit:
 ldr w4,[x3]
 add x0,x0,x4,lsl #3
 add x0,x0,#0x188
 ret
.balign 4
equip_types:
 .word 0xf72245fd, 0x0ef93c1e, 0xe377c2c5   // SHOE, ARM, LEG
type_prices:
 .word 0xc96987ad, 2000   // UNIFORM
 .word 0xc5828338, 750    // ANIMATION_JUMPSHOT
 .word 0x5ec361c4, 500    // ANIMATION_DUNK
 .word 0x071d7a92, 1000   // ANIMATION_LAYUP
 .word 0x8c27112c, 100    // ANIMATION_FREETHROW
 .word 0x0520cd46, 300    // ANIMATION_RITUAL_INTRO
 .word 0xca7123d4, 200    // ANIMATION_RITUAL_PRE_GAME
 .word 0x25a094a1, 200    // ANIMATION_RITUAL_PRE_TIPOFF
 .word 0, 250             // default (signature styles etc.)
.size decrypt_hook,.-decrypt_hook
