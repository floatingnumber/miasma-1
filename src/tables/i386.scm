; Miasma: x86 Scheme Assembler.
; Copyright (C) 2000, Darius Bacon, Brian Spilsbury, Alycat
; Refer to legal/License.txt

; FIXME: Brian updated this without updating the doc.  At least Sx
; should be added to the feature list below.  There's an extra field
; after the doc-string, which I think is the registers the instruction
; affects.  Anything else?

; mnemonic feature* doc-string
; where:
; feature ::= byte
;          |  literal-register
;          |  =y
;          |  Sreg | cr | dr    (not yet implemented)
;          |  Ix | Ux | Ox | Jx
;          |  (? byte)
;          |  (+ byte Gx)
;          |  (/r Ex Gx)   [FIXME: but look out for restrictions on Ex, like Mx]
;          |  (/r Gx Ex)   [FIXME: also Gx might be cr or dr]
;          |  (/n Ex)
;
; where x = b | w | d | v
; and   y = 16 | 32

; FIXME: I think Sreg, cr, and dr should be unified with Gx -- so we 
; have a Gx operand category with a register-family attribute.  Of
; course, then the x part of Gx is unused for those cases.


; compare and contrast!
;
; (aad    (#xD5 #x0A)         "ASCII adjust AX before division")
; (aad    (#xD5) Ub           "ASCII adjust AX before division")
;
; vs:
;
; (rcl    (#xD0) (/2 Eb) 1    "Rotate left through carry")
; (rcl    (#xC0) (/2 Eb) Ub   "Rotate left through carry")
;
; Since we decided on the former (taking out the 1 in rcl), we need
; to be able to put it back in the gas listing (I think -- check it).


; other issues:
; 16/32 bit mode-sensitivity
; oops, left out the temporarily commented-out instructions from the original
; some instructions like MOV should allow either Ix or Ux operands


(aaa    #x37                    "ASCII adjust AL after addition" (%AL %AF %CF %OF %SF %ZF %PF))
(aas    #x3F                    "ASCII adjust AL after subtraction" (%AL %AH %AF %CF %OF %SF %ZF %PF))
(daa    #x27                    "Decimal adjust AL after addition" (%AL %CF %AF))
(das    #x2F                    "Decimal adjust AL after subtraction" (%AL %CF %AF))
(aad    #xD5 #x0A               "ASCII adjust AX before division" (%AL %AH %SF %ZF %PF))
(aad    #xD5 Ub                 "ASCII adjust AX before division" (%AL %AH %SF %ZF %PF))
(aam    #xD4 #x0A               "ASCII adjust AX after multiply" (%AL %AH %SF %ZF %PF %OF %AF %CF))
(aam    #xD4 Ub                 "ASCII adjust AX after multiply" (%AL %AH %SF %ZF %PF %OF %AF %CF))
(adc    #x14 %AL Ib             "Add with carry" (%OF %SF %ZF %AF %CF %PF))
(adc    #x15 %eAX Iv            "Add with carry" (%OF %SF %ZF %AF %CF %PF))
(adc    #x80 (/2 Eb) Ib         "Add with carry" (%OF %SF %ZF %AF %CF %PF))
(adc    #x81 (/2 Ev) Iv         "Add with carry" (%OF %SF %ZF %AF %CF %PF))
(adc    #x83 (/2 Ev) Ib         "Add with carry" (%OF %SF %ZF %AF %CF %PF))
(adc    #x10 (/r Eb Gb)         "Add with carry" (%OF %SF %ZF %AF %CF %PF))
(adc    #x11 (/r Ev Gv)         "Add with carry" (%OF %SF %ZF %AF %CF %PF))
(adc    #x12 (/r Gb Eb)         "Add with carry" (%OF %SF %ZF %AF %CF %PF))
(adc    #x13 (/r Gv Ev)         "Add with carry" (%OF %SF %ZF %AF %CF %PF))
(add    #x04 %AL Ib             "Add" (%OF %SF %ZF %AF %CF %PF))
(add    #x05 %eAX Iv            "Add" (%OF %SF %ZF %AF %CF %PF))
(add    #x80 (/0 Eb) Ib         "Add" (%OF %SF %ZF %AF %CF %PF))
(add    #x81 (/0 Ev) Iv         "Add" (%OF %SF %ZF %AF %CF %PF))
(add    #x83 (/0 Ev) Ib         "Add" (%OF %SF %ZF %AF %CF %PF))
(add    #x00 (/r Eb Gb)         "Add" (%OF %SF %ZF %AF %CF %PF))
(add    #x01 (/r Ev Gv)         "Add" (%OF %SF %ZF %AF %CF %PF))
(add    #x02 (/r Gb Eb)         "Add" (%OF %SF %ZF %AF %CF %PF))
(add    #x03 (/r Gv Ev)         "Add" (%OF %SF %ZF %AF %CF %PF))
(sbb    #x1C %AL Ib             "Subtract with borrow" (%OF %SF %ZF %AF %PF %CF))
(sbb    #x1D %eAX Iv            "Subtract with borrow" (%OF %SF %ZF %AF %PF %CF))
(sbb    #x80 (/3 Eb) Ib         "Subtract with borrow" (%OF %SF %ZF %AF %PF %CF))
(sbb    #x81 (/3 Ev) Iv         "Subtract with borrow" (%OF %SF %ZF %AF %PF %CF))
(sbb    #x83 (/3 Ev) Ib         "Subtract with borrow" (%OF %SF %ZF %AF %PF %CF))
(sbb    #x18 (/r Eb Gb)         "Subtract with borrow" (%OF %SF %ZF %AF %PF %CF))
(sbb    #x19 (/r Ev Gv)         "Subtract with borrow" (%OF %SF %ZF %AF %PF %CF))
(sbb    #x1A (/r Gb Eb)         "Subtract with borrow" (%OF %SF %ZF %AF %PF %CF))
(sbb    #x1B (/r Gv Ev)         "Subtract with borrow" (%OF %SF %ZF %AF %PF %CF))
(sub    #x2C %AL Ib             "Subtract" (%OF %SF %ZF %PF %CF))
(sub    #x2D %eAX Iv            "Subtract" (%OF %SF %ZF %PF %CF))
(sub    #x80 (/5 Eb) Ib         "Subtract" (%OF %SF %ZF %PF %CF))
(sub    #x81 (/5 Ev) Iv         "Subtract" (%OF %SF %ZF %PF %CF))
(sub    #x83 (/5 Ev) Ib         "Subtract" (%OF %SF %ZF %PF %CF))
(sub    #x28 (/r Eb Gb)         "Subtract" (%OF %SF %ZF %PF %CF))
(sub    #x29 (/r Ev Gv)         "Subtract" (%OF %SF %ZF %PF %CF))
(sub    #x2A (/r Gb Eb)         "Subtract" (%OF %SF %ZF %PF %CF))
(sub    #x2B (/r Gv Ev)         "Subtract" (%OF %SF %ZF %PF %CF))
(and    #x24 %AL Ib             "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x25 %eAX Iv            "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x80 (/4 Eb) Ib         "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x81 (/4 Ev) Iv         "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x83 (/4 Ev) Ib         "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x24 %AL Ub             "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x25 %eAX Uv            "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x80 (/4 Eb) Ub         "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x81 (/4 Ev) Uv         "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x83 (/4 Ev) Ub         "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x20 (/r Eb Gb)         "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x21 (/r Ev Gv)         "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x22 (/r Gb Eb)         "And" (%OF %CF %SF %ZF %PF %AF))
(and    #x23 (/r Gv Ev)         "And" (%OF %CF %SF %ZF %PF %AF))
(or     #x0C %AL Ib             "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x0D %eAX Iv            "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x80 (/1 Eb) Ib         "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x81 (/1 Ev) Iv         "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x83 (/1 Ev) Ib         "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x0C %AL Ub             "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x0D %eAX Uv            "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x80 (/1 Eb) Ub         "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x81 (/1 Ev) Uv         "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x83 (/1 Ev) Ub         "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x08 (/r Eb Gb)         "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x09 (/r Ev Gv)         "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x0A (/r Gb Eb)         "Or" (%OF %CF %SF %ZF %PF %AF))
(or     #x0B (/r Gv Ev)         "Or" (%OF %CF %SF %ZF %PF %AF))
(xor    #x34 %AL Ib             "Exclusive or" (%OF %CF %SF %ZF %PF))
(xor    #x35 %eAX Iv            "Exclusive or" (%OF %CF %SF %ZF %PF))
(xor    #x80 (/6 Eb) Ib         "Exclusive or" (%OF %CF %SF %ZF %PF))
(xor    #x81 (/6 Ev) Iv         "Exclusive or" (%OF %CF %SF %ZF %PF))
(xor    #x83 (/6 Ev) Ib         "Exclusive or" (%OF %CF %SF %ZF %PF))
(xor    #x30 (/r Eb Gb)         "Exclusive or" (%OF %CF %SF %ZF %PF))
(xor    #x31 (/r Ev Gv)         "Exclusive or" (%OF %CF %SF %ZF %PF))
(xor    #x32 (/r Gb Eb)         "Exclusive or" (%OF %CF %SF %ZF %PF))
(xor    #x33 (/r Gv Ev)         "Exclusive or" (%OF %CF %SF %ZF %PF))
(test   #xA8 %AL Ib             "Logical compare" ((%OF 0) (%CF 0) %SF %ZF %PF))
(test   #xA9 %eAX Iv            "Logical compare" ((%OF 0) (%CF 0) %SF %ZF %PF))
(test   #xF6 (/0 Eb) Ib         "Logical compare" ((%OF 0) (%CF 0) %SF %ZF %PF))
(test   #xF7 (/0 Ev) Iv         "Logical compare" ((%OF 0) (%CF 0) %SF %ZF %PF))
(test   #x84 (/r Eb Gb)         "Logical compare" ((%OF 0) (%CF 0) %SF %ZF %PF))
(test   #x85 (/r Ev Gv)         "Logical compare" ((%OF 0) (%CF 0) %SF %ZF %PF))
(arpl   #x63 (/r Ew Gw)         "Adjust RPL of 1st to not less than RPL of 2nd" (%ZF))
(bound  #x62 (/r Gv Mv)         "Bounds-checking")
(bsf    #x0F #xBC (/r Gv Ev)    "Bit Scan Forward" (%ZF %CF %OF %SF %AF %PF))
(bsr    #x0F #xBD (/r Gv Ev)    "Bit Scan Reverse" (%ZF %CF %OF %SF %AF %PF))
(bt     #x0F #xA3 (/r Ev Gv)    "Store selected bit in CF flag" (%CF %OF %SF %ZF %AF %PF))
(bt     #x0F #xBA (/4 Ev) Ub    "Store selected bit in CF flag" (%CF %OF %SF %ZF %AF %PF))
(btc    #x0F #xBB (/r Ev Gv)    "Store selected bit in CF flag and complement" (%CF %OF %SF %ZF %AF %PF))
(btc    #x0F #xBA (/7 Ev) Ub    "Store selected bit in CF flag and complement" (%CF %OF %SF %ZF %AF %PF))
(btr    #x0F #xB3 (/r Ev Gv)    "Store selected bit in CF flag and reset" (%CF %OF %SF %ZF %AF %PF))
(btr    #x0F #xBA (/6 Ev) Ub    "Store selected bit in CF flag and reset" (%CF %OF %SF %ZF %AF %PF))
(bts    #x0F #xAB (/r Ev Gv)    "Store selected bit in CF flag and set" (%CF %OF %SF %ZF %AF %PF))
(bts    #x0F #xBA (/5 Ev) Ub    "Store selected bit in CF flag and set" (%CF %OF %SF %ZF %AF %PF))
(call   #xE8 Jv                 "Call near, relative" #t)
(call   #xFF (/2 Ev)            "Call near, absolute indirect" #t)
(callf  #xFF (/3 Mv)            "Call far, absolute indirect" #t)

;(callf  #x9A Ov                 "Call near, absolute" #t)

(cbw    =16 #x98                "AX <- sign extend of AL" (%AX))
(cwde   =32 #x98                "EAX <- sign extend of AX" (%EAX))
(cwd    =16 #x99                "Convert word to double" (%DX))
(cdq    =32 #x99                "Convert double to quad" (%EDX))
(clc    #xF8                    "Clear CF flag" ((%CF 0)))
(cld    #xFC                    "Clear DF flag" ((%DF 0)))
(cli    #xFA                    "Clear interrupt flag" (%IF))
(stc    #xF9                    "Set CF flag" ((%CF 1)))
(std    #xFD                    "Set DF flag" ((%DF 1)))
(sti    #xFB                    "Set interrupt flag" ((%IF 1)))
(cmc    #xF5                    "Complement CF flag" ((%CF 1)))
(clts   #x0F #x06               "Clear task-switched flag in CR0" ((%CRO.TS 0)))
(cmp    #x3D %eAX Iv            "Compare Iv with EAX" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x3C %AL Ib             "Compare Ib with AL" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x3D %eAX Uv            "Compare Iv with EAX" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x3C %AL Ub             "Compare Ib with AL" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x80 (/7 Eb) Ib         "Compare Ib with Eb" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x81 (/7 Ev) Iv         "Compare Iv with Ev" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x83 (/7 Ev) Ib         "Compare Ib with Ev" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x80 (/7 Eb) Ub         "Compare Ib with Eb" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x81 (/7 Ev) Uv         "Compare Iv with Ev" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x83 (/7 Ev) Ub         "Compare Ib with Ev" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x38 (/r Eb Gb)         "Compare Gb with Eb" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x39 (/r Ev Gv)         "Compare Gv with Ev" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x3A (/r Gb Eb)         "Compare Eb with Gb" (%CF %OF %SF %ZF %AF %PF))
(cmp    #x3B (/r Gv Ev)         "Compare Ev with Gv" (%CF %OF %SF %ZF %AF %PF))
(cmpsb  #xA6                    "Compare strings" (%ESI %EDI %SI %DI %CF %OF %SF %ZF %AF %PF))
(cmpsw  =16 #xA7                "Compare strings" (%CF %OF %SF %ZF %AF %PF))
(cmpsd  =32 #xA7                "Compare strings" (%CF %OF %SF %ZF %AF %PF))
(cmpxchg #x0F #xB0 (/r Eb Gb)   "Compare and exchange" (%ZF %CF %PF %AF %SF %OF))
(cmpxchg #x0F #xB1 (/r Ev Gv)   "Compare and exchange" (%ZF %CF %PF %AF %SF %OF))
(cmpxchg8b #x0F #xC7 (/1 Md)    "Compare and exchange" (%ZF %CF %PF %AF %SF %OF))
(cpuid  #x0F #xA2               "CPU identification in EAX" (%EAX %EBX %ECX %EDX))
(dec    (+ #x48 Gv)             "Decrement Gv by 1" (%OF %SF %ZF %AF %PF))
(dec    #xFE (/1 Eb)            "Decrement Eb by 1" (%OF %SF %ZF %AF %PF))
(dec    #xFF (/1 Ev)            "Decrement Ev by 1" (%OF %SF %ZF %AF %PF))
(div    #xF6 (/6 Eb)            "Unsigned divide AX by Eb" (%AL %AH %CF %OF %SF %ZF %AF %PF))
(div    #xF7 (/6 Ev)            "Unsigned divide EDX:EAX by Ev" (%EAX %EDX %CF %OF %SF %ZF %AF %PF))
(enter  #xC8 Uw Ub              "Create a stack frame for a procedure" (%ESP %EBP))
(hlt    #xF4                    "Halt")
(idiv   #xF6 (/7 Eb)            "Signed integer divide" (%AL %AH))
(idiv   #xF7 (/7 Ev)            "Signed integer divide" (%EAX %EDX))
(imul   #xF6 (/5 Eb)            "Signed integer multiply" (%AX %CF %OF %SF %ZF %AF %PF))
(imul   #xF7 (/5 Ev)            "Signed integer multiply" (%CF %OF %SF %ZF %AF %PF))
(imul   #x0F #xAF (/r Gv Ev)    "Signed integer multiply" (%CF %OF %SF %ZF %AF %PF))
(imul   #x69 (/r Gv Ev) Iv      "Signed integer multiply" (%CF %OF %SF %ZF %AF %PF))
(imul   #x6B (/r Gv Ev) Ib      "Signed integer multiply" (%CF %OF %SF %ZF %AF %PF))
(in     #xE4 %AL Ub             "Input from port")
(in     =16 #xE5 %AX Ub         "Input from port")
(in     #xE5 %eAX Ub            "Input from port")
(in     #xEC %AL %DX            "Input from port")
(in     #xED %eAX %DX           "Input from port")
(in     =16 #xED %AX %DX        "Input from port")
(out    #xE6 Ub %AL             "Output to port")
(out    #xE7 Ub %eAX            "Output to port")
(out    =16 #xE7 Ub %AX         "Output to port")
(out    #xEE %DX %AL            "Output to port")
(out    #xEF %DX %eAX           "Output to port")
(out    =16 #xEF %DX %AX        "Output to port")
(inc    (+ #x40 Gv)             "Increment Gv by 1" (%OF %SF %ZF %AF %PF))
(inc    #xFE (/0 Eb)            "Increment Eb by 1" (%OF %SF %ZF %AF %PF))
(inc    #xFF (/0 Ev)            "Increment Ev by 1" (%OF %SF %ZF %AF %PF))
(insb   #x6C                    "Input from port to string" (%DI))
(insw   =16 #x6D                "Input from port to string" (%DI))
(insd   =32 #x6D                "Input from port to string" (%EDI))
(outsb  #x6E                    "Output to port from string" (%SI))
(outsw  =16 #x6F                "Output to port from string" (%SI))
(outsd  =32 #x6F                "Output to port from string" (%ESI))
(int    #xCD Ub           	"Interrupt vector number specified by immediate byte" #t) ; confused about dirtiness... [bts]
(int.3  #xCC                    "Interrupt 3 -- Trap to debugger" #t) ; ditto
(into   #xCE                    "Interrupt 4 -- if overflow flag is 1" #t) ; ditto
(iret   =16 #xCF                "Interrupt return" #t)
(iretd  =32 #xCF                "Interrupt return" #t)
(j      (? #x70) Jb             "Jump short if condition")
(j      #x0F (? #x80) Jv        "Jump near if condition")
(jcxz   =16 #xE3 Jb             "Jump short if CX register is 0")
(jecxz  =32 #xE3 Jb             "Jump short if ECX register is 0")
(jmp    #xEB Jb                 "Jump short, relative")
(jmp    #xE9 Jv                 "Jump near, relative")
(jmp    #xFF (/4 Ev)            "Jump near, absolute indirect, address given in Ev")
(jmpf   #xFF (/5 Mv)            "Jump far, absolute indirect, address given in Mv")

;(jmpf   #xEA Ov                 "Jump far, absolute, address given in operand")

(lahf   #x9F                    "Load status flags into AH" (%AH))
(lar    #x0F #x02 (/r Gv Ev)    "Load access rights byte" (%ZF))
(lds    #xC5 (/r Gv Mv)         "Load DS and Gv with far pointer from memory")
(les    #xC4 (/r Gv Mv)         "Load ES and Gv with far pointer from memory")
(lss    #x0F #xB2 (/r Gv Mv)    "Load SS and Gv with far pointer from memory")
(lfs    #x0F #xB4 (/r Gv Mv)    "Load FS and Gv with far pointer from memory")
(lgs    #x0F #xB5 (/r Gv Mv)    "Load GS and Gv with far pointer from memory")
(lea    #x8D (/r Gv Mv)         "Load effective address")
(leave  #xC9                    "Leave procedure" (%ESP %SP %EBP %EP))
(lgdt   #x0F #x01 (/2 Mv)       "Load global descriptor table")
(lidt   #x0F #x01 (/3 Mv)       "Load interrupt descriptor table")
(sgdt   #x0F #x01 (/0 Mv)       "Store global descriptor table")
(sidt   #x0F #x01 (/1 Mv)       "Store interrupt descriptor table")
(lldt   #x0F #x00 (/2 Ew)       "Load local descriptor table")
(sldt   #x0F #x00 (/0 Ev)       "Store local descriptor table")
(lmsw   #x0F #x01 (/6 Ew)       "Load machine status word")
(smsw   #x0F #x01 (/4 Ev)       "Store machine status word")
(lodsb  #xAC                    "Load string byte" (%AL %SI))
(lodsw  =16 #xAD                "Load string word" (%AX %SI))
(lodsd  =32 #xAD                "Load string word" (%EAX %ESI))
(loop   #xE2 Jb                 "Loop according to ECX" (%ECX))
(loope  #xE1 Jb                 "Loop according to ECX" (%ECX))
(loopz  #xE1 Jb                 "Loop according to ECX" (%ECX))
(loopne #xE0 Jb                 "Loop according to ECX" (%ECX))
(loopnz #xE0 Jb                 "Loop according to ECX" (%ECX))
(lsl    #x0F #x3 (/r Gv Ev)     "Load segment limit" (%ZF))
(ltr    #x0F #x00 (/3 Ew)       "Load task register")
(str    #x0F #x00 (/1 Ew)       "Store task register")

(mov    #x88 (/r Eb Gb)         "Move Gb to Eb")
(mov    #x89 (/r Ev Gv)         "Move Gv to Ev")
(mov    #x8A (/r Gb Eb)         "Move Eb to Gb")
(mov    #x8B (/r Gv Ev)         "Move Ev to Gv")
(mov    #xA0 %AL Ob             "Move byte at (seg:offset) to AL")
(mov    #xA1 %eAX Ov            "Move doubleword at (seg:offset) to EAX")
(mov    #xA2 Ob %AL             "Move AL to (seg:offset)")
(mov    #xA3 Ov %eAX            "Move EAX to (seg:offset)")
(mov    (+ #xB0 Gb) Ib          "Move Ib to Gb")
(mov    (+ #xB8 Gv) Iv          "Move Iv to Gv")
(mov    #xC6 (/0 Eb) Ib         "Move Ib to Eb")
(mov    #xC7 (/0 Ev) Iv         "Move Iv to Ev")
(mov    (+ #xB0 Gb) Ub          "Move Ub to Gb")
(mov    (+ #xB8 Gv) Uv          "Move Uv to Gv")
(mov    #xC6 (/0 Eb) Ub         "Move Ub to Eb")
(mov    #xC7 (/0 Ev) Uv         "Move Uv to Ev")

(mov   =16 #x89 (/r Ew Gw)      "Move Gw to Ew")
(mov   =16 #x8B (/r Gw Ew)      "Move Ew to Gw")
(mov   =16 #xA1 %AX Ow          "Move word at (seg:offset) to AX")
(mov   =16 #xA3 Ow %AX          "Move AX to (seg:offset)")
(mov   =16 (+ #xB8 Gw) Iv       "Move Iv to Gw")
(mov   =16 #xC7 (/0 Ew) Iv      "Move Iv to Ew")
(mov   =16 (+ #xB8 Gw) Uv       "Move Uv to Gw")
(mov   =16 #xC7 (/0 Ew) Uv      "Move Uv to Ew")

(movsb  #xA4                    "String move" (%ESI %EDI))
(movsw  =16 #xA5                "String move" (%ESI %EDI))
(movsd  =32 #xA5                "String move" (%ESI %EDI))
(movsx  #x0F #xBE (/r Gv Eb)    "Move with sign-extension")
(movsx  #x0F #xBF (/r Gv Ew)    "Move with sign-extension")
(movzx  #x0F #xB6 (/r Gv Eb)    "Move with zero-extension")
(movzx  #x0F #xB7 (/r Gv Ew)    "Move with zero-extension")
(mul    #xF6 (/4 Eb)            "Unsigned multiply" (%EAX %OF %CF %SF %ZF %AF %PF))
(mul    #xF7 (/4 Ev)            "Unsigned multiply" (%OF %CF %SF %ZF %AF %PF))
(neg    #xF6 (/3 Eb)            "Arithmetic negative" (%CF %OF %SF %ZF %AF %PF))
(neg    #xF7 (/3 Ev)            "Arithmetic negative" (%CF %OF %SF %ZF %AF %PF))
(nop    #x90                    "No op")
(not    #xF6 (/2 Eb)            "Bitwise not")
(not    #xF7 (/2 Ev)            "Bitwise not")
(pop    (+ #x58 Gv)             "Pop from stack" (%ESP))
(pop    #x8F (/0 Ev)            "Pop from stack" (%ESP))
(pop    #x1F %DS                "Pop from stack" (%ESP))
(pop    #x07 %ES                "Pop from stack" (%ESP))
(pop    #x17 %SS                "Pop from stack" (%ESP))
(pop    #x0F #xA1 %FS           "Pop from stack" (%ESP))
(pop    #x0F #xA9 %GS           "Pop from stack" (%ESP))
(popa   =16 #x61                "Pop all general regs from stack" #t)
(popad  =32 #x61                "Pop all general regs from stack" #t)
(popf   =16 #x9D                "Pop into eflags register" #t) ; not quite, most flags
(popfd  =32 #x9D                "Pop into eflags register" #t) ;        ""
(push   (+ #x50 Gv)             "Push to stack" (%ESP))
(push   #x6A Ib                 "Push byte to stack" (%ESP))
(push   #x68 Iv                 "Push dword to stack" (%ESP))
(push   #x0E %CS                "Push to stack" (%ESP))
(push   #x1E %DS                "Push to stack" (%ESP))
(push   #x06 %ES                "Push to stack" (%ESP))
(push   #x16 %SS                "Push to stack" (%ESP))
(push   #x0F #xA0 %FS           "Push to stack" (%ESP))
(push   #x0F #xA8 %GS           "Push to stack" (%ESP))
(push   #xFF (/6 Ev)            "Push to stack" (%ESP))
(pusha  =16 #x60                "Push all general regs to stack" (%ESP))
(pushad =32 #x60                "Push all general regs to stack" (%ESP))
(pushf  =16 #x9C                "Push eflags register" (%ESP))
(pushfd =32 #x9C                "Push eflags register" (%ESP))
(rcl    #xD0 (/2 Eb)            "Rotate left through carry" (%CF %OF))
(rcl    #xD1 (/2 Ev)            "Rotate left through carry" (%CF %OF))
(rcl    #xD2 (/2 Eb) %CL        "Rotate left through carry" (%CF %OF))
(rcl    #xD3 (/2 Ev) %CL        "Rotate left through carry" (%CF %OF))
(rcl    #xC0 (/2 Eb) Ub         "Rotate left through carry" (%CF %OF))
(rcl    #xC1 (/2 Ev) Ub         "Rotate left through carry" (%CF %OF))
(rcr    #xD0 (/3 Eb)            "Rotate right through carry" (%CF %OF))
(rcr    #xD1 (/3 Ev)            "Rotate right through carry" (%CF %OF))
(rcr    #xD2 (/3 Eb) %CL        "Rotate right through carry" (%CF %OF))
(rcr    #xD3 (/3 Ev) %CL        "Rotate right through carry" (%CF %OF))
(rcr    #xC0 (/3 Eb) Ub         "Rotate right through carry" (%CF %OF))
(rcr    #xC1 (/3 Ev) Ub         "Rotate right through carry" (%CF %OF))
(rol    #xD0 (/0 Eb)            "Rotate left" (%CF %OF))
(rol    #xD1 (/0 Ev)            "Rotate left" (%CF %OF))
(rol    #xD2 (/0 Eb) %CL        "Rotate left" (%CF %OF))
(rol    #xD3 (/0 Ev) %CL        "Rotate left" (%CF %OF))
(rol    #xC0 (/0 Eb) Ub         "Rotate left" (%CF %OF))
(rol    #xC1 (/0 Ev) Ub         "Rotate left" (%CF %OF))
(ror    #xD0 (/1 Eb)            "Rotate right" (%CF %OF))
(ror    #xD1 (/1 Ev)            "Rotate right" (%CF %OF))
(ror    #xD2 (/1 Eb) %CL        "Rotate right" (%CF %OF))
(ror    #xD3 (/1 Ev) %CL        "Rotate right" (%CF %OF))
(ror    #xC0 (/1 Eb) Ub         "Rotate right" (%CF %OF))
(ror    #xC1 (/1 Ev) Ub         "Rotate right" (%CF %OF))
(sal    #xD0 (/4 Eb)            "Shift arithmetic left" (%CF %OF %SF %ZF %PF))
(sal    #xD1 (/4 Ev)            "Shift arithmetic left" (%CF %OF %SF %ZF %PF))
(sal    #xD2 (/4 Eb) %CL        "Shift arithmetic left" (%CF %OF %SF %ZF %PF))
(sal    #xD3 (/4 Ev) %CL        "Shift arithmetic left" (%CF %OF %SF %ZF %PF))
(sal    #xC0 (/4 Eb) Ub         "Shift arithmetic left" (%CF %OF %SF %ZF %PF))
(sal    #xC1 (/4 Ev) Ub         "Shift arithmetic left" (%CF %OF %SF %ZF %PF))
(shl    #xD0 (/4 Eb)            "Shift left" (%CF %OF %SF %ZF %PF))
(shl    #xD1 (/4 Ev)            "Shift left" (%CF %OF %SF %ZF %PF))
(shl    #xD2 (/4 Eb) %CL        "Shift left" (%CF %OF %SF %ZF %PF))
(shl    #xD3 (/4 Ev) %CL        "Shift left" (%CF %OF %SF %ZF %PF))
(shl    #xC0 (/4 Eb) Ub         "Shift left" (%CF %OF %SF %ZF %PF))
(shl    #xC1 (/4 Ev) Ub         "Shift left" (%CF %OF %SF %ZF %PF))
(sar    #xD0 (/7 Eb)            "Shift arithmetic right" (%CF %OF %SF %ZF %PF))
(sar    #xD1 (/7 Ev)            "Shift arithmetic right" (%CF %OF %SF %ZF %PF))
(sar    #xD2 (/7 Eb) %CL        "Shift arithmetic right" (%CF %OF %SF %ZF %PF))
(sar    #xD3 (/7 Ev) %CL        "Shift arithmetic right" (%CF %OF %SF %ZF %PF))
(sar    #xC0 (/7 Eb) Ub         "Shift arithmetic right" (%CF %OF %SF %ZF %PF))
(sar    #xC1 (/7 Ev) Ub         "Shift arithmetic right" (%CF %OF %SF %ZF %PF))
(shr    #xD0 (/5 Eb)            "Shift unsigned right" (%CF %OF %SF %ZF %PF))
(shr    #xD1 (/5 Ev)            "Shift unsigned right" (%CF %OF %SF %ZF %PF))
(shr    #xD2 (/5 Eb) %CL        "Shift unsigned right" (%CF %OF %SF %ZF %PF))
(shr    #xD3 (/5 Ev) %CL        "Shift unsigned right" (%CF %OF %SF %ZF %PF))
(shr    #xC0 (/5 Eb) Ub         "Shift unsigned right" (%CF %OF %SF %ZF %PF))
(shr    #xC1 (/5 Ev) Ub         "Shift unsigned right" (%CF %OF %SF %ZF %PF))
(ret    #xC2 Iw                 "Near return and pop Iw bytes from stack" (%ESP)) ; ??? is this true [bts]
(ret    #xC3                    "Near return" (%ESP)) ; ??? is this true [bts]
(retf   #xCA Iw                 "Far return and pop Iw bytes from stack" (%ESP)) ; ??
(retf   #xCB                    "Far return" (%ESP)) ; ??
(rsm    #x0F #xAA               "Resume from system management mode" #t)
(sahf   #x9E                    "Store AH into flags" (%SF %ZF %AF %PF %CF))
(scasb  #xAE                    "String scan" (%EDI %OF %SF %ZF %AF %PF %CF))
(scasw  =16 #xAF                "String scan" (%EDI %OF %SF %ZF %AF %PF %CF))
(scasd  =32 #xAF                "String scan" (%EDI %OF %SF %ZF %AF %PF %CF))
(set    #x0F (? #x90) (/0 Eb)   "Set byte if condition")
(shld   #x0F #xA4 (/r Ev Gv) Ub  "Double precision shift left" (%CF %SF %ZF %PF %OF %AF))
(shld   #x0F #xA5 (/r Ev Gv) %CL "Double precision shift left" (%CF %SF %ZF %PF %OF %AF))
(shrd   #x0F #xAC (/r Ev Gv) Ub  "Double precision shift right" (%CF %SF %ZF %PF %OF %AF))
(shrd   #x0F #xAD (/r Ev Gv) %CL "Double precision shift right" (%CF %SF %ZF %PF %OF %AF))
(stosb  #xAA                    "String store" (%EDI))
(stosw  =16 #xAB                "String store" (%EDI))
(stosd  =32 #xAB                "String store" (%EDI))
(verr   #x0F #x00 (/4 Ew)       "Verify segment for reading" (%ZF))
(verw   #x0F #x00 (/5 Ew)       "Verify segment for writing" (%ZF))
(xchg   (+ #x90 Gv) %eAX        "Exchange")
(xchg   %eAX (+ #x90 Gv)        "Exchange")
(xchg   #x86 (/r Gb Eb)         "Exchange")
(xchg   #x86 (/r Eb Gb)         "Exchange")
(xchg   #x87 (/r Gv Ev)         "Exchange")
(xchg   #x87 (/r Ev Gv)         "Exchange")
(xlatb  #xD7                    "Byte table lookup" (%EAX))


;;this one is only legal before certain instructions:
(lock:  #xF0                    "The lock prefix") 

(repne: #xF2                    "Repeat prefix (only for string instructions)")
(repnz: #xF2                    "Synonym for REPNE")
(rep:   #xF3                    "Repeat prefix (only for string instructions)")
(repe:  #xF3                    "Synonym for REP")
(repz:  #xF3                    "Synonym for REP")

(cs:    #x2E                    "Segment override prefix")
(ss:    #x36                    "Segment override prefix")
(ds:    #x3E                    "Segment override prefix")
(es:    #x26                    "Segment override prefix")
(fs:    #x64                    "Segment override prefix")
(gs:    #x65                    "Segment override prefix")

(operand-size-prefix: #x66      "Intel brain damage")
(address-size-prefix: #x67      "Intel brain damage")


;(#x8C /r   MOV r/m16   Sreg    "Move segment register to r/m16")
;(#x8E /r   MOV Sreg    r/m16   "Move r/m16 to segment register")

;; FIXME: r/m32 in the 4 below are all actually required to be r32
;; (though encoded like r/m32)

;;(movcr #x0F #x22 (/s Sv Gv)     "Move to control register")

;;(movcr #x0F #x20 (/s Gv Sv)     "Move from control register")

;(#x0F #x20 /r MOV cr r/m32       "Move to control register")
;(#x0F #x22 /r MOV r/m32 cr       "Move from control register")

;(#x0F #x21 /r MOV r/m32 dr       "Move from debug register")
;(#x0F #x23 /r MOV dr r/m32       "Move to debug register")