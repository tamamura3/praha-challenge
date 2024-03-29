# 課題1
## スナップショットテストとは何か
スナップショットテストとはコンポーネントの新旧の状態を比較して差分が生まれていないかを確認するリグレッションテストの方法。  
コンポーネントのデータはテキストファイルに保存されdiffで比較される。  
スナップショットテストはユニットテストとは異なり、出力結果が正しいかどうかは判定できない。  
代わりに、今の出力結果が昔の出力結果と異なるかどうかだけを検出する。

参考：
https://jestjs.io/docs/snapshot-testing

## スナップショットテストを用いることで防止できる不具合
- あるボタンのデザインを変更したらいくつかのスナップショットテストが落ちた。このボタンが想定外の画面で利用されていることに気づけた。
- あるボタンのデザインを変更したらスナップショットテストでボタン以外の箇所で差分が出た。この変更が想定外の箇所に影響していることに気づけた。

## スナップショットでも防止できない不具合
- あるボタンのデザインを変更してスナップショットテストの差分が問題なかったので承認した。しかし既存のデザイン不備があり検知できなかった。
- あるボタンのデザインを変更してスナップショットテストの差分が問題なかったので承認した。しかしよく見ると仕様通りでない実装があり誰も気づけなかった。
- あるボタンのCSSを変更した。しかしスナップショット上にCSSの変更が現れなかったため差分が検知できず不具合が生まれた。
- あるボタンのクリック時の処理を変更した。しかしスナップショット上に処理の変更が現れないため差分が検知できず不具合が生まれた。

# 課題2
下記リポジトリを参照  
https://github.com/tamamura3/react_tutorial

## やったことメモ（自分用）
- [Storyshotsのページ](https://storybook.js.org/addons/@storybook/addon-storyshots)でインストール
    - Storyshots.test.jsを作るところまで
- エラーが発生したのでApp.jsを作成し各コンポーネントの実装を移動。index.jsにはcreateRootだけ記載。
    - 参考：https://stackoverflow.com/questions/39986178/testing-react-target-container-is-not-a-dom-element
- 別のエラーが発生したのでpackage.jsonにreact-test-rendererを追記。npm installを実行
    - 参考：https://github.com/storybookjs/storybook/issues/17985#issuecomment-1310403434

# 課題3
Q1: スナップショットテストのメリットは何か？  
Q2: スナップショットテストのデメリットは何か？  
Q3: StorybookのSnapshotsが対応しているフレームワークは何か？