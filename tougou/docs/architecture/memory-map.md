# メモリマップ

Goal: 主要セクション / アドレス範囲を理解し不整合を防ぐ。以下は `build/linker.ld` に基づく初期値。

| 領域 | 開始アドレス | 用途 / 備考 |
|------|--------------|-------------|
| .text (含 .init) | 0x00008000 | 実行コード先頭 (ENTRY=_start) |
| .rodata | 続き | リードオンリーデータ |
| .data | 続き | 初期化済データ |
| .bss  | 続き | 未初期化領域 (起動時 0 クリア) |
| Stack | (動的確保) | 上位アドレス側から確保 (未固定) |
| GPIO  | 0x3F200000 | GPIO レジスタベース (`GPIO_BASE`) |
| TIMER | 0x3F003000 | System Timer (`TIMER_BASE`, CLO/CHI オフセット) |
| PWM   | 0x3F20C000 | PWM レジスタベース (`PWM_BASE`) |
| CM    | 0x3F101000 | Clock Manager (`CM_BASE`, PWM クロック設定) |

確定が必要な点: 実機 RAM サイズ / I/O ベースアドレス。リンカスクリプトは RAM 長さを暫定 16M としている。

## 更新手順

1. 新領域追加時は衝突しないか確認
2. `linker.ld` 変更 → この表を同期
3. `make dump` でセクションレイアウト確認 (`firmware.dump`)

## 追加検討事項

- 重要レジスタ表 (GPIO, PWM) 詳細化
- DMA / Mailbox 利用時の予約領域
- RAM 容量確定後に Stack / Heap 目安図追記

### BSS クリア例 (擬似アセンブリ)

```arm
ldr r0, =__bss_start
ldr r1, =__bss_end
mov r2, #0
bss_loop:
	cmp r0, r1
	bge bss_done
	str r2, [r0], #4
	b bss_loop
bss_done:
```
