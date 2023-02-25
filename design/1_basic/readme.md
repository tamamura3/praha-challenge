# 課題1
## SOLID原則とは（メリットも含めて説明）
変更に強いソフトウェアを作るための5つの設計原則の頭文字を取った言葉。
1. Single Responsibility Principle：単一責任の原則
メリット：修正時の影響範囲を小さく保てる

クラスは一つだけの責務を持つべきであるという原則。ここでの責務というのは、そのクラスを利用するアクターに対する責務を意味する。つまり、各クラスはアクターと1対1で紐づいているべきであるということ。

アクターとは、ソフトウェアを利用するユーザーや役割を指す。
システムの変更要求はアクターから生まれるため、クラスが複数アクターに対する責務を負っていると、一つの変更が他のアクターのユースケースにも影響してしまう。

参考：https://www.ogis-ri.co.jp/otc/hiroba/others/OOcolumn/single-responsibility-principle.html  
https://dev.to/abh1navv/how-solid-is-your-code-single-responsibility-principle-4b7l


2. Open/closed principle：オープン/クロースドの原則

ソフトウェアの構成要素（クラス、関数など）は拡張に対して開かれていて（Open）修正に対して閉じて（closed）いなければならないという原則。つまり、拡張はしやすいが、修正時は既存の成果物を変更する必要がないような設計にするべきということ。

参考：https://zenn.dev/rafael612/articles/5d68b432d219f8

3. Liskov substitution principle：リスコフの置換原則

クラスを継承するときに、スーパークラスとサブクラスを入れ替えても動くようにするべきという原則。is-aの関係が成り立っているからとよく考えずにクラス設計すると、あるサブクラスで矛盾が生まれてしまうことがある。

参考：https://www.membersedge.co.jp/blog/typescript-solid-liskov-substitution-principle/

4. Interface segregation principle：インターフェース分離の原則

インターフェースとその利用者がいるとき、利用者にとって必要のないメソッドやプロパティに依存しなくていいようにインターフェースを分割すべきであるという原則。

参考：https://www.membersedge.co.jp/blog/typescript-solid-interface-segregation-principle/

5. Dependency inversion principle：依存性逆転の原則
あるモジュールが別のモジュールを利用するとき、間に共有された抽象（インターフェースや抽象クラスなど）に依存するべきという原則。

## 単一責任の原則とファイルを分割することの違い
単一責任の原則は設計原則なので、結果的にクラスが増えてファイルが増えるかもしれないが、極端な話ファイルを分割しなくても実現できる。
一方ファイル分割はプログラムが見やすいようにクラスなどの単位でファイルを分けることなので、単一責任の原則とは関係なく実施される。

## Open-Closed-Principleの例
[こちら](https://www.digitalocean.com/community/conceptual-articles/s-o-l-i-d-the-first-five-principles-of-object-oriented-design#open-closed-principle)を参考にした。

円や正方形のような図形の配列を受け取り面積の合計値を出すAreaCaluculatorがある。

```Typescript
class Circle {
    public radius: number = 0;
    constructor(radius: number) {
        this.radius = radius;
    }
}

class Square {
    public length: number = 0;
    constructor(length: number) {
        this.length = length;
    }
}

class AreaCalculator {
    private shapeList: any[];
    constructor(shapeList: any[]) {
        this.shapeList = shapeList;
    }
    public sum(): number {
        let result: number = 0;
        this.shapeList.forEach((shape) => {
            if (shape instanceof Circle) {
                result += Math.pow(shape.radius, 2) * Math.PI;
            } else if (shape instanceof Square) {
                result += Math.pow(shape.length, 2);
            }
        });
        return result;
    }
}

const areaCalculator = new AreaCalculator([new Square(5), new Circle(3)]);
console.log(areaCalculator.sum());
```
上の例だと、例えば長方形も計算できるようにする場合、クラスの追加とAreaCalculatorの修正が必要になる。

これをOpen-Closed-principleに沿うように直すと、次の通り各図形でクラスを作成しAreaCalculatorのif文を無くす方法が考えられる。

これなら長方形を追加する場合はクラスの追加だけで済み、AreaCalculatorは手を加えなくていい。
```typescript
interface ShapeInterface {
    area(): number;
}

class Circle {
    public radius:number = 0;
    constructor(radius: number) {
        this.radius = radius;
    }

    public area(): number {
        return Math.pow(this.radius, 2) * Math.PI;
    }
}

class Square {
    public length: number = 0;
    constructor(length: number) {
        this.length = length;
    }

    public area(): number {
        return Math.pow(this.length, 2)
    }
}

class AreaCalculator {
    private shapeList: any[];
    constructor (shapeList: any[]) {
        this.shapeList = shapeList;
    }
    public sum(): number {
        return this.shapw
        return this.shapeList.reduce((acc, shape) => 
            acc += shape.area(), 0)
    }
}

const areaCalculator = new AreaCalculator([new Square(5), new Circle(3)]);
console.log(areaCalculator.sum());
```

## リスコフの置換原則に違反した場合の不都合は？
原則に違反するということは、適切でないサブクラスが存在するということなので、そのサブクラスを利用した処理の中でバグが発生する可能性がある。

## インターフェースを用いることの設計上のメリット
- クラスをインターフェースに依存させることでクラス関係を抽象化でき、変更時の影響範囲が小さくなるような設計にできる
- サブクラスに対して必要な関数の実装を強制できるので、今後作られるサブクラスにも必要な実装がされることが担保できる

## 依存性の逆転を用いる必要があるのはどんなとき？
変更が見込まれるモジュールAに他のモジュールBが依存している場合、モジュールAが変更される度にモジュールBも影響を受けるため、依存性の逆転を使う必要がある。

## デメトルの法則とは（メリットも含めて説明）
「親クラス.子クラス.子クラスのメソッド」のように、直接のオブジェクトを経由してさらに別のオブジェクトにアクセスするのを避けるべきという法則。

この法則を守ることのメリット。
- 単体テストがしやすくなる
    - ユニットテストでは自分以外のオブジェクトはモックにして常に同じ値を返すようにしてテストするのが一般的なので、関係するオブジェクトが多いとそれだけモックがたくさん必要になる。
- コード変更の影響範囲を小さく保つことができる。
    - 関係するオブジェクトが多いと、それだけあるオブジェクトの変更の影響が及ぶ範囲も多くなる。デメトルの法則で結合度を低く保つことができる。


https://qiita.com/br_branch/items/37cf71dd5865cae21401

## 新人が書いたコードについて
setter/getterを用意するだけでは結局外部からデータを参照できるのでデメトルの法則に対処できているわけではない。

下記がデメトルの法則を守るのに良いらしい。
- クラス設計を見直してオブジェクトをいくつもまたいで参照しないようにする
- 他オブジェクトに状態を訪ねてその結果で処理するのではなく、他オブジェクトそのものに処理をさせる（Don't tell ask）

# 課題2
## コードの問題点
- 過去の購入履歴を全て取得してからアプリ側で絞り込んでいるので、購入履歴の数によっては性能の問題が発生する

## コードの修正案
ユーザーの平均購入履歴数を考慮して性能を満たせる場合は、今のままSQLで全取得してアプリで絞り込む。

性能を満たせない場合は、SQLで絞り込んで、アプリで結果だけ受け取り分岐させる。

各仕様変更があった場合の対応どうするか
- 「1年以内から2年以内」はアプリまたはSQLで絞り込む際の日付部分を変更して対応。
- 「プレミアム会員の場合は何個でも購入可能」はアプリでこの判定処理自体を通らないよう修正して対応。
- 「プレミアムは3カ月以内、それ以外は1年以内」という変更が仮にあった場合、SQLで対応する場合はwhere句をバインドできる仕組みが必要。

# 課題3
## コードの問題点
- フィールドがpublicなので、意図せず誤った値に更新してしまう恐れがある

## 解決法
- クラスをカプセル化するため、フィールドをprivateにしてそれぞれ適切なgetter/setterを設定する。
    - PersonクラスのnameとstarWorkingAtは途中で変更する必要はないので、getterだけ作成し読み取りだけにする。名前を変更したい場合はそのための関数を作成する。
    - Companyクラスのpeopleは、リストの追加と削除を行うと想像できるので、それぞれの関数を用意する。getterとsetterは不要。

# 任意課題
[このスライド](https://fortee.jp/object-oriented-conference-2020/proposal/a826b6c6-167c-4c5c-bfc7-52bb8bc22ec1)がコードの例もありきれいにまとまっていた。

凝集度については、偶発的凝集は通常起こりえないので除き、論理的凝集～逐次的凝集の間の状態に関して、ケースバイケースだが気を付けるべきポイントがあると述べられている。
必ずしも一番理想的な機能的凝集になるべきというわけではないし、そもそもできないこともある。

結合度については、内部結合は起こりえないとして、共通結合と外部結合は避けるべき、制御結合は極力避けるべきだと書かれている。
こちらはなるべく理想形であるスタンプ結合、データ結合、メッセージ結合に近づけた方が良いとのこと。

## 凝集度（cohesion）
単体のモジュールの中の要素（データ、関数）がどれだけ関連しているかを示す。
凝集度が高い・・全てのデータ、関数が一つの機能に関連している
凝集度が低い・・データ、関数がそれぞれ複数の機能に関連している
凝集度は高い方が良いシステムを作ることができる。

- 偶発的凝集
何を根拠にモジュールになっているか説明できないようなモジュール。
- 論理的凝集
関連したいくつかの機能を持っていて、呼び出しモジュールによって選択され実行するモジュール。
例：イベントによる処理の振り分け、フラグによる処理の振り分け
- 時間的凝集
関連の少ないいくつかの機能を逐次的（特定のタイミング）に実行するモジュール。
実行順に意味はない。
例：初期化処理、終了処理
- 手続き的凝集
仕様によって定められた関連の少ない機能を逐次的に実行するモジュール。
実行順に意味がある。
例：ファイル存在チェック→開いて読み込み→閉じるのような一連の処理
- 通信的凝集
複数の処理がありそれぞれ同じ値をインプットにするモジュール。
- 逐次的凝集
一つの関数のアウトプットが他の関数のアウトプットになるモジュール。
- 機能的凝集
一つの固有の機能を実行するモジュール。

https://www.ogis-ri.co.jp/otc/hiroba/technical/Cohesion_Coupling/Cohesion_Coupling.html

## 結合度（Coupleing）
モジュール同士がどれだけ依存しているかを示す。
結合度が高い・・モジュール同士が密接に関係しているため、一つの変更が他のモジュールに大きく影響する状態
結合度が低い・・モジュール同士が独立していて、一つの変更が他のモジュールにあまり影響しない状態
結合度が低い方がメンテナンスしやすいシステムを作ることができる。

結合度には種類があり、結合度が低い順に並べると次の通り。
- メッセージ結合
引数なしで呼び出すパターン。
- データ結合
引数で構造化されていないデータ（string, intなど）を渡すパターン。
- スタンプ結合
引数で構造化されたデータ（オブジェクト、構造体など）を渡すパターン。
- 制御結合
引数の種類によって処理の内容が変わるパターン。
- 外部結合
モジュールがシステムの外部に依存しているパターン。
構造を持たないデータを複数モジュールで共有すること、とも書いてある。
- 共通結合
グローバル領域のデータを複数モジュールで共有しているパターン。
- 内部結合
他のオブジェクトの内部の直接操作するパターン。


# 感想
## Single responsibility principle
SRPについて調べてみたが、定義が曖昧で結局よくわからなかった。

1クラスに対して1アクターが紐づけば良いのであれば、例えばテキスト編集と印刷どちらも同じアクター（ユーザー）が行うとしたら次のようなクラスを作れる。
ただこれは二つの別の概念なのでクラスを分けた方がいいように思う。

```Typescript
class TextManipulator {
    private text: string;

    constructor(text: string) {
        this.text = text;
    }

    public getText(): string {
        return this.text;
    }

    // テキストの編集処理
    public appendText(newText: string): void {
        this.text = this.text.concat(newText);
    }

    // テキストの印刷処理
    public printText(): void {
        // 印刷処理
    }
}
```

では他に定義あるのかと思い調べたら、Agile Software DevelopmentではSRPについて"A class should have only one reason to change"とも書かれているらしい。
reasonというのは例えば上の例だと「ユーザーのテキスト編集処理を変更したい」「ユーザーのテキスト印刷処理を変更したい」などになると考えられるので、確かにこの定義に沿うと上のクラスを分解することになる。

しかし、この定義に沿うと今度は各クラスに1メソッドしか持たせることができなくなる。例えば上の例にclearTextというメソッドがあったら、同じテキストの編集処理なのでappendTextと一緒のクラスに置いても良いと思うが、reason to changeが2つになってしまう？（「ユーザーのテキスト編集処理を変更したい」と「ユーザーのテキスト編集（削除処理）を変更したい」）

なのでreason to changeの定義はよくわからないが、アクターが混在しないというルールを気を付ければ良さそう。
上の例でもし印刷処理は管理ユーザーだけが行うのであれば、アクターが異なるので分けた方が良い、ということになる。

仮に同じアクターだったとしても、クラスは関連する処理だけを扱うようにすれば（これはSRPと関係ないと思うが）、上の例のような責務が多すぎるクラスを作るのは避けることができると思う。

https://sklivvz.com/posts/i-dont-love-the-single-responsibility-principle

# dependency inversion principle
下記記事の例を見たが、これでは依存性逆転の原則のメリットが分からなかった。
これはインターフェースを用意したというよりかは、validateTypeの処理をfetchUserに移動したからaxiosに変更しても変更が関数1個で収まっていると思う。

https://www.membersedge.co.jp/blog/typescript-solid-dependency-inversion-principle/


