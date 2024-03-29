# 課題1
## テスト駆動開発のメリット
- コードを最小限にできる
テストを全て通過することを目指して実装するので、不要なコードが減り最小限のコードで実装できる
- リファクタしやすい
テストが既にあるので、動きを担保しながらリファクタできる

## テスト駆動開発のデメリット
- コードを書くまでに時間がかかる
先にテストを書いてからコードを書き始めるので、初動に時間がかかる
- チームメンバー全員の合意が必要
チームメンバーを説得してチーム全体でTDDを取り入れる必要があるので、導入が難しくなることがある

参考：
https://www.geeksforgeeks.org/advantages-and-disadvantages-of-test-driven-development-tdd/

## 三角測量とは
テストがたまたま通った状態を防ぐため、1つの対象に2つのテストを書く方法のこと。

## レッド、グリーン、リファクタリング
レッド・・実装したい機能に必要なテストを先に書き、現段階でテストが失敗することを確認する段階  
グリーン・・実際にコードを書き、テストにパスすることを確認する段階。この段階ではコードが最適化されていないくても問題ない  
リファクタリング・・テストをパスすることを担保しつつ、コードをリファクタする段階

## 仮実装
テストを通すためにどんな手段でもいいのでコードを実装すること。

参考：
https://dev.classmethod.jp/articles/what-tdd/
https://www.codecademy.com/article/tdd-red-green-refactor

## TDDとBDDとの違い
TDD（Test-driven Development）は単体テストを先に書くことで様々なメリットを享受するソフトウェアの開発方法。  
BDD（Befaviour-driven Development）は振る舞いに分けてテストを作る手法。  
  
TDDを実践する中で感じることのある「どこから始めるか」「何をテストして何をテストしないか」などの悩みを解決するために作られた方法。  
アプリの外部的な振る舞いを定義して、それに沿ってテストを作る。そのため、BDDならテストを見ると機能の仕様が分かる。  
Given, When, Thenなどのキーワードに沿って機能の振る舞いを書き出し、それに沿ってテストを作成する。

参考：
https://web-y.dev/2021/07/03/what-is-bdd/  
https://www.functionize.com/automated-testing/behavior-driven-development  
https://www.youtube.com/watch?v=4e9vhX7ZuCw&list=PLhW3qG5bs-L_mFHirOLEYJ7X2rIXu8SR2

# 課題2
テスト  
https://github.com/tamamura3/praha-challenge-templates/blob/master/jestSample/__tests__/tdd_practice.test.js  
コード  
https://github.com/tamamura3/praha-challenge-templates/blob/master/jestSample/script.js  
