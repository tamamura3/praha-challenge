# 課題1
## テスト駆動開発のメリット
- コードを最小限にできる
テストを全て通過することを目指して実装するので、不要なコードが減り必要なコードだけを書くことができる。
- リファクタしやすい
テストが既にあるので、動きを担保しながらリファクタできる。

## テスト駆動開発のデメリット
- コードを書くまでに時間がかかる
先にテストコードを書いてから製品コードを書き始めるので、初動に時間がかかる。
- チームメンバー全員の合意が必要
チームメンバーを説得してチーム全体でTDDを取り入れる必要があるので、導入が難しくなることがある

参考：
https://www.geeksforgeeks.org/advantages-and-disadvantages-of-test-driven-development-tdd/

## 三転測量とは
テストがたまたま通った状態を防ぐため、1つの対象に2つのテストを書く方法のこと。

https://dmitripavlutin.com/triangulation-test-driven-development/

## レッド、グリーン、リファクタリング
レッド・・実装したい機能に必要なテストを先に書き、現段階でテストが失敗することを確認する段階
グリーン・・実際にコードを書き、先のテストにパスすることを確認する段階。この段階ではコードが最適化されていないくでも問題ない。
リファクタリング・・テストをパスすることを担保しつつ、コードをリファクタする段階。

参考：
https://www.codecademy.com/article/tdd-red-green-refactor

## 仮実装
テストを通すためにどんな手段でもいいのでコードを実装すること。

## TDDとBDDとの違い
TDD（Test-driven Development）は単体テストを先に書くことで様々なメリットを享受するソフトウェアの開発方法。
BDD（Befaviour-driven Development）はTDDを実践する中で感じることのある、「どこから始めるか」「何をテストして何をテストしないか」「一度にどこまでテストするのか」などの悩みを解決するために作られた方法。具体的にはドメインエキスパートも理解できるようなユーザー視点の振る舞いをテストに書く。
参考：
https://web-y.dev/2021/07/03/what-is-bdd/
https://dannorth.net/introducing-bdd/
https://semaphoreci.com/blog/test-driven-development#:~:text=The%20invention%20of%20TDD%20is,actual%20code%20that%20needs%20testing.

TDDだと要件が変更したときにバグを生みこんだのかそのテストが不要になってエラーなのかわからない

# 課題2



# 課題3

