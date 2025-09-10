# 命令 & パターン集

Goal: 頻出命令 / イディオムを統一スタイルで使用するための備忘。

## 例: ループ

```arm
mov r0, #N
loop_label:
    ; ... body ...
    subs r0, r0, #1
    bne loop_label
```

## 例: 関数呼出

```arm
push {r4, lr}
; set args in r0-r3
bl target_func
pop {r4, lr}
bx lr
```

## TODO

- 最適化 / サイズ短縮テク
- 分岐予測考慮メモ
