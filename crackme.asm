
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; ASTRAL 2010 MASM32 Crackme
; ++Meat code & technics
; http://astral.tuxfamily.org/
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
    include \masm32\include\masm32rt.inc
    include sys\Xbutton.asm
;include masm32.inc		;nseed ve nrandom
;includelib masm32.lib
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

WndProc     PROTO :DWORD,:DWORD,:DWORD,:DWORD
TopXY       PROTO :DWORD,:DWORD
produce     PROTO :DWORD
check       PROTO :DWORD

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

.const

sBg     = 1000
sKey    = 1001
sKey2 =  1002
bCheck  = 2000

BgOff   = 5000
BgOn    = 5001
BtnOff  = 5002
BtnOn   = 5003
Quit        = 3
Quit2       = 4

KeySize = 32

.data

Table       db "ASTRL"

.data?

hInstance       dd ?
Wx              dd ?
Wy              dd ?
PublicKey       db KeySize dup (?)
PrivateKey      db KeySize dup (?)
UserKey         dd ?

.code

start:

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

    fn GetModuleHandle, NULL
    mov hInstance, eax

    call main

    fn ExitProcess, eax

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

main proc

    Dialog "ASTRAL Crackme 1 * Meat", "Lucida Console", 9,\
            WS_POPUP,\
            2,\
            10, 10, 10, 10,\
            1024

    DlgStatic " ", SS_BITMAP, 0, 0, 1, 1, sBg
    DlgStatic " ",ES_AUTOHSCROLL or ES_CENTER or WS_TABSTOP, 0, 180, 280, 20, sKey
    CallModalDialog hInstance, 0, WndProc, NULL
    ret

main endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM

    .IF (uMsg == WM_DESTROY) || (uMsg == WM_CLOSE)
@@:     exit

    .ELSEIF (uMsg == WM_INITDIALOG)
        fn BitmapFromResource, hInstance, BgOff
        fn SendDlgItemMessage, hWnd, sBg, STM_SETIMAGE, IMAGE_BITMAP, eax

        invoke GetSystemMetrics, SM_CXSCREEN
        invoke TopXY, 300, eax
        mov Wx, eax

        invoke GetSystemMetrics, SM_CYSCREEN
        invoke TopXY, 300, eax
        mov Wy, eax

        fn SetWindowPos, hWnd, 0, Wx, Wy, 480, 290, SWP_NOZORDER

        fn RegisterHotKey, hWnd, NULL, NULL, VK_ESCAPE

        fn XButton, hWnd, 220, 160, BtnOff, BtnOn, bCheck

        fn produce, hWnd

    .ELSEIF (uMsg == WM_HOTKEY)
        jmp @B

    .ELSEIF (uMsg == WM_CTLCOLORSTATIC)
        fn GetDlgCtrlID, lParam
            invoke SetTextColor, wParam, 0FFFFFFh
            invoke SetBkColor, wParam, 0
            invoke GetStockObject, BLACK_BRUSH
            ret

    .ELSEIF (uMsg == WM_LBUTTONDOWN)
        fn SendMessage, hWnd, WM_NCLBUTTONDOWN, HTCAPTION, 0

    .ELSEIF (uMsg == WM_COMMAND)
        mov eax, wParam

        .IF (ax == bCheck)
            fn check, hWnd
            .IF (eax)
                fn BitmapFromResource, hInstance, BgOn
                fn SendDlgItemMessage, hWnd, sBg, STM_SETIMAGE, IMAGE_BITMAP, eax
                fn GetDlgItem, hWnd, bCheck
                fn EnableWindow, eax, FALSE
                fn SetDlgItemText, hWnd, sKey, "~#$* GooD JoB CRaCKeR *** you DiD iT *$#~"
            .ENDIF
        .ENDIF

    .ENDIF

    xor eax, eax
    ret

WndProc endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

TopXY proc wDim:DWORD, sDim:DWORD

    shr sDim, 1      ; divide screen dimension by 2
    shr wDim, 1      ; divide window dimension by 2
    mov eax, wDim    ; copy window dimension into eax
    sub sDim, eax    ; sub half win dimension from half screen dimension

    mov eax, sDim
    ret

TopXY endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл


produce proc hWnd:HWND

	fn GetTickCount
	fn nseed,eax
	
    xor ecx, ecx
    .WHILE ecx < KeySize
        push ecx
        fn nrandom,5
        pop ecx
        add al, '0'
        mov byte ptr [offset PublicKey+ecx], al 
        inc ecx
    .ENDW

    fn SetDlgItemText, hWnd, sKey, ADDR PublicKey

    xor ecx, ecx
    .WHILE ecx < KeySize
        sub byte ptr [offset PublicKey+ecx], '0'
        movzx eax, byte ptr [offset PublicKey+ecx]
        mov bl, byte ptr [offset Table+eax]
        mov byte ptr [offset PrivateKey+ecx], bl
        inc ecx
    .ENDW

    ret

produce endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

check proc hWnd:HWND

    fn exist, "ASTRALKEY"
    or eax, eax
    je badboy

    mov UserKey, InputFile("ASTRALKEY")
    cmp ecx, KeySize
    jne badboy

    fn cmpmem, UserKey, ADDR PrivateKey, KeySize
    
    ret

badboy:
    xor eax, eax
    ret

check endp

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

end start
