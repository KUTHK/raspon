# 1. 重複ファイルのうち残さないものを to_delete.txt に保存
fdupes -r . | awk '
  NF { files[++n]=$0 }
  /^$/ && n>1 {
    print "重複ファイルグループ:"
    for(i=1;i<=n;i++) print i") "files[i]
    printf "残す番号を入力してください: "
    getline keep < "/dev/tty"
    for(i=1;i<=n;i++) if(i!=keep) print files[i] >> "to_delete.txt"
    n=0
    delete files
    print ""
  }
'

# 2. 内容を確認
echo "削除候補ファイルを to_delete.txt に保存しました。内容を確認してください。"

# 3. 一括削除（必要なら実行）
# git rm $(cat to_delete.txt)